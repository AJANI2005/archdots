import Quickshell
import QtQuick
import "components"

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            anchors { top: true; left: true; right: true }
            implicitHeight: 70
            exclusiveZone: 15
            color: "transparent"
            mask: Region { item: island }

            DynamicIsland {
                id: island
            }
        }
    }
}
