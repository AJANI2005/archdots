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

    Item {
        Layout.preferredWidth: 44
        Layout.preferredHeight: 44
        Layout.alignment: Qt.AlignVCenter

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
            color: "#86868b"
            font.pixelSize: 18
            visible: service.artUrl === ""
        }
    }

    ColumnLayout {
        id: info
        Layout.fillWidth: true
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
            font { pixelSize: 10; bold: true }
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

            Item {
                width: 26
                height: 26

                Text {
                    anchors.centerIn: parent
                    text: "󰒮"
                    color: prev.containsMouse ? "#f5f5f7" : "#86868b"
                    font { pixelSize: 15; family: "0xProto Nerd Font" }

                    Behavior on color {
                        ColorAnimation { duration: 70 }
                    }
                }

                MouseArea {
                    id: prev
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: service.previous()
                }
            }

            Item {
                width: 26
                height: 26

                Text {
                    anchors.centerIn: parent
                    text: service.playing ? "󰏤" : "󰐊"
                    color: (play.containsMouse || service.playing) ? "#ff453a" : "#86868b"
                    font { pixelSize: 15; family: "0xProto Nerd Font" }

                    Behavior on color {
                        ColorAnimation { duration: 70 }
                    }
                }

                MouseArea {
                    id: play
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: service.toggle()
                }
            }

            Item {
                width: 26
                height: 26

                Text {
                    anchors.centerIn: parent
                    text: "󰒭"
                    color: next.containsMouse ? "#f5f5f7" : "#86868b"
                    font { pixelSize: 15; family: "0xProto Nerd Font" }

                    Behavior on color {
                        ColorAnimation { duration: 70 }
                    }
                }

                MouseArea {
                    id: next
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: service.next()
                }
            }
        }
    }
}