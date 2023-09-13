import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

Item {
    id:top
    property real radius:200
    property real thickness:50
    property real angle
    property alias strokeColor:sp.strokeColor
    property alias fillColor:sp.fillColor
    property string text:""
    readonly property real innerRadius:radius - thickness
    readonly property real sinAngle:Math.sin(top.angle/2)
    readonly property real cosAngle:Math.cos(top.angle/2)
    antialiasing: true
    Shape{
        anchors.centerIn:parent

        ShapePath{
            id:sp
            startX: -1.0*top.radius*sinAngle
            startY: -1.0*top.radius*cosAngle

            strokeWidth: 1
            strokeColor: top.strokeColor
            fillColor: top.fillColor

            PathArc{
                relativeX:2*top.radius*sinAngle
                relativeY:0;
                radiusX: top.radius;
                radiusY: top.radius
                direction: PathArc.Clockwise
                useLargeArc: false
            }

            PathLine{
                relativeX:-1.0 * thickness*sinAngle
                relativeY:1.0 * thickness *cosAngle
            }

            PathArc{
                relativeX:-2*innerRadius*sinAngle;
                relativeY:0;
                radiusX: innerRadius
                radiusY: innerRadius
                useLargeArc: false
                direction: PathArc.Counterclockwise
            }

            PathLine{
                relativeX:-1.0* thickness *sinAngle
                relativeY:-1.0* thickness *cosAngle
            }
        }
    }
}
