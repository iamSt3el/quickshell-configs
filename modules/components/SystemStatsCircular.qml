import QtQuick
import QtQuick.Effects
import qs.modules.util

Item {
    id: root

    property real value1: 0.0
    property real value2: 0.0
    property string label1: ""
    property string label2: ""
    property string sublabel1: ""
    property string sublabel2: ""

    property bool primary: false
    readonly property real primaryMult: primary ? 1.2 : 1
    readonly property real thickness: 6 * primaryMult

    property color fg1: Colors.primary
    property color fg2: Colors.secondary
    property color bg1: Colors.primaryContainer
    property color bg2: Colors.secondaryContainer

    implicitWidth: 90
    implicitHeight: 90

    layer.enabled: true
    layer.effect: MultiEffect{
        shadowEnabled: true
        shadowBlur: 0.4
        shadowOpacity: 0.3
        shadowColor: Qt.alpha(Colors.shadow, 0.3)
        shadowHorizontalOffset: 0
        shadowVerticalOffset: 2
    }

    onValue1Changed: canvas.requestPaint()
    onValue2Changed: canvas.requestPaint()
    onFg1Changed: canvas.requestPaint()
    onFg2Changed: canvas.requestPaint()
    onBg1Changed: canvas.requestPaint()
    onBg2Changed: canvas.requestPaint()

    Column {
        anchors.centerIn: parent

        StyledText {
            anchors.horizontalCenter: parent.horizontalCenter
            content: root.label1
            size: Math.max(14, Math.min(24, root.width * 0.10))
            effect: false
        }

        StyledText {
            anchors.horizontalCenter: parent.horizontalCenter
            content: root.sublabel1
            size: Math.max(10, Math.min(16, root.width * 0.6))
            effect: false
        }
    }

    Column {
        anchors.horizontalCenter: parent.right
        anchors.top: parent.verticalCenter
        anchors.horizontalCenterOffset: -root.thickness / 2
        anchors.topMargin: root.thickness / 2 + 2

        StyledText {
            anchors.horizontalCenter: parent.horizontalCenter
            content: root.label2
            size: 10
            effect: false
        }

        StyledText {
            anchors.horizontalCenter: parent.horizontalCenter
            content: root.sublabel2
            size: 8 
            effect: false
        }
    }

    Canvas {
        id: canvas

        readonly property real centerX: width / 2
        readonly property real centerY: height / 2

        readonly property real arc1Start: degToRad(45)
        readonly property real arc1End: degToRad(215)
        readonly property real arc2Start: degToRad(240)
        readonly property real arc2End: degToRad(360)

        function degToRad(deg) {
            return deg * Math.PI / 180
        }

        anchors.fill: parent

        onPaint: {
            const ctx = getContext("2d")
            ctx.reset()

            ctx.lineWidth = root.thickness
            ctx.lineCap = "round"

            const radius = (Math.min(width, height) - ctx.lineWidth) / 2
            const cx = centerX
            const cy = centerY
            const a1s = arc1Start
            const a1e = arc1End
            const a2s = arc2Start
            const a2e = arc2End

            // Arc 1 background
            ctx.beginPath()
            ctx.arc(cx, cy, radius, a1s, a1e, false)
            ctx.strokeStyle = root.bg1
            ctx.stroke()

            // Arc 1 progress
            ctx.beginPath()
            ctx.arc(cx, cy, radius, a1s, (a1e - a1s) * root.value1 + a1s, false)
            ctx.strokeStyle = root.fg1
            ctx.stroke()

            // Arc 2 background
            ctx.beginPath()
            ctx.arc(cx, cy, radius, a2s, a2e, false)
            ctx.strokeStyle = root.bg2
            ctx.stroke()

            // Arc 2 progress
            ctx.beginPath()
            ctx.arc(cx, cy, radius, a2s, (a2e - a2s) * root.value2 + a2s, false)
            ctx.strokeStyle = root.fg2
            ctx.stroke()
        }
    }

    Behavior on value1 {
        NumberAnimation {
            duration: 800
            easing.type: Easing.OutCubic
        }
    }

    Behavior on value2 {
        NumberAnimation {
            duration: 800
            easing.type: Easing.OutCubic
        }
    }

    Behavior on fg1 {
        ColorAnimation {
            duration: 800
            easing.type: Easing.OutCubic
        }
    }

    Behavior on fg2 {
        ColorAnimation {
            duration: 800
            easing.type: Easing.OutCubic
        }
    }

    Behavior on bg1 {
        ColorAnimation {
            duration: 800
            easing.type: Easing.OutCubic
        }
    }

    Behavior on bg2 {
        ColorAnimation {
            duration: 800
            easing.type: Easing.OutCubic
        }
    }
}
