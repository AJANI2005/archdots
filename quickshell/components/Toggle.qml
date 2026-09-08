import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

RowLayout {
    id: root

    property string label: ""
    property string icon: ""
    property bool checked: false
    property string toolTipText: ""

    signal toggled()

    spacing: 8

    Rectangle {
        implicitWidth: 38
        implicitHeight: 38
        radius: 11
        color: root.checked ? "#ff453a" : "#e618181c"
        border { width: 1; color: root.checked ? "#4dffffff" : "#14ffffff" }

        Behavior on color {
            ColorAnimation { duration: 90 }
        }

        Behavior on scale {
            NumberAnimation { duration: 90 }
        }

        Text {
            anchors.centerIn: parent
            text: root.icon
            color: root.checked ? "#ffffff" : "#a1a1aa"
            font.pixelSize: 16
            font.family: "0xProto Nerd Font"

            Behavior on color {
                ColorAnimation { duration: 90 }
            }
        }

        MouseArea {
            id: area
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onPressed: parent.scale = 0.92
            onReleased: parent.scale = 1.0
            onClicked: root.toggled()
        }

        ToolTip {
            id: tip
            parent: area
            delay: 300
            timeout: -1
            visible: area.containsMouse && root.toolTipText !== ""
            text: root.toolTipText
            x: area.width / 2 - implicitWidth / 2
            y: area.height + 6

            implicitWidth: Math.max(content.implicitWidth + 28, 160)

            contentItem: Text {
                id: content
                text: tip.text
                color: "#f5f5f7"
                font.pixelSize: 10
                horizontalAlignment: Text.AlignLeft
            }

            background: Rectangle {
                radius: 10
                color: "#f70a0a0d"
                border { width: 1; color: "#14ffffff" }
            }
        }
    }

    Text {
        visible: root.label !== ""
        text: root.label
        color: "#a1a1aa"
        font.pixelSize: 9
    }
}