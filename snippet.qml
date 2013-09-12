    Image {
        id: img
        source: "qrc:/qt.png"
        x: Math.random() * mainWindow.width
        y: Math.random() * mainWindow.height

        property real speedX: 0
        property real speedY: 0
        property real friction: 0.05
        property real bounce: 0.6
        property real gravity: 0.2
        property bool active: false

        MouseArea {
            anchors.fill: parent
            onClicked: img.active = true
        }

        Connections {
            target: sensor

            onReadingChanged: {
                if (!img.active)
                    return;

                // adjust icon speed:
                img.speedX -= sensor.reading.x * img.gravity;
                img.speedY += sensor.reading.y * img.gravity

                // Calculate where the icon should be:
                img.x += (img.speedX > 0) ? Math.max(0, img.speedX - img.friction) : Math.min(0, img.speedX + img.friction);
                img.y += (img.speedY > 0) ? Math.max(0, img.speedY - img.friction) : Math.min(0, img.speedY + img.friction)

                // Bounce icon back in if outside screen:
                if (img.x < 0) {
                    img.x = 0
                    img.speedX = img.speedX * -1 * img.bounce
                } else  if (img.x > mainWindow.width - img.paintedWidth) {
                    img.x = mainWindow.width - img.paintedWidth
                    img.speedX = img.speedX * -1 * img.bounce
                }
                if (img.y < 0) {
                    img.y = 0
                    img.speedY = img.speedY * -1 * img.bounce
                }
                if (img.y > mainWindow.height - img.paintedHeight) {
                    img.y = mainWindow.height - img.paintedHeight
                    img.speedY = img.speedY * -1 * img.bounce
                }
            }
        }
    }
