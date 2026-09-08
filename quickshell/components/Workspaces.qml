import QtQuick
import Quickshell
import "../services"

Row {
    id: root

    spacing: 7

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

            implicitWidth: 8
            implicitHeight: 8

            Command {
                id: tagClients
                command: [
                    "sh", "-c",
                    `mmsg get all-tags | jq -r '.all_tags[].tags[] | select(.index == ${i}).client_count'`
                ]
                parser: data => parseInt(data.trim(), 10)
                interval: 100
            }

            Rectangle {
                anchors.centerIn: parent
                width: 4
                height: 4
                radius: 2
                color: i === root.activeWorkspace
                    ? "#ff453a"
                    : (clientCount > 0 ? "#b3f5f5f7" : "#00000000")
                opacity: (clientCount > 0 || i === root.activeWorkspace) ? 1 : 0
            }
        }
    }
}