import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Io
import "../components"

Item {
    id: root

    property bool wifiEnabled: false
    property bool btEnabled: false
    property real audioVolume: 0
    property real brightness: 0.5

    Command {
        id: wifiCmd
        command: ["sh", "-c", "nmcli -t -f WIFI general"]
        parser: data => data.trim() === "enabled"
        interval: 2000
    }

    Command {
        id: btCmd
        command: ["sh", "-c", "bluetoothctl show | grep 'Powered:' | awk '{print $2}'"]
        parser: data => data.trim() === "yes"
        interval: 3000
    }

    Command {
        id: audioCmd
        command: ["sh", "-c", "pactl get-sink-volume @DEFAULT_SINK@ | grep -o '[0-9]*%' | head -n1"]
        parser: data => {
            const m = String(data).trim().match(/(\d+)%/)
            return m ? parseInt(m[1], 10) / 100 : root.audioVolume
        }
        interval: 1000
    }

    Command {
        id: brightCmd
        command: ["sh", "-c", "brightnessctl -m | awk -F, '{print $4/$5}'"]
        parser: data => {
            const n = parseFloat(String(data).trim())
            return isNaN(n) ? root.brightness : n
        }
        interval: 1000
    }

    Process { id: wifiSet;   command: ["sh", "-c", "nmcli radio wifi " + (root.wifiEnabled ? "off" : "on")] }
    Process { id: btSet;     command: ["sh", "-c", "bluetoothctl power " + (root.btEnabled ? "off" : "on")] }
    Process { id: audioSet;  command: ["sh", "-c", "pactl set-sink-volume @DEFAULT_SINK@ " + Math.round(root.audioVolume * 100) + "%"] }
    Process { id: brightSet; command: ["sh", "-c", "brightnessctl set " + Math.round(root.brightness * 100) + "%"] }

    Connections {
        target: wifiCmd
        function onValueChanged() { root.wifiEnabled = wifiCmd.value === true }
    }

    Connections {
        target: btCmd
        function onValueChanged() { root.btEnabled = btCmd.value === true }
    }

    Connections {
        target: audioCmd
        function onValueChanged() { root.audioVolume = audioCmd.value }
    }

    Connections {
        target: brightCmd
        function onValueChanged() { root.brightness = brightCmd.value }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 10

        Rectangle {
            Layout.preferredWidth: 146
            Layout.fillHeight: true
            radius: 14
            color: "#12ffffff"
            border { width: 1; color: "#1affffff" }

            Behavior on color {
                ColorAnimation { duration: 180 }
            }

            Row {
                anchors.centerIn: parent
                spacing: 12

                Toggle {
                    icon: "󰤨"
                    checked: root.wifiEnabled
                    onToggled: {
                        root.wifiEnabled = !root.wifiEnabled
                        wifiSet.running = true
                    }
                }

                Toggle {
                    icon: "󰂯"
                    checked: root.btEnabled
                    onToggled: {
                        root.btEnabled = !root.btEnabled
                        btSet.running = true
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 14
            color: "#12ffffff"
            border { width: 1; color: "#1affffff" }

            Behavior on color {
                ColorAnimation { duration: 180 }
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 16
                spacing: 18

                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 8

                    Text {
                        text: "󰕾"
                        color: "#a1a1aa"
                        font.pixelSize: 13
                    }

                    Slider {
                        id: audioSlider
                        Layout.fillWidth: true
                        Layout.preferredHeight: 18
                        from: 0; to: 1
                        value: root.audioVolume
                        onMoved: {
                            root.audioVolume = value
                            audioSet.running = true
                        }

                        background: Rectangle {
                            x: audioSlider.leftPadding
                            y: audioSlider.topPadding + audioSlider.availableHeight / 2 - height / 2
                            width: audioSlider.availableWidth
                            height: 4
                            radius: 2
                            color: "#2effffff"

                            Rectangle {
                                width: audioSlider.visualPosition * parent.width
                                height: parent.height
                                radius: 2
                                color: "#0a84ff"
                            }
                        }

                        handle: Rectangle {
                            x: audioSlider.leftPadding + audioSlider.visualPosition * (audioSlider.availableWidth - width)
                            y: audioSlider.topPadding + audioSlider.availableHeight / 2 - height / 2
                            width: 13; height: 13
                            radius: 6.5
                            color: "#f5f5f7"
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 8

                    Text {
                        text: "󰃟"
                        color: "#a1a1aa"
                        font.pixelSize: 13
                    }

                    Slider {
                        id: brightSlider
                        Layout.fillWidth: true
                        Layout.preferredHeight: 18
                        from: 0; to: 1
                        value: root.brightness
                        onMoved: {
                            root.brightness = value
                            brightSet.running = true
                        }

                        background: Rectangle {
                            x: brightSlider.leftPadding
                            y: brightSlider.topPadding + brightSlider.availableHeight / 2 - height / 2
                            width: brightSlider.availableWidth
                            height: 4
                            radius: 2
                            color: "#2effffff"

                            Rectangle {
                                width: brightSlider.visualPosition * parent.width
                                height: parent.height
                                radius: 2
                                color: "#0a84ff"
                            }
                        }

                        handle: Rectangle {
                            x: brightSlider.leftPadding + brightSlider.visualPosition * (brightSlider.availableWidth - width)
                            y: brightSlider.topPadding + brightSlider.availableHeight / 2 - height / 2
                            width: 13; height: 13
                            radius: 6.5
                            color: "#f5f5f7"
                        }
                    }
                }
            }
        }
    }
}