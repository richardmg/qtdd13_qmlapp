import QtQuick 2.1
import QtSensors 5.1

Rectangle {
    id: mainWindow
    color: "white"

    Accelerometer {
        id: sensor
        active: true
    }

    QtImage {}
    QtImage {}
    QtImage {}
    QtImage {}
    QtImage {}
}
