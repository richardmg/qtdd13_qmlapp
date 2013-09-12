import QtQuick 2.1
import QtQuick.Window 2.0

Rectangle {
    id: mainWindow
    color: "white"

    Image {
        id: img
        source: "qrc:/qt.png"
        x: Math.random() * (mainWindow.width - width)
        y: Math.random() * (mainWindow.height - height)
        rotation: mainWindow.Screen.orientation === Qt.PortraitOrientation ? 0 : -90
        Behavior on rotation { NumberAnimation { duration: 1000; easing.type: Easing.OutBounce } }
    }
}
