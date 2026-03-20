#!/usr/bin/env python3
"""
comix_server.py — manga backend for comix.to
Same HTTP API as manga_server.py so the QML frontend works unchanged.
Port 5151
"""

from __future__ import annotations

import json
import os
import re
import shutil
import threading
import time
from concurrent.futures import ThreadPoolExecutor
from datetime import datetime, timezone
from http.server import BaseHTTPRequestHandler, HTTPServer
from socketserver import ThreadingMixIn
from urllib.parse import parse_qs, unquote, urlparse, quote

import requests

PORT = 5151
BASE = "https://comix.to"

# ── Persistent storage (shared with manga_server.py) ────────────────────────
DATA_DIR       = os.path.expanduser("~/.local/share/quickshell-manga")
FAVORITES_FILE = os.path.join(DATA_DIR, "favorites.json")
DOWNLOADS_DIR  = os.path.join(DATA_DIR, "downloads")
os.makedirs(DATA_DIR,      exist_ok=True)
os.makedirs(DOWNLOADS_DIR, exist_ok=True)

HEADERS = {
    "User-Agent":      "Mozilla/5.0 (X11; Linux x86_64; rv:124.0) Gecko/20100101 Firefox/124.0",
    "Accept":          "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Accept-Language": "en-US,en;q=0.5",
    "Referer":         "https://comix.to/",
}
API_HEADERS = {**HEADERS, "Accept": "application/json"}

session = requests.Session()
session.headers.update(HEADERS)

PAGE_LIMIT = 32

# ── TTL Cache ───────────────────────────────────────────────────────────────
_cache      = {}
_cache_lock = threading.Lock()

TTL_HOT    = 300
TTL_LATEST = 120
TTL_SEARCH = 600
TTL_INFO   = 1800
TTL_PAGES  = 3600


def _cached(key, ttl, fn):
    with _cache_lock:
        entry = _cache.get(key)
    if entry:
        val, expires = entry
        if time.monotonic() < expires:
            return val
    val = fn()
    with _cache_lock:
        _cache[key] = (val, time.monotonic() + ttl)
    return val


# ── Helpers ─────────────────────────────────────────────────────────────────

def _api(path, params=None):
    r = session.get(f"{BASE}/api/v2/{path}", headers=API_HEADERS,
                    params=params, timeout=20)
    r.raise_for_status()
    d = r.json()
    if d.get("status") not in (200, None):
        raise RuntimeError(d.get("message", "API error"))
    return d.get("result")


def proxy_url(img_url):
    if not img_url:
        return ""
    return f"http://127.0.0.1:{PORT}/image?url={quote(img_url, safe='')}"


def _cover(item):
    """Extract best cover URL from a manga item dict."""
    poster = item.get("poster") or {}
    if isinstance(poster, dict):
        url = poster.get("large") or poster.get("medium") or poster.get("small") or ""
    else:
        url = ""
    return url


def _manga_to_card(item):
    """Convert API manga item to the card format expected by QML."""
    cover = _cover(item)
    hid   = item.get("hash_id", "")
    slug  = item.get("slug", hid)
    return {
        "id":        f"{hid}/{slug}",
        "title":     item.get("title", ""),
        "image":     proxy_url(cover),
        "status":    item.get("status", ""),
        "type":      item.get("type", ""),
        "chapter":   str(item.get("latest_chapter", "")),
        "updatedAt": str(item.get("chapter_updated_at", "")),
    }


# ── Hot (most-followed) ─────────────────────────────────────────────────────

def hot_updates():
    return _cached("hot", TTL_HOT, _hot_updates)


def _hot_updates():
    result = _api("manga", {"order[follows_total]": "desc", "limit": PAGE_LIMIT})
    return [_manga_to_card(m) for m in result.get("items", [])]


# ── Latest Updates ──────────────────────────────────────────────────────────

def latest_updates(page=1):
    return _cached(f"latest:{page}", TTL_LATEST, lambda: _latest_updates(page))


def _latest_updates(page):
    result = _api("manga", {
        "order[updated_at]": "desc",
        "limit": PAGE_LIMIT,
        "page":  page,
    })
    items    = result.get("items", [])
    pg_info  = result.get("pagination", {})
    has_more = page < pg_info.get("last_page", 1)
    return {
        "results":  [_manga_to_card(m) for m in items],
        "hasMore":  has_more,
        "nextPage": page + 1,
    }


# ── Search ──────────────────────────────────────────────────────────────────

def search(query, offset=0):
    key = f"search:{query}:{offset}"
    return _cached(key, TTL_SEARCH, lambda: _search(query, offset))


def _search(query, offset):
    page   = (offset // PAGE_LIMIT) + 1
    result = _api("manga", {
        "keyword":              query,
        "order[follows_total]": "desc",
        "limit":                PAGE_LIMIT,
        "page":                 page,
    })
    items    = result.get("items", [])
    pg       = result.get("pagination", {})
    has_more = page < pg.get("last_page", 1)
    return {
        "results":    [_manga_to_card(m) for m in items],
        "hasMore":    has_more,
        "nextOffset": offset + len(items),
    }


# ── Info + Chapters ─────────────────────────────────────────────────────────

def info(full_id):
    return _cached(f"info:{full_id}", TTL_INFO, lambda: _info(full_id))


def _info(full_id):
    hid  = full_id.split("/")[0]
    data = _api(f"manga/{hid}")

    cover = _cover(data)
    # Fetch all chapters (paginated)
    chapters = []
    page = 1
    while True:
        ch_result = _api(f"manga/{hid}/chapters", {
            "order[number]": "desc",
            "limit":         100,
            "page":          page,
            "language":      "en",
        })
        items = ch_result.get("items", []) if ch_result else []
        slug  = data.get("slug", hid)
        for item in items:
            chap_id  = str(item["chapter_id"])
            num      = str(item.get("number", ""))
            name     = item.get("name") or f"Chapter {num}"
            chapters.append({
                "id":        chap_id,
                "title":     name,
                "chapter":   num,
                "publishAt": str(item.get("created_at", "")),
                # store slug so pages() can build chapter URL
                "_slug":     f"{hid}-{slug}",
            })
        pg = ch_result.get("pagination", {}) if ch_result else {}
        if page >= pg.get("last_page", 1):
            break
        page += 1

    # authors / genres from terms need another call – skip for now, use synopsis
    return {
        "id":          full_id,
        "title":       data.get("title", ""),
        "description": data.get("synopsis", ""),
        "status":      data.get("status", ""),
        "image":       proxy_url(cover),
        "authors":     [],
        "chapters":    chapters,
        "_rawCover":   cover,
        "_hid":        hid,
        "_slug":       data.get("slug", hid),
    }


# ── Pages ────────────────────────────────────────────────────────────────────

def pages(chapter_id, manga_id=""):
    key = f"pages:{chapter_id}"
    return _cached(key, TTL_PAGES, lambda: _pages(chapter_id, manga_id))


def _pages(chapter_id, manga_id=""):
    # Build chapter URL — need the manga slug
    # manga_id format: hid/slug
    if manga_id and "/" in manga_id:
        hid, slug = manga_id.split("/", 1)
        manga_slug = f"{hid}-{slug}"
    else:
        # Fall through: try to find slug via info cache
        manga_slug = manga_id or "unknown"

    # Fetch chapter number to build URL (chapter_id is numeric)
    # Optimistically try to find it in any cached info
    ch_num = _find_chapter_num(chapter_id)

    url = f"{BASE}/title/{manga_slug}/{chapter_id}-chapter-{ch_num}"
    r   = session.get(url, headers=HEADERS, timeout=20)
    r.raise_for_status()
    html = r.text

    imgs = _extract_images(html)
    return [{"page": i + 1, "img": proxy_url(img)} for i, img in enumerate(imgs)]


def _find_chapter_num(chapter_id):
    """Search in-memory cache for a chapter's number."""
    with _cache_lock:
        for key, (val, _) in _cache.items():
            if not key.startswith("info:"):
                continue
            for ch in val.get("chapters", []):
                if ch.get("id") == str(chapter_id):
                    return ch.get("chapter", "0")
    return "0"


def _extract_images(html):
    """Extract chapter image URLs from a comix.to chapter page (Next.js SSR)."""
    # Images live in escaped JSON: \"images\":[{\"url\":\"https://...\"}]
    idx = html.find('\\"images\\":')
    if idx != -1:
        chunk = html[idx:idx + 200000]
        urls = re.findall(r'\\"url\\":\\"(https?://[^\\]+)\\"', chunk)
        if urls:
            return urls

    # Fallback: unescaped JSON (in case SSR format changes)
    m = re.search(r'"images":\s*\[([^\]]+)\]', html)
    if m:
        urls = re.findall(r'"url"\s*:\s*"(https?://[^"]+)"', m.group(1))
        if urls:
            return urls

    # Last resort: generic image URLs
    urls = re.findall(r'https://[^\s"\\]+\.(?:jpg|jpeg|png|webp)(?:\?[^\s"\\]*)?', html)
    return [u for u in urls if "static.comix" not in u and "logo" not in u.lower()]


# ── Favorites ────────────────────────────────────────────────────────────────

_fav_lock = threading.Lock()


def _load_favs():
    with _fav_lock:
        if not os.path.exists(FAVORITES_FILE):
            return []
        with open(FAVORITES_FILE) as f:
            return json.load(f)


def _save_favs(favs):
    with _fav_lock:
        with open(FAVORITES_FILE, "w") as f:
            json.dump(favs, f, indent=2)


def fav_list():
    favs = _load_favs()
    return [{**f, "image": proxy_url(f["image"])} for f in favs]


def fav_add(manga_id, title, raw_image_url):
    favs = _load_favs()
    if any(f["id"] == manga_id for f in favs):
        return {"ok": True}
    favs.append({
        "id":                    manga_id,
        "title":                 title,
        "image":                 raw_image_url,
        "addedAt":               datetime.now(timezone.utc).isoformat(),
        "lastKnownChapterCount": 0,
        "latestSeenChapterId":   "",
        "hasNewChapters":        False,
    })
    _save_favs(favs)
    return {"ok": True}


def fav_remove(manga_id):
    favs = _load_favs()
    _save_favs([f for f in favs if f["id"] != manga_id])
    return {"ok": True}


def fav_mark_seen(manga_id, chapter_id):
    favs = _load_favs()
    for f in favs:
        if f["id"] == manga_id:
            f["latestSeenChapterId"] = chapter_id
            f["hasNewChapters"]      = False
    _save_favs(favs)
    return {"ok": True}


def fav_check():
    favs    = _load_favs()
    updated = []

    def _check_one(fav):
        key = f"info:{fav['id']}"
        with _cache_lock:
            _cache.pop(key, None)
        try:
            data  = info(fav["id"])
            count = len(data.get("chapters", []))
            if count > fav.get("lastKnownChapterCount", 0):
                fav["hasNewChapters"]        = True
                fav["lastKnownChapterCount"] = count
                updated.append({"id": fav["id"], "title": fav["title"], "newCount": count})
            elif not fav.get("hasNewChapters"):
                fav["lastKnownChapterCount"] = count
        except Exception:
            pass

    with ThreadPoolExecutor(max_workers=4) as ex:
        list(ex.map(_check_one, favs))
    _save_favs(favs)
    return {"checked": len(favs), "updated": updated}


# ── Downloads ────────────────────────────────────────────────────────────────

_dl_jobs = {}
_dl_lock = threading.Lock()


def dl_list():
    result = []
    if not os.path.exists(DOWNLOADS_DIR):
        return result
    for sid in sorted(os.listdir(DOWNLOADS_DIR)):
        series_dir  = os.path.join(DOWNLOADS_DIR, sid)
        series_meta = os.path.join(series_dir, "series_meta.json")
        if not os.path.isdir(series_dir) or not os.path.exists(series_meta):
            continue
        with open(series_meta) as f:
            sm = json.load(f)
        chapters = []
        for cid in sorted(os.listdir(series_dir)):
            ch_dir  = os.path.join(series_dir, cid)
            ch_meta = os.path.join(ch_dir, "meta.json")
            if not os.path.isdir(ch_dir) or not os.path.exists(ch_meta):
                continue
            with open(ch_meta) as f:
                chapters.append(json.load(f))

        def _sort_key(c):
            val = c.get("chapterNum", "0") or "0"
            m   = re.search(r"[\d.]+", val)
            return float(m.group()) if m else 0.0

        chapters.sort(key=_sort_key, reverse=True)
        cover_path = os.path.join(series_dir, "cover.jpg")
        cover_local = f"file://{cover_path}" if os.path.exists(cover_path) else proxy_url(sm.get("rawCoverUrl", ""))
        result.append({**sm, "image": cover_local, "chapters": chapters})
    return result


def dl_progress(chapter_id):
    with _dl_lock:
        return _dl_jobs.get(chapter_id, {"status": "not_started"})


def dl_start(manga_id, chapter_id, chapter_num, chapter_title, manga_title, raw_cover_url):
    with _dl_lock:
        job = _dl_jobs.get(chapter_id, {})
        if job.get("status") in ("downloading", "done"):
            return {"ok": False, "message": job["status"]}
        _dl_jobs[chapter_id] = {"status": "pending", "total": 0, "done": 0, "error": None}
    threading.Thread(
        target=_dl_worker,
        args=(manga_id, chapter_id, chapter_num, chapter_title, manga_title, raw_cover_url),
        daemon=True,
    ).start()
    return {"ok": True}


def _dl_worker(manga_id, chapter_id, chapter_num, chapter_title, manga_title, raw_cover_url):
    sid    = manga_id.split("/")[0]
    ch_dir = os.path.join(DOWNLOADS_DIR, sid, chapter_id)
    os.makedirs(ch_dir, exist_ok=True)
    try:
        page_list = _pages(chapter_id, manga_id)
        total     = len(page_list)
        with _dl_lock:
            _dl_jobs[chapter_id].update({"status": "downloading", "total": total})

        for pg in page_list:
            qs       = parse_qs(urlparse(pg["img"]).query)
            real_url = unquote(qs.get("url", [""])[0])
            if not real_url:
                continue
            ext   = real_url.split("?")[0].rsplit(".", 1)[-1].lower()
            ext   = ext if ext in ("jpg", "jpeg", "png", "webp") else "jpg"
            fname = os.path.join(ch_dir, f"{pg['page']:03d}.{ext}")
            if not os.path.exists(fname):
                cached = _img_get(real_url)
                if cached:
                    body = cached[0]
                else:
                    r    = session.get(real_url, headers=HEADERS, timeout=30)
                    r.raise_for_status()
                    body = r.content
                    _img_put(real_url, body, r.headers.get("Content-Type", "image/jpeg"))
                with open(fname, "wb") as f:
                    f.write(body)
            with _dl_lock:
                _dl_jobs[chapter_id]["done"] += 1

        with open(os.path.join(ch_dir, "meta.json"), "w") as f:
            json.dump({
                "chapterId":    chapter_id,
                "chapterNum":   chapter_num,
                "title":        chapter_title,
                "mangaId":      manga_id,
                "mangaTitle":   manga_title,
                "pages":        total,
                "downloadedAt": datetime.now(timezone.utc).isoformat(),
            }, f)

        series_dir  = os.path.join(DOWNLOADS_DIR, sid)
        series_meta = os.path.join(series_dir, "series_meta.json")
        with open(series_meta, "w") as f:
            json.dump({"id": manga_id, "title": manga_title,
                       "localId": sid, "rawCoverUrl": raw_cover_url}, f)

        cover_path = os.path.join(series_dir, "cover.jpg")
        if not os.path.exists(cover_path) and raw_cover_url:
            try:
                r = session.get(raw_cover_url, headers=HEADERS, timeout=15)
                if r.ok:
                    with open(cover_path, "wb") as f:
                        f.write(r.content)
            except Exception:
                pass

        with _dl_lock:
            _dl_jobs[chapter_id]["status"] = "done"

    except Exception as e:
        import traceback; traceback.print_exc()
        with _dl_lock:
            _dl_jobs[chapter_id] = {"status": "error", "total": 0, "done": 0, "error": str(e)}


def dl_pages(chapter_id):
    for sid in os.listdir(DOWNLOADS_DIR):
        ch_dir = os.path.join(DOWNLOADS_DIR, sid, chapter_id)
        if os.path.isdir(ch_dir):
            files = sorted(f for f in os.listdir(ch_dir)
                           if f[0].isdigit() and f.rsplit(".", 1)[-1].lower()
                           in ("jpg", "jpeg", "png", "webp"))
            return [{"page": i + 1, "img": f"file://{os.path.join(ch_dir, fn)}"}
                    for i, fn in enumerate(files)]
    return []


def dl_remove(chapter_id):
    for sid in os.listdir(DOWNLOADS_DIR):
        ch_dir = os.path.join(DOWNLOADS_DIR, sid, chapter_id)
        if os.path.isdir(ch_dir):
            shutil.rmtree(ch_dir)
            series_dir = os.path.join(DOWNLOADS_DIR, sid)
            remaining  = [d for d in os.listdir(series_dir) if os.path.isdir(os.path.join(series_dir, d))]
            if not remaining:
                shutil.rmtree(series_dir)
            with _dl_lock:
                _dl_jobs.pop(chapter_id, None)
            return {"ok": True}
    return {"ok": False, "error": "not found"}


# ── Image byte cache ─────────────────────────────────────────────────────────

_img_cache      = {}
_img_cache_lock = threading.Lock()
_img_cache_max  = 600
_img_sem        = threading.Semaphore(10)


def _img_get(url):
    with _img_cache_lock:
        return _img_cache.get(url)


def _img_put(url, body, ctype):
    with _img_cache_lock:
        if len(_img_cache) >= _img_cache_max:
            _img_cache.pop(next(iter(_img_cache)))
        _img_cache[url] = (body, ctype)


def _send_image(handler, body, ctype):
    handler.send_response(200)
    handler.send_header("Content-Type", ctype)
    handler.send_header("Content-Length", str(len(body)))
    handler.send_header("Cache-Control", "public, max-age=86400")
    handler.send_header("Access-Control-Allow-Origin", "*")
    handler.end_headers()
    try:
        handler.wfile.write(body)
    except (BrokenPipeError, ConnectionResetError):
        pass


def proxy_image(handler, img_url):
    cached = _img_get(img_url)
    if cached:
        _send_image(handler, *cached)
        return
    with _img_sem:
        cached = _img_get(img_url)
        if cached:
            _send_image(handler, *cached)
            return
        r = session.get(img_url, headers=HEADERS, timeout=20)
        r.raise_for_status()
        body  = r.content
        ctype = r.headers.get("Content-Type", "image/jpeg")
        _img_put(img_url, body, ctype)
        _send_image(handler, body, ctype)


# ── HTTP Server ──────────────────────────────────────────────────────────────

class ThreadingHTTPServer(ThreadingMixIn, HTTPServer):
    daemon_threads = True


class Handler(BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        pass  # suppress per-request access log

    def _json(self, data, status=200):
        body = json.dumps(data).encode()
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()
        try:
            self.wfile.write(body)
        except (BrokenPipeError, ConnectionResetError):
            pass

    def _error(self, msg, status=500):
        self._json({"error": msg}, status)

    def do_HEAD(self):
        self.send_response(200)
        self.end_headers()

    def do_GET(self):
        parsed = urlparse(self.path)
        qs     = parse_qs(parsed.query)

        def param(key, default=""):
            return (qs.get(key) or [default])[0]

        try:
            p = parsed.path

            if p == "/hot":
                self._json(hot_updates())

            elif p == "/latest":
                self._json(latest_updates(int(param("page", "1"))))

            elif p == "/search":
                q = param("q")
                if not q:
                    return self._error("missing q", 400)
                self._json(search(q, int(param("offset", "0"))))

            elif p == "/info":
                mid = param("id")
                if not mid:
                    return self._error("missing id", 400)
                self._json(info(mid))

            elif p == "/pages":
                cid = param("chapterId")
                mid = param("mangaId")
                if not cid:
                    return self._error("missing chapterId", 400)
                self._json(pages(cid, mid))

            elif p == "/image":
                img_url = unquote(param("url"))
                if not img_url:
                    return self._error("missing url", 400)
                proxy_image(self, img_url)

            elif p == "/favorites":
                self._json(fav_list())

            elif p == "/favorites/check":
                self._json(fav_check())

            elif p == "/dl/list":
                self._json(dl_list())

            elif p == "/dl/progress":
                cid = param("chapterId")
                if not cid:
                    return self._error("missing chapterId", 400)
                self._json(dl_progress(cid))

            elif p == "/dl/pages":
                cid = param("chapterId")
                if not cid:
                    return self._error("missing chapterId", 400)
                self._json(dl_pages(cid))

            elif p == "/health":
                self._json({"ok": True})

            else:
                self._error("not found", 404)

        except (BrokenPipeError, ConnectionResetError):
            pass
        except requests.HTTPError as e:
            self._error(f"upstream {e.response.status_code}: {e.response.url}")
        except Exception as e:
            import traceback; traceback.print_exc()
            self._error(str(e))

    def do_POST(self):
        parsed = urlparse(self.path)
        try:
            length = int(self.headers.get("Content-Length", 0))
            body   = json.loads(self.rfile.read(length)) if length else {}
        except Exception:
            return self._error("bad request body", 400)

        try:
            p = parsed.path

            if p == "/favorites/add":
                manga_id = body.get("id", "")
                if not manga_id:
                    return self._error("missing id", 400)
                self._json(fav_add(manga_id, body.get("title", ""), body.get("imageUrl", "")))

            elif p == "/favorites/remove":
                manga_id = body.get("id", "")
                if not manga_id:
                    return self._error("missing id", 400)
                self._json(fav_remove(manga_id))

            elif p == "/favorites/mark-seen":
                manga_id = body.get("id", "")
                if not manga_id:
                    return self._error("missing id", 400)
                self._json(fav_mark_seen(manga_id, body.get("chapterId", "")))

            elif p == "/dl/start":
                manga_id   = body.get("mangaId", "")
                chapter_id = body.get("chapterId", "")
                if not (manga_id and chapter_id):
                    return self._error("missing mangaId or chapterId", 400)
                self._json(dl_start(
                    manga_id, chapter_id,
                    body.get("chapterNum", ""),
                    body.get("chapterTitle", ""),
                    body.get("mangaTitle", ""),
                    body.get("rawCoverUrl", ""),
                ))

            elif p == "/dl/delete":
                chapter_id = body.get("chapterId", "")
                if not chapter_id:
                    return self._error("missing chapterId", 400)
                self._json(dl_remove(chapter_id))

            else:
                self._error("not found", 404)

        except (BrokenPipeError, ConnectionResetError):
            pass
        except Exception as e:
            import traceback; traceback.print_exc()
            self._error(str(e))


def run():
    server = ThreadingHTTPServer(("127.0.0.1", PORT), Handler)
    print(f"[comix-server] Listening on http://127.0.0.1:{PORT} (threaded)")
    server.serve_forever()


if __name__ == "__main__":
    run()
