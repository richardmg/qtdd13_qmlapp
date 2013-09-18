import QtQuick 2.1
import QtQuick.Window 2.0
import QtSensors 5.1

Rectangle {
    id: mainWindow
    color: "white"

    Image {
        id: img
        source: "qrc:/qt.png"
        rotation: Screen.orientation == Qt.PortraitOrientation ? 0 : -90
        Behavior on rotation {
            NumberAnimation {
                duration: 1000
                easing.type: Easing.OutBounce
            }
        }
    }
}
