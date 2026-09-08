import QtQuick
import Quickshell
import "../services"

Row {
    id: root

    spacing: 5
    opacity: 1

    property int activeWorkspace: ws.value

    WorkspaceService {
        id: ws
    }

    Repeater {
        model: 9

        Item {
            id: tag
            property int i: index + 1

            property int clientCount: tagClients.value

            implicitWidth: numeral.implicitWidth
            implicitHeight: 14

            Command {
                id: tagClients
                command: [
                    "sh", "-c",
                    `mmsg get all-tags | jq -r '.all_tags[].tags[] | select(.index == ${i}).client_count'`
                ]
                parser: data => parseInt(data.trim(), 10)
                interval: 100
            }

            Text {
                id: numeral
                anchors.centerIn: parent
                text: ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"][i - 1]
                color: i === root.activeWorkspace ? "#ff453a" : "#f5f5f7"

                font {
                    pixelSize: 10
                    bold: true
                    family: "0xProto Nerd Font"
                }
            }

            opacity: clientCount > 0
                ? (i === root.activeWorkspace ? 1 : 0.25)
                : 0
        }
    }
}
