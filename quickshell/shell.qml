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
            implicitHeight: 62
            exclusiveZone: 0
            color: "transparent"

            Rectangle {
                id: strip
                anchors.fill: parent
                color: "transparent"

                HoverHandler {
                    id: stripHover
                }
            }

            mask: Region { item: strip }

            DynamicIsland {
                id: island
                shown: stripHover.hovered || island.selfHovered
            }
        }
    }
}