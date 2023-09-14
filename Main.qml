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
            id:cbuffer
            anchors.fill: parent
            anchors.centerIn: parent
            capacity: 18
        }
        focus:true
        Keys.onPressed: (event) => {
            if(Qt.Key_0<= event.key && event.key <= Qt.Key_9)
                cbuffer.write(event.key - Qt.Key_0)
            else
                cbuffer.read()
        }
    }


}
