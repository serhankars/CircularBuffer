import QtQuick
import QtQuick.Window
import QtQuick.Shapes


Window {
    width: 640
    height: 640
    visible: true
    title: qsTr("Circular buffer")
    id: window

    Rectangle{
        anchors.fill: parent
        color:"darkGrey"
        CircularBuffer{
            anchors.fill: parent
            anchors.centerIn: parent
            capacity: 20
        }
    }
}
