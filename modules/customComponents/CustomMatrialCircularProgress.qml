import Quickshell
import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts
import qs.modules.utils
import qs.modules.customComponents


Item{
    id: root
    property real progress: 0.0
    property real thickness: 2
    property real radius: Math.min(width, height) / 2 - thickness
    property string baseColor: Colors.primaryText
    property string lineColor: Colors.primary
    property real gap: 0.4
    property string icon: ""
    property real iconSize: 20
    property string iconColor: Colors.primary

    property bool sperm: false
    property bool animateSperm: true
    property real spermAmplitudeMultiplier: sperm ? 0.4 : 0
    property real spermFrequency: 10
    property real spermFps: 60

    Behavior on spermAmplitudeMultiplier {
        NumberAnimation {
            duration: 100
            easing.type: Easing.OutQuad
        }
    }

    Behavior on progress{
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutQuad
        }
    }


    Canvas{
        id: canvas
        anchors.fill: parent

        antialiasing: true

        readonly property real centerX: width / 2
        readonly property real centerY: height / 2
        readonly property real startAngle: -Math.PI / 2
        readonly property real endAngle: startAngle + (2 * Math.PI * root.progress)
        readonly property real baseEndAngle: (2 * Math.PI)

        onEndAngleChanged: requestPaint()

        onPaint:{
            const ctx = getContext("2d")
            ctx.reset();

            ctx.lineWidth = root.thickness;
            ctx.lineCap = "round"

            const r = root.radius
            const cx = centerX;
            const cy = centerY;

            ctx.beginPath();
            ctx.arc(cx, cy, r, endAngle, (Math.PI / 2 + Math.PI) - root.gap, false)
            ctx.strokeStyle = root.baseColor
            ctx.stroke();

            if(root.progress > 0){
                const amplitude = root.thickness * root.spermAmplitudeMultiplier;
                const start = startAngle;
                const arcSpan = endAngle - startAngle;
                const effectiveGap = Math.min(root.gap, arcSpan * 0.5);
                const end = endAngle - effectiveGap;

                if (amplitude > 0 && end > start) {
                    const frequency = root.spermFrequency * root.progress;
                    const phase = Date.now() / 400.0;
                    const steps = Math.max(1, Math.round(Math.abs(end - start) / 0.02));

                    ctx.beginPath();
                    for (let i = 0; i <= steps; i++) {
                        const angle = start + (end - start) * i / steps;
                        const waveR = r + amplitude * Math.sin(frequency * 2 * Math.PI * i / steps + phase);
                        const x = cx + waveR * Math.cos(angle);
                        const y = cy + waveR * Math.sin(angle);
                        if (i === 0) ctx.moveTo(x, y);
                        else ctx.lineTo(x, y);
                    }
                    ctx.strokeStyle = root.lineColor;
                    ctx.stroke();
                } else {
                    ctx.beginPath();
                    ctx.arc(cx, cy, r, start, end, false);
                    ctx.strokeStyle = root.lineColor
                    ctx.stroke();
                }
            }
        }

        Timer {
            interval: 1000 / root.spermFps
            running: root.animateSperm
            repeat: root.sperm
            onTriggered: canvas.requestPaint()
        }
    }

    MaterialIconSymbol{
        anchors.centerIn: parent
        content: root.icon
        iconSize: root.iconSize
        color: root.iconColor
    }
}
