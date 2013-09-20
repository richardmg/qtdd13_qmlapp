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
