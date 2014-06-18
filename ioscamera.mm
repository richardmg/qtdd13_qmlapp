#include <UIKit/UIKit.h>
#include <QtGui/qpa/qplatformnativeinterface.h>
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

    // Create the path where we want to save the image:
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [path stringByAppendingString:@"/capture.png"];

    // Save image:
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [UIImagePNGRepresentation(image) writeToFile:path options:NSAtomicWrite error:nil];

    // Update imagePath property to trigger QML code:
    m_iosCamera->m_imagePath = QStringLiteral("file:") + QString::fromNSString(path);
    emit m_iosCamera->imagePathChanged();

    // Bring back Qt's view controller:
    UIViewController *rvc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rvc dismissViewControllerAnimated:YES completion:nil];
}

@end

IOSCamera::IOSCamera(QQuickItem *parent) :
    QQuickItem(parent), m_delegate([[CameraDelegate alloc] initWithIOSCamera:this])
{
}

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
    [imageController setDelegate:id(m_delegate)];

    // Tell the imagecontroller to animate on top:
    [qtController presentViewController:imageController animated:YES completion:nil];
}
