#include <QtQuick>

Q_IMPORT_PLUGIN(QtQuick2Plugin)
Q_IMPORT_PLUGIN(QtSensorsDeclarativeModule)

int main(int argc, char **argv)
{
    QGuiApplication app(argc, argv);

    qputenv("QML2_IMPORT_PATH", "qml");

    QQuickView view(QUrl("qrc:/main.qml"));
    view.setResizeMode(QQuickView::SizeRootObjectToView);

    view.show();

    return app.exec();
}


