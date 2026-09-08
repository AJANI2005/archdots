import QtQuick
import Quickshell

Text {
    id: root

    property int pixelSize: 10

    text: clock.value
    color: "#f5f5f7"

    font {
        pixelSize: root.pixelSize
        bold: true
    }

    Behavior on pixelSize {
        NumberAnimation {
            duration: 350
            easing.type: Easing.OutCubic
        }
    }

    Command {
        id: clock
        command: ["date", "+%H·%M"]
        parser: data => data.trim()
        interval: 1000
    }
}
