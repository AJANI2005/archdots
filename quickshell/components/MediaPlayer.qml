import QtQuick
import QtQuick.Layouts
import "../services"

RowLayout {
    id: root

    spacing: 10
    clip: true

    MediaService {
        id: service
    }

    Rectangle {
        Layout.preferredWidth: 46
        Layout.preferredHeight: 46
        Layout.alignment: Qt.AlignTop
        radius: width / 2
        color: "#e616161a"
        border { width: 1; color: "#14ffffff" }

        Canvas {
            id: art
            anchors.fill: parent
            visible: service.artUrl !== ""
            antialiasing: true

            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                ctx.save()
                ctx.beginPath()
                ctx.arc(width / 2, height / 2, width / 2 - 0.5, 0, 2 * Math.PI)
                ctx.closePath()
                ctx.clip()
                ctx.drawImage(service.artUrl, 0, 0, width, height)
                ctx.restore()
            }

            onImageLoaded: requestPaint()

            Connections {
                target: service
                function onArtUrlChanged() { art.requestPaint() }
            }

            Component.onCompleted: requestPaint()
        }

        Text {
            anchors.centerIn: parent
            text: "♪"
            color: "#a1a1aa"
            font.pixelSize: 19
            visible: service.artUrl === ""
        }
    }

    ColumnLayout {
        id: info
        Layout.fillWidth: true
        Layout.preferredWidth: root.width - 56
        Layout.minimumWidth: root.width - 56
        Layout.maximumWidth: root.width - 56
        Layout.alignment: Qt.AlignVCenter
        spacing: 2

        Text {
            Layout.fillWidth: true
            Layout.preferredWidth: info.width
            Layout.minimumWidth: info.width
            Layout.maximumWidth: info.width
            width: info.width
            text: service.title || "Nothing playing"
            color: "#f5f5f7"
            elide: Text.ElideRight
            font { pixelSize: 11; bold: true }
        }

        Text {
            Layout.fillWidth: true
            Layout.preferredWidth: info.width
            Layout.minimumWidth: info.width
            Layout.maximumWidth: info.width
            width: info.width
            text: service.artist || ""
            color: "#86868b"
            font.pixelSize: 8
            elide: Text.ElideRight
            visible: service.artist !== ""
        }

        Row {
            spacing: 6

            Rectangle {
                width: 26
                height: 26
                radius: 8
                color: prevHover.hovered ? "#1affffff" : "#00000000"

                Behavior on color {
                    ColorAnimation { duration: 90 }
                }

                Text {
                    anchors.centerIn: parent
                    text: "󰒮"
                    color: prevHover.hovered ? "#f5f5f7" : "#86868b"
                    font { pixelSize: 16; family: "0xProto Nerd Font" }
                }

                HoverHandler { id: prevHover }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: service.previous()
                }
            }

            Rectangle {
                width: 26
                height: 26
                radius: 8
                color: playHover.hovered
                    ? (service.playing ? "#26ff453a" : "#1affffff")
                    : (service.playing ? "#1aff453a" : "#00000000")

                Behavior on color {
                    ColorAnimation { duration: 90 }
                }

                Text {
                    anchors.centerIn: parent
                    text: service.playing ? "󰏤" : "󰐊"
                    color: (playHover.hovered || service.playing) ? "#ff453a" : "#86868b"
                    font { pixelSize: 16; family: "0xProto Nerd Font" }

                    Behavior on color {
                        ColorAnimation { duration: 90 }
                    }
                }

                HoverHandler { id: playHover }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: service.toggle()
                }
            }

            Rectangle {
                width: 26
                height: 26
                radius: 8
                color: nextHover.hovered ? "#1affffff" : "#00000000"

                Behavior on color {
                    ColorAnimation { duration: 90 }
                }

                Text {
                    anchors.centerIn: parent
                    text: "󰒭"
                    color: nextHover.hovered ? "#f5f5f7" : "#86868b"
                    font { pixelSize: 16; family: "0xProto Nerd Font" }
                }

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