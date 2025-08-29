import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Shapes
import Quickshell.Services.Mpris


    // x: workspacesItem.children[0].implicitWidth + 40
    //anchors.right: parent.right
    Rectangle{
        id: wrapper
        implicitWidth: 152
        implicitHeight: 40

        anchors{
            leftMargin: 100
        }

        color: "transparent"
        
        /*Shape{
            preferredRendererType: Shape.CurveRenderer
            ShapePath{
                fillColor: "#11111B"
                //strokeColor: "blue"
                strokeWidth: 0

                startX: wrapper.x 
                startY: 0

                PathArc{
                    relativeX: 20
                    relativeY: 10
                    radiusX: 20
                    radiusY: 15
                    //direction: PathArc.Counterclockwise
                }

                PathLine{
                    relativeX: wrapper.x + wrapper.width - 40
                    relativeY: 0
                }

                PathArc{
                    relativeX: 20
                    relativeY: -10
                    radiusX: 20
                    radiusY: 15
                    //direction: PathArc.Counterclockwise
                }

            }
        }*/

         Rectangle{
                id: musicPlayer
                property var values: []
                property int refCount: 1
                property int barCount: 18
                property real maxHeight: 30
                property real barWidth: 6
                property real barSpacing: 2
                clip: true
                    
                    property var barColors: [
                        "#4ECDC4", "#45B7AF", "#96CEB4", "#FFEAA7",
                        "#DDA0DD", "#FFB6C1", "#98FB98", "#F0E68C",
                        "#87CEEB", "#DDA0DD", "#98FB98", "#4ECDC4",
                        "#99D1DB", "#A6D189", "#E5C890"
                    ]
                    
                    implicitHeight: 36
                    implicitWidth: parent.width
                    color: "#45475A"
                    //color: "transparent"
                    //bottomRightRadius: 20
                    //bottomLeftRadius: 20
                    radius: 10
                    anchors.centerIn: parent
                     
                    Process {
                        id: cavaProc
                        running: MprisPlaybackState.Playing
                        command: ["sh", "-c", `printf '[general]\nframerate=60\nbars=18\nsleep_timer=3\n[input]\nsample_rate=44100\n[output]\nchannels=mono\nmethod=raw\nraw_target=/dev/stdout\ndata_format=ascii\nascii_max_range=100\n[smoothing]\nintegral=50\nmonstercat=1\nwaves=0\n[eq]\n1=1\n2=1\n3=1.2\n4=1.5\n5=2' | cava -p /dev/stdin`]
                        stdout: SplitParser {
                            onRead: data => {
                                if (musicPlayer.refCount)
                                    musicPlayer.values = data.slice(0, -1).split(";").map(v => parseInt(v, 10));
                            }
                        }
                    }

                    Canvas {
                        id: waveCanvas
                        anchors.centerIn: parent
                        width: parent.width
                        height: parent.height
                        
                        onValuesChanged: requestPaint()
                        
                        property var values: musicPlayer.values
                        
                        onPaint: {
                            var ctx = getContext("2d")
                            ctx.clearRect(0, 0, width, height)
                            
                            if (!values || values.length === 0) return
                            
                            var barWidth = musicPlayer.barWidth
                            var barSpacing = musicPlayer.barSpacing
                            var totalBarWidth = barWidth + barSpacing
                            var startX = (width - (values.length * totalBarWidth - barSpacing)) / 2
                            
                            // Draw bars
                            for (var i = 0; i < values.length; i++) {
                                var value = Math.max(2, (values[i] / 100) * musicPlayer.maxHeight)
                                var x = startX + i * totalBarWidth
                                var barHeight = value
                                var y = height - barHeight 
                                
                                // Use color from array, cycling through colors
                                ctx.fillStyle = musicPlayer.barColors[i % musicPlayer.barColors.length]
                                
                                // Draw rounded rectangle for each bar (rounded top)
                                var radius = Math.min(barWidth / 2, 4)
                                ctx.beginPath()
                                ctx.moveTo(x, y + radius)
                                ctx.arcTo(x, y, x + radius, y, radius)
                                ctx.lineTo(x + barWidth - radius, y)
                                ctx.arcTo(x + barWidth, y, x + barWidth, y + radius, radius)
                                ctx.lineTo(x + barWidth, height)
                                ctx.lineTo(x, height)
                                ctx.closePath()
                                ctx.fill()
                            }
                        }
                        
                        Connections {
                            target: musicPlayer
                            function onValuesChanged() {
                                waveCanvas.requestPaint()
                            }
                        }
                    }
                    
                }



        
    }



