import QtQuick
import QtQuick.Window
import QtQuick.Shapes
import Backends

Item {
    id: bufferCircle
    property real circleThickness: Math.min(width,height)/10.0
    property real radius: Math.min(width,height)/2-padding
    readonly property real padding: Math.min(width,height)/10.0
    property color borderColor: "darkGreen"
    property color fillColor: "lightGreen"
    property alias capacity:backend.capacity
    property alias readIndex:backend.readIndex
    property alias writeIndex:backend.writeIndex
    function read(){return backend.read()}
    function write(val){ backend.write(val)}

    CircularBufferBackend{
        id: backend
    }

    Image{
        id:readHead
        anchors.top:parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width:30
        height:30
        rotation: 90
        source: "qrc:/CircularBuffer/arrow.svg"
        transform:[
            Translate{y:bufferCircle.height/2.0-bufferCircle.radius-writeHead.height},
            Rotation{
                angle: (360/backend.rowCount())*(backend.readIndex)
                axis { x: 0; y: 0; z: 1 }
                origin.x: writeHead.width/2; origin.y: bufferCircle.height/2.0;

                Behavior on angle{
                    RotationAnimation{
                        duration:1000
                        easing.type: Easing.OutExpo
                    }
                }
            }
        ]
    }

    Image{
        id:writeHead
        anchors.top:parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width:30
        height:30
        rotation: 90
        source: "qrc:/CircularBuffer/arrow.svg"
        transform:[
            Translate{y:bufferCircle.height/2.0-bufferCircle.radius-writeHead.height},
            Rotation{
                angle: (360/backend.rowCount())*(backend.writeIndex)
                axis { x: 0; y: 0; z: 1 }
                origin.x: writeHead.width/2; origin.y: bufferCircle.height/2.0;

                Behavior on angle{
                    RotationAnimation{
                        duration:1000
                        easing.type: Easing.InOutCirc}
                }
            }
        ]
    }

    Repeater{
        visible:backend.rowCount()>1
        anchors.fill: parent
        anchors.centerIn:parent
        model:backend
        delegate:CirclePart{
            anchors.centerIn: parent
            radius:bufferCircle.radius
            strokeColor: bufferCircle.borderColor
            fillColor: bufferCircle.fillColor
            thickness: bufferCircle.circleThickness
            angle:(2*Math.PI)/backend.rowCount()
            rotation: (360.0/backend.rowCount())*(index)
            text:model.data
        }
    }

    Shape{
        visible:backend.rowCount()==1
        anchors.centerIn:parent
        ShapePath{
            startX: 0
            startY: 0
            strokeWidth: 1
            strokeColor: bufferCircle.borderColor
            fillColor: bufferCircle.fillColor

            PathAngleArc{
                centerX: 0
                centerY: 0
                radiusX: bufferCircle.radius
                radiusY: bufferCircle.radius
                startAngle: 0
                sweepAngle:360
            }

            PathAngleArc{
                centerX: 0
                centerY: 0
                radiusX: bufferCircle.radius-circleThickness
                radiusY: bufferCircle.radius-circleThickness
                startAngle: 0
                sweepAngle:360
            }

        }
    }

    Column{
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
        Text{ text:"Capacity: "+ backend.rowCount()}
        Text{ text:"Length: "+ backend.length}
        Text{ text:"Read index: "+ backend.readIndex}
        Text{ text:"Write index: "+ backend.writeIndex}
    }
}
