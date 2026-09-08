import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property bool showControls: false
    property bool shown: false
    property bool selfHovered: selfHover.hovered

    anchors {
        top: parent.top
        topMargin: root.shown ? 0 : -root.height
        horizontalCenter: parent.horizontalCenter
    }

    width: root.showControls ? 600 : 520
    height: 62
    color: "transparent"

    Behavior on anchors.topMargin {
        NumberAnimation {
            duration: 400
            easing.type: Easing.OutCubic
        }
    }

    Behavior on width {
        NumberAnimation {
            duration: 240
            easing.type: Easing.OutCubic
        }
    }

    onShowControlsChanged: if (root.showControls) controlView.refresh()

    Canvas {
        id: bg
        anchors.fill: parent
        antialiasing: true

        property real corner: 18

        onPaint: {
            var ctx = getContext("2d")
            var w = width
            var h = height
            var r = bg.corner
            ctx.clearRect(0, 0, w, h)
            ctx.beginPath()
            ctx.moveTo(r, h)
            ctx.arcTo(0, h, 0, h - r, r)
            ctx.lineTo(0, 0)
            ctx.lineTo(w, 0)
            ctx.lineTo(w, h - r)
            ctx.arcTo(w, h, w - r, h, r)
            ctx.closePath()
            ctx.fillStyle = "#66090a0d"
            ctx.fill()
        }
    }

    HoverHandler {
        id: selfHover
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        propagateComposedEvents: true
        onClicked: function(mouse) {
            if (mouse.button === Qt.RightButton) {
                root.showControls = !root.showControls
            }
            mouse.accepted = false
        }
    }

    Item {
        anchors.fill: parent
        anchors.margins: 12

        RowLayout {
            id: mainView
            anchors.fill: parent
            spacing: 14

            opacity: root.showControls ? 0 : 1
            visible: opacity > 0

            Behavior on opacity {
                NumberAnimation {
                    duration: 120
                    easing.type: Easing.OutCubic
                }
            }

            Workspaces {
                Layout.alignment: Qt.AlignVCenter
            }

            Item {
                Layout.fillWidth: true
            }

            Clock {
                id: expandedClock
                pixelSize: 20
                Layout.alignment: Qt.AlignVCenter
            }

            Item {
                Layout.fillWidth: true
            }

            MediaPlayer {
                Layout.preferredWidth: 210
                Layout.minimumWidth: 210
                Layout.maximumWidth: 210
                Layout.alignment: Qt.AlignVCenter
            }
        }

        ControlPanel {
            id: controlView
            anchors.fill: parent
            opacity: root.showControls ? 1 : 0
            visible: opacity > 0

            Behavior on opacity {
                NumberAnimation {
                    duration: 120
                    easing.type: Easing.OutCubic
                }
            }
        }
    }
}