import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    property bool hovered: hover.hovered
    property bool showControls: false

    anchors {
        top: parent.top
        horizontalCenter: parent.horizontalCenter
    }

    width: hovered ? 540 : 300
    height: hovered ? 65 : 15
    radius: height / 2
    color: "#e620222a"
    clip: true

    Behavior on width {
        NumberAnimation {
            duration: 350
            easing.type: Easing.OutCubic
        }
    }

    Behavior on height {
        NumberAnimation {
            duration: 350
            easing.type: Easing.OutCubic
        }
    }

    onHoveredChanged: if (!root.hovered) root.showControls = false

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
                duration: 180
                easing.type: Easing.OutCubic
            }
        }
    }

    Clock {
        id: mainClock
        anchors.centerIn: parent
        pixelSize: root.hovered ? 22 : 10
        opacity: root.hovered && root.showControls ? 0 : 1
        visible: opacity > 0

        Behavior on opacity {
            NumberAnimation {
                duration: 180
                easing.type: Easing.OutCubic
            }
        }
    }

    Item {
        id: expanded

        visible: root.hovered || opacity > 0
        opacity: root.hovered ? 1 : 0

        anchors.fill: parent
        anchors.margins: 10

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
                duration: 180
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
                    duration: 180
                    easing.type: Easing.OutCubic
                }
            }

            MediaPlayer {
                Layout.preferredWidth: 215
                Layout.fillHeight: true
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
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
                    duration: 180
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    Rectangle {
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }
        height: parent.height
        z: 10
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#14ffffff" }
            GradientStop { position: 0.4; color: "#00000000" }
            GradientStop { position: 0.55; color: "#00000000" }
            GradientStop { position: 1.0; color: "#28000000" }
        }
    }

    Rectangle {
        anchors.fill: parent
        z: 11
        radius: parent.radius
        color: "transparent"
        border { width: 1; color: "#26ffffff" }
    }
}