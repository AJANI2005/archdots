import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root

    property string label: ""
    property string icon: ""
    property bool checked: false

    signal toggled()

    spacing: 8

    Rectangle {
        implicitWidth: 38
        implicitHeight: 38
        radius: 11
        color: root.checked ? "#0a84ff" : "#1affffff"
        border { width: 1; color: root.checked ? "#4dffffff" : "#1affffff" }

        Behavior on color {
            ColorAnimation { duration: 150 }
        }

        Text {
            anchors.centerIn: parent
            text: root.icon
            color: root.checked ? "#ffffff" : "#a1a1aa"
            font.pixelSize: 14
            font.family: "0xProto Nerd Font"

            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: root.toggled()
        }
    }

    Text {
        visible: root.label !== ""
        text: root.label
        color: "#a1a1aa"
        font.pixelSize: 9
    }
}