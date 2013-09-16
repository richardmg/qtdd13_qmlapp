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













qmlRegisterType<IOSCamera>("IOSCamera", 1, 0, "IOSCamera");


#include <UIKit/UIKit.h>
#include <QtGui/5.2.0/QtGui/qpa/qplatformnativeinterface.h>
#include <QtGui>
#include <QtQuick>
#include "IOSCamera.h"

IOSCamera::IOSCamera(QQuickItem *parent) :
    QQuickItem(parent)
{
}

void IOSCamera::open()
{
    UIView *view = static_cast<UIView *>(
                QGuiApplication::platformNativeInterface()->
                nativeResourceForWindow("uiview", window()));

    UIViewController *qtController = [[view window] rootViewController];

    UIImagePickerController *imagePickerController =
            [[UIImagePickerController alloc] init];
    [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];

    [qtController presentViewController:imagePickerController
                                        animated:YES completion:nil];
}
