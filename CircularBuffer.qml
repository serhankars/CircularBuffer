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
                angle: (360/capacity)*(backend.readIndex)
                axis { x: 0; y: 0; z: 1 }
                origin.x: writeHead.width/2; origin.y: bufferCircle.height/2.0;
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
                angle: (360/capacity)*(backend.writeIndex)
                axis { x: 0; y: 0; z: 1 }
                origin.x: writeHead.width/2; origin.y: bufferCircle.height/2.0;
            }
        ]
    }

    Repeater{
        visible:capacity>1
        anchors.fill: parent
        anchors.centerIn:parent
        model:capacity
        delegate:CirclePart{
            radius:bufferCircle.radius
            strokeColor: bufferCircle.borderColor
            fillColor: bufferCircle.fillColor
            anchors.centerIn: parent
            thickness: bufferCircle.circleThickness
            angle:(2*Math.PI)/capacity
            rotation: (360.0/capacity)*(index-1)
        }
    }

    Shape{
        visible:capacity==1
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
    focus: true
    Keys.onRightPressed: {
        backend.write(1);
    }
    Keys.onLeftPressed: {
        backend.read();
    }

    Column{
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        Text{ text:"Capacity: "+ backend.capacity}
        Text{ text:"Length: "+ backend.length}
        Text{ text:"Read index: "+ backend.readIndex}
        Text{ text:"Write index: "+ backend.writeIndex}
    }
}
