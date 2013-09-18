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

UIView *view = static_cast<UIView *>(QGuiApplication::platformNativeInterface()->nativeResourceForWindow("uiview", window()));
UIViewController *controller = [[view window] rootViewController];

UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
[ipc setSourceType:UIImagePickerControllerSourceTypeCamera];
[controller presentViewController:ipc animated:YES completion:nil];



///////////////////////////////////////////////////////////////////


#ifndef IOSCAMERA_H
#define IOSCAMERA_H

#include <QQuickItem>

class IOSCamera : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(QString imagePath READ imagePath NOTIFY imagePathChanged)

public:
    explicit IOSCamera(QQuickItem *parent = 0);

    QString imagePath() {
        return m_imagePath;
    }

    QString m_imagePath;

signals:
    void imagePathChanged();

public slots:
    void open();

private:
    void *m_delegate;
};

#endif // IOSCAMERA_H


///////////////////////////////////////////////////////////////////


#include <UIKit/UIKit.h>
#include <QtGui/5.2.0/QtGui/qpa/qplatformnativeinterface.h>
#include <QtGui>
#include <QtQuick>
#include "IOSCamera.h"

@interface CameraDelegate : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    IOSCamera *m_iosCamera;
}
@end

@implementation CameraDelegate

- (id) initWithIOSCamera:(IOSCamera *)iosCamera
{
    self = [super init];
    if (self) {
        m_iosCamera = iosCamera;
    }
    return self;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    Q_UNUSED(picker);
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [path stringByAppendingString:@"/capture.png"];
    [UIImagePNGRepresentation(image) writeToFile:path options:NSAtomicWrite error:nil];
    UIViewController *rvc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rvc dismissViewControllerAnimated:YES completion:nil];

    NSRange range;
    range.location = 0;
    range.length = [path length];
    unichar *chars = new unichar[range.length];
    [path getCharacters:chars range:range];
    m_iosCamera->m_imagePath = QStringLiteral("file:") + QString::fromUtf16(chars, range.length);
    delete chars;

    emit m_iosCamera->imagePathChanged();
}

@end

IOSCamera::IOSCamera(QQuickItem *parent) :
    QQuickItem(parent), m_delegate([[CameraDelegate alloc] initWithIOSCamera:this])
{
}

void IOSCamera::open()
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    [ipc setSourceType:UIImagePickerControllerSourceTypeCamera];
    [ipc setDelegate:id(m_delegate)];

    UIView *view = static_cast<UIView *>(QGuiApplication::platformNativeInterface()->nativeResourceForWindow("uiview", window()));
    UIViewController *controller = [[view window] rootViewController];

    [controller presentViewController:ipc animated:YES completion:nil];
}

