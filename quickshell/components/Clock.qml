import QtQuick
import Quickshell

Text {
    id: root

    property int pixelSize: 10

    text: clock.value
    color: "#f5f5f7"
    antialiasing: true

    font {
        pixelSize: root.pixelSize
        bold: true
        letterSpacing: 1
    }

    Command {
        id: clock
        command: ["date", "+%H·%M"]
        parser: data => data.trim()
        interval: 1000
    }
}
