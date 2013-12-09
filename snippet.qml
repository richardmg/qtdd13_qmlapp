property real speedX: 0
property real speedY: 0
property real friction: 0.05
property real bounce: 0.6
property real gravity: 0.2

function move(readingX, readingY)
{
    // adjust icon speed:
    speedX -= readingX * gravity;
    speedY += readingY * gravity

    // Calculate where the icon should be:
    x += (speedX > 0) ? Math.max(0, speedX - friction) : Math.min(0, speedX + friction);
    y += (speedY > 0) ? Math.max(0, speedY - friction) : Math.min(0, speedY + friction)

    // Bounce icon back in if outside screen:
    if (x < 0) {
        x = 0
        speedX = speedX * -1 * bounce
    } else  if (x > mainWindow.width - paintedWidth) {
        x = mainWindow.width - paintedWidth
        speedX = speedX * -1 * bounce
    }
    if (y < 0) {
        y = 0
        speedY = speedY * -1 * bounce
    }
    if (y > mainWindow.height - paintedHeight) {
        y = mainWindow.height - paintedHeight
        speedY = speedY * -1 * bounce
    }
}



///////////////////////////////////////////////////////////////////



qmlRegisterType<IOSCamera>("IOSCamera", 1, 0, "IOSCamera");

#include <UIKit/UIKit.h>
#include <QtGui/5.2.0/QtGui/qpa/qplatformnativeinterface.h>
#include <QtGui>
#include <QtQuick>
#include "IOSCamera.h"

void IOSCamera::open()
{
    // Get the UIView that backs our QQuickWindow:
    UIView *view = static_cast<UIView *>(
                QGuiApplication::platformNativeInterface()
                ->nativeResourceForWindow("uiview", window()));
    UIViewController *qtController = [[view window] rootViewController];

    // Create a new image picker controller to show on top of Qt's view controller:
    UIImagePickerController *imageController = [[[UIImagePickerController alloc] init] autorelease];
    [imageController setSourceType:UIImagePickerControllerSourceTypeCamera];

    // Tell the imagecontroller to animate on top:
    [qtController presentViewController:imageController animated:YES completion:nil];
}



///////////////////////////////////////////////////////////////////

import QtQuick 2.1
import QtQuick.Window 2.0
import QtSensors 5.1

Window {
    id: mainWindow
    color: "white"

    Image {
        id: img
        source: "qt.png"
        rotation: Screen.orientation === Qt.PortraitOrientation ? 0 : -90
        Behavior on rotation {
            NumberAnimation {
                duration: 1000
                easing.type: Easing.OutBounce
            }
        }

        property real speedX: 0
        property real speedY: 0
        property real friction: 0.05
        property real bounce: 0.6
        property real gravity: 0.2

        property var tick
        NumberAnimation on tick { to: 1; duration: Number.MAX_VALUE }
        onTickChanged:
        {
            if (!sensor.active)
                return

            // adjust icon speed:
            speedX -= sensor.reading.x * gravity;
            speedY += sensor.reading.y * gravity

            // Calculate where the icon should be:
            x += (speedX > 0) ? Math.max(0, speedX - friction) : Math.min(0, speedX + friction);
            y += (speedY > 0) ? Math.max(0, speedY - friction) : Math.min(0, speedY + friction)

            // Bounce icon back in if outside screen:
            if (x < 0) {
                x = 0
                speedX = speedX * -1 * bounce
            } else  if (x > mainWindow.width - paintedWidth) {
                x = mainWindow.width - paintedWidth
                speedX = speedX * -1 * bounce
            }
            if (y < 0) {
                y = 0
                speedY = speedY * -1 * bounce
            }
            if (y > mainWindow.height - paintedHeight) {
                y = mainWindow.height - paintedHeight
                speedY = speedY * -1 * bounce
            }
        }
    }

    Accelerometer {
        id: sensor
        active: Qt.application.state === Qt.ApplicationActive
    }

}


}
