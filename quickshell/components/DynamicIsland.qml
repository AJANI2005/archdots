import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property bool hovered: hover.hovered
    property bool showControls: false

    property int level: !root.hovered ? 0 : (root.showControls ? 2 : 1)

    anchors {
        top: parent.top
        horizontalCenter: parent.horizontalCenter
    }

    width: root.level === 0 ? 300 : (root.level === 1 ? 640 : 720)
    height: root.level === 0 ? 15 : (root.level === 1 ? 65 : 70)
    radius: height / 2
    color: "#f70a0a0d"
    clip: true

    Behavior on width {
        NumberAnimation {
            duration: 320
            easing.type: Easing.OutCubic
        }
    }

    Behavior on height {
        NumberAnimation {
            duration: 420
            easing.type: Easing.OutCubic
        }
    }

    onHoveredChanged: if (!root.hovered) root.showControls = false
    onShowControlsChanged: if (root.showControls) controlView.refresh()

    HoverHandler {
        id: hover
    }

    Workspaces {
        id: workspaces
        anchors {
            left: parent.left
            leftMargin: 10
            verticalCenter: parent.verticalCenter
        }
        opacity: root.hovered ? 0 : 1
        visible: opacity > 0

        Behavior on opacity {
            NumberAnimation {
                duration: 100
                easing.type: Easing.OutCubic
            }
        }
    }

    Clock {
        id: collapsedClock
        anchors.centerIn: parent
        pixelSize: 10
        opacity: root.hovered ? 0 : 1
        visible: opacity > 0

        Behavior on opacity {
            NumberAnimation {
                duration: 120
                easing.type: Easing.OutCubic
            }
        }
    }

    Clock {
        id: expandedClock
        anchors.centerIn: parent
        pixelSize: 22
        opacity: root.hovered && !root.showControls ? 1 : 0
        visible: opacity > 0

        Behavior on opacity {
            NumberAnimation {
                duration: 120
                easing.type: Easing.OutCubic
            }
        }
    }

    Item {
        id: expanded

        visible: root.hovered || opacity > 0
        opacity: root.hovered ? 1 : 0

        anchors.fill: parent
        anchors.margins: 14

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

        Behavior on opacity {
            NumberAnimation {
                duration: 100
                easing.type: Easing.OutCubic
            }
        }

        RowLayout {
            id: mainView
            anchors.fill: parent
            spacing: 8
            opacity: root.showControls ? 0 : 1
            visible: opacity > 0

            Behavior on opacity {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.OutCubic
                }
            }

            MediaPlayer {
                Layout.preferredWidth: 215
                Layout.minimumWidth: 215
                Layout.maximumWidth: 215
                Layout.fillHeight: true
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Rectangle {
                    anchors.centerIn: parent
                    width: 1
                    height: 26
                    color: "#14ffffff"
                }
            }

            Calendar {
                Layout.preferredWidth: 200
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
                    duration: 100
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        z: 11
        radius: parent.radius
        color: "transparent"
        border { width: 1; color: "#14ffffff" }
    }
}