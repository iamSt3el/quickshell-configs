import QtQuick
import Quickshell
import qs.modules.utils

Item {
    id: root

    // M3 token: WaveSize = 48dp, ActiveThickness = 4dp, TrackThickness = 4dp
    property real size: 48
    property real trackWidth: 4
    property color highlightColor: Colors.primary
    property color trackColor: Colors.secondaryContainer

    // -1 = indeterminate, 0.0–1.0 = determinate
    property real value: -1

    // M3 tokens: ActiveWaveAmplitude = 1.6dp, ActiveWaveWavelength = 15dp
    // waveSpeed = wavelength (1 wavelength/sec → phase period = 1000ms)
    property real waveAmplitude: 1.6
    property real wavelength: 15
    property real trackGap: 4       // TrackActiveSpace = 4dp

    // ── Animation state ───────────────────────────────────────────────────────
    property real phase: 0.0              // wave offset (0→2π)
    property real globalRotation: 0.0     // slow continuous spin
    property real additionalRotation: 0.0 // keyframed 90° jumps
    property real arcProgress: 0.1        // arc sweep fraction (0→1)

    // M3: amplitude is 0 when progress ≤ 10% or ≥ 95%, 1 otherwise
    // Smoothly animated with DurationLong2 = 700ms
    property real currentAmplitude: 0.0
    property real _targetAmplitude: {
        var p = root.value < 0 ? root.arcProgress : Math.max(0, Math.min(1, root.value))
        return (p > 0.1 && p < 0.95) ? 1.0 : 0.0
    }
    on_TargetAmplitudeChanged: currentAmplitude = _targetAmplitude

    Behavior on currentAmplitude {
        NumberAnimation { duration: 700; easing.type: Easing.InOutCubic }
    }

    // ── M3 indeterminate animations ───────────────────────────────────────────

    // Global rotation: 0→1080° over 6000ms, linear, infinite
    NumberAnimation on globalRotation {
        from: 0; to: 1080
        duration: 6000
        loops: Animation.Infinite
        running: root.value < 0
    }

    // Additional rotation: keyframe 90° jumps every 1500ms with 300ms decel ease
    // M3 pattern: 0→90 in 300ms, hold to 1500ms, 90→180 at 1800ms, hold to 3000ms, ...
    // Simplified to a continuous 0→360 over 6000ms (matches net rotation)
    SequentialAnimation on additionalRotation {
        running: root.value < 0
        loops: Animation.Infinite
        // Jump 90° in 300ms, hold 1200ms — repeated 4x = 6000ms total
        NumberAnimation { from: 0;   to: 90;  duration: 300; easing.type: Easing.OutCubic }
        PauseAnimation  { duration: 1200 }
        NumberAnimation { from: 90;  to: 180; duration: 300; easing.type: Easing.OutCubic }
        PauseAnimation  { duration: 1200 }
        NumberAnimation { from: 180; to: 270; duration: 300; easing.type: Easing.OutCubic }
        PauseAnimation  { duration: 1200 }
        NumberAnimation { from: 270; to: 360; duration: 300; easing.type: Easing.OutCubic }
        PauseAnimation  { duration: 1200 }
    }

    // Arc progress: 0.1 → 0.87 → 0.1 over 6000ms (M3 standard easing)
    SequentialAnimation on arcProgress {
        running: root.value < 0
        loops: Animation.Infinite
        NumberAnimation { from: 0.1; to: 0.87; duration: 3000; easing.type: Easing.InOutCubic }
        NumberAnimation { from: 0.87; to: 0.1; duration: 3000; easing.type: Easing.InOutCubic }
    }

    // Wave phase: 0→2π in 1000ms (waveSpeed = wavelength = 1 wavelength/sec)
    NumberAnimation on phase {
        from: 0; to: Math.PI * 2
        duration: 1000
        loops: Animation.Infinite
        running: true
    }

    Behavior on value {
        NumberAnimation { duration: 300; easing.type: Easing.OutCubic }
    }

    width: size
    height: size

    Canvas {
        id: canvas
        anchors.fill: parent

        // Indeterminate: both rotations applied via QML rotation
        // Determinate: -90° so arc starts at 12 o'clock
        rotation: root.value < 0
            ? (root.globalRotation + root.additionalRotation)
            : -90

        Connections {
            target: root
            function onPhaseChanged()              { canvas.requestPaint(); }
            function onValueChanged()              { canvas.requestPaint(); }
            function onArcProgressChanged()        { canvas.requestPaint(); }
            function onGlobalRotationChanged()     { canvas.requestPaint(); }
            function onAdditionalRotationChanged() { canvas.requestPaint(); }
            function onCurrentAmplitudeChanged()   { canvas.requestPaint(); }
            function onHighlightColorChanged()     { canvas.requestPaint(); }
            function onTrackColorChanged()         { canvas.requestPaint(); }
        }

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            var cx = width / 2;
            var cy = height / 2;
            var r  = cx - root.trackWidth / 2 - root.waveAmplitude - 1;

            var TWO_PI  = 2 * Math.PI;
            var numWaves = Math.max(3, Math.round(TWO_PI * r / root.wavelength));

            // Arc sweep in radians
            var arcSweep;
            if (root.value < 0) {
                arcSweep = root.arcProgress * TWO_PI;
            } else {
                arcSweep = Math.max(0.01, Math.min(1, root.value)) * TWO_PI;
            }

            // Gap in radians (M3 TrackActiveSpace = 4dp)
            var gapRad = root.trackGap / r;

            // ── 1. Track — plain circle with gap where the active arc is ──────
            ctx.strokeStyle = root.trackColor;
            ctx.lineWidth   = root.trackWidth;
            ctx.lineCap     = "round";

            if (arcSweep < TWO_PI - gapRad * 2) {
                // Draw track only in the empty portion (with gap on both sides)
                ctx.beginPath();
                ctx.arc(cx, cy, r, arcSweep + gapRad, TWO_PI - gapRad);
                ctx.stroke();
            } else if (root.value <= 0.01 && root.value >= 0) {
                // No progress — full track circle
                ctx.beginPath();
                ctx.arc(cx, cy, r, 0, TWO_PI);
                ctx.stroke();
            }

            if (arcSweep < 0.01) return;

            // ── 2. Active indicator ────────────────────────────────────────
            // M3: amplitude fades to 0 at ≤10% and ≥95% progress → plain arc
            // In between: wavy with r(θ) = R + A·sin(N·θ − phase)
            var amp = root.waveAmplitude * root.currentAmplitude;

            ctx.beginPath();
            ctx.strokeStyle = root.highlightColor;
            ctx.lineWidth   = root.trackWidth;
            ctx.lineCap     = "round";

            if (amp < 0.01) {
                // Plain arc — no wave
                ctx.arc(cx, cy, r, 0, arcSweep);
            } else {
                // Wavy arc
                var steps = Math.max(100, numWaves * 24);
                for (var i = 0; i <= steps; i++) {
                    var t     = i / steps;
                    var angle = t * arcSweep;
                    var wave  = amp * Math.sin(numWaves * angle - root.phase);
                    var px    = cx + (r + wave) * Math.cos(angle);
                    var py    = cy + (r + wave) * Math.sin(angle);
                    if (i === 0) ctx.moveTo(px, py); else ctx.lineTo(px, py);
                }
            }
            ctx.stroke();
        }
    }
}
