import QtQuick
import Quickshell
import "../components"

Item {
    id: root

    property int value: ws.value

    Command {
        id: ws
        command: [
            "sh", "-c",
            "mmsg get all-tags | jq -r '.all_tags[].tags[] | select(.is_active == true).index'"
        ]
        parser: data => parseInt(data.trim(), 10)
        interval: 100
    }
}
