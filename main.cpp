#include <QtQuick>
#include "ioscamera.h"

Q_IMPORT_PLUGIN(QtQuick2Plugin)
Q_IMPORT_PLUGIN(QtSensorsDeclarativeModule)
Q_IMPORT_PLUGIN(QtQuick2WindowPlugin)

int main(int argc, char **argv)
{
    QGuiApplication app(argc, argv);
    app.primaryScreen()->setOrientationUpdateMask(Qt::PortraitOrientation | Qt::LandscapeOrientation);

    qputenv("QML2_IMPORT_PATH", "qml");
    qmlRegisterType<IOSCamera>("IOSCamera", 1, 0, "IOSCamera");

    QQuickView view(QUrl("qrc:/main.qml"));
    view.setResizeMode(QQuickView::SizeRootObjectToView);

    view.show();

    return app.exec();
}


