import QtQuick
import Quickshell
import "../components"

Item {
    id: root

    property int value: ws.value ?? 0

    Command {
        id: ws
        command: [
            "sh", "-c",
            "mmsg get all-tags | jq -r '.all_tags[].tags[] | select(.is_active == true).index'"
        ]
        parser: data => {
            const n = parseInt(data.trim(), 10)
            return Number.isNaN(n) ? 0 : n
        }
        interval: 100
    }
}
