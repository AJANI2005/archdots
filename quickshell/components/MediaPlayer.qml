import QtQuick
import QtQuick.Layouts
import "../services"

Row {
    id: root

    spacing: 10

    MediaService {
        id: service
    }

    Rectangle {
        width: 48; height: 48
        radius: 12
        color: "#16ffffff"
        border { width: 1; color: "#1affffff" }
        clip: true

        Image {
            id: art
            anchors.fill: parent
            source: service.artUrl
            sourceSize: Qt.size(48, 48)
            fillMode: Image.PreserveAspectCrop
            visible: service.artUrl !== ""
        }

        Text {
            anchors.centerIn: parent
            text: "♪"
            color: "#a1a1aa"
            font.pixelSize: 19
            visible: service.artUrl === ""
        }

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height / 2
            visible: service.artUrl !== ""
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#00000000" }
                GradientStop { position: 1.0; color: "#40000000" }
            }
        }
    }

    Column {
        width: root.width - 58
        spacing: 2

        Text {
            width: parent.width
            text: service.title || "Nothing playing"
            color: "#f5f5f7"
            elide: Text.ElideRight
            font { pixelSize: 11; bold: true }
        }

        Text {
            width: parent.width
            text: service.artist || ""
            color: "#86868b"
            font.pixelSize: 8
            elide: Text.ElideRight
            visible: service.artist !== ""
        }

        Row {
            spacing: 12

            Text {
                text: "󰒮"
                color: prevHover.hovered ? "#f5f5f7" : "#86868b"
                font { pixelSize: 13; family: "0xProto Nerd Font" }
                HoverHandler { id: prevHover }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: service.previous()
                }
            }

            Text {
                text: service.playing ? "󰏤" : "󰐊"
                color: playHover.hovered ? "#0a84ff" : (service.playing ? "#0a84ff" : "#86868b")
                font { pixelSize: 13; family: "0xProto Nerd Font" }
                HoverHandler { id: playHover }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: service.toggle()
                }
            }

            Text {
                text: "󰒭"
                color: nextHover.hovered ? "#f5f5f7" : "#86868b"
                font { pixelSize: 13; family: "0xProto Nerd Font" }
                HoverHandler { id: nextHover }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: service.next()
                }
            }
        }
    }
}