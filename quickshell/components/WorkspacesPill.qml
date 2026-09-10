import QtQuick
import "../services"

Rectangle {
    id: root

    property int active: ws.value

    implicitWidth: row.width + 14
    implicitHeight: 22
    radius: 11
    color: "#16130f"
    border { width: 1; color: "#38332d" }

    WorkspaceService {
        id: ws
    }

    Row {
        id: row
        anchors {
            left: parent.left
            leftMargin: 7
            verticalCenter: parent.verticalCenter
        }
        spacing: 5

        Repeater {
            model: 9

            Item {
                required property int index
                property int i: index + 1
                property int clientCount: tagClients.value ?? 0
                property bool isActive: i === root.active

                width: 8
                height: 8

                Command {
                    id: tagClients
                    command: [
                        "sh", "-c",
                        `mmsg get all-tags | jq -r '.all_tags[].tags[] | select(.index == ${i}).client_count'`
                    ]
                    parser: data => {
                        const n = parseInt(data.trim(), 10)
                        return Number.isNaN(n) ? 0 : n
                    }
                    interval: 200
                }

                Rectangle {
                    anchors.centerIn: parent
                    radius: width / 2
                    width: 6
                    height: 6
                    color: isActive
                        ? "#e87962"
                        : (clientCount > 0 ? "#8a8378" : "#4a443c")
                }
            }
        }
    }
}