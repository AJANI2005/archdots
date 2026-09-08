import QtQuick
import QtQuick.Controls

Item {
    id: root

    property bool checked: false
    property string icon: ""
    property string toolTipText: ""

    signal toggled()

    implicitWidth: 26
    implicitHeight: 26

    Text {
        anchors.centerIn: parent
        text: root.icon
        color: root.checked ? "#ff453a" : "#86868b"
        font { pixelSize: 16; family: "0xProto Nerd Font" }

        Behavior on color {
            ColorAnimation { duration: 100 }
        }
    }

    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
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

        implicitWidth: Math.max(content.implicitWidth + 24, 150)

        contentItem: Text {
            id: content
            text: tip.text
            color: "#f5f5f7"
            font.pixelSize: 10
            horizontalAlignment: Text.AlignLeft
        }

        background: Rectangle {
            radius: 8
            color: "#e6040609"
            border { width: 1; color: "#1affffff" }
        }
    }
}