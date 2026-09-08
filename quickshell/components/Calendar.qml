import QtQuick

Column {
    id: root

    property date today: new Date()

    Row {
        id: row
        spacing: 11

        Repeater {
            model: 7

            Column {
                property date d: {
                    var x = new Date()
                    x.setDate(
                        x.getDate()
                        - ((x.getDay() + 6) % 7)
                        + index
                    )
                    return x
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Qt.formatDate(parent.d, "ddd").toUpperCase()
                    color: "#6e6e73"
                    font.pixelSize: 7
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: parent.d.getDate()
                    color: parent.d.toDateString() === root.today.toDateString()
                        ? "#0a84ff"
                        : "#86868b"

                    font {
                        pixelSize: 9
                        bold: true
                    }
                }
            }
        }
    }

    Text {
        width: row.width
        horizontalAlignment: Text.AlignHCenter
        text: Qt.formatDate(root.today, "MMM")
        color: "#6e6e73"
        font { pixelSize: 8; bold: true }

        Timer {
            interval: 60000
            repeat: true
            running: true
            onTriggered: root.today = new Date()
        }
    }
}