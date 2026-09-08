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

    property string wifiTooltip: {
        if (!root.wifiEnabled) return "Wi-Fi is off"
        var name = (wifiInfo.value || "").toString().trim()
        if (name === "") return "Wi-Fi — not connected"
        var lines = ["Wi-Fi — " + name]
        if (wifiSignal.value) lines.push("  Signal  " + wifiSignal.value + "%")
        if (wifiDetails.value) {
            var details = wifiDetails.value.toString().trim()
            if (details !== "") {
                var info = details.split("\n")
                for (var i = 0; i < info.length; i++) {
                    var s = info[i].trim()
                    if (s !== "") lines.push("  " + s)
                }
            }
        }
        return lines.join("\n")
    }

    property string btTooltip: {
        if (!root.btEnabled) return "Bluetooth is off"
        var bName = (btInfo.value || "").toString().trim()
        return bName !== "" && bName !== "No devices connected"
            ? "Bluetooth:  " + bName
            : "Bluetooth — no devices connected"
    }

    function refresh() { brightCmd.run() }

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
        command: ["sh", "-c", "brightnessctl g && brightnessctl m"]
        parser: data => {
            const parts = String(data).trim().split(/\s+/)
            const v = parseFloat(parts[0])
            const m = parseFloat(parts[1])
            if (m > 0 && !isNaN(v)) {
                return Math.min(Math.max(v / m, 0), 1)
            }
            return root.brightness
        }
        interval: 0
    }

    Command {
        id: wifiInfo
        command: ["sh", "-c", "nmcli -t -f NAME,TYPE connection show --active | grep ':802-11-wireless$' | cut -d: -f1 | head -n1"]
        parser: data => (data || "").trim()
        interval: 2000
    }

    Command {
        id: wifiSignal
        command: ["sh", "-c", "IFACE=$(awk 'NR>2{print $1}' /proc/net/wireless | tr -d ':' | head -1); [ -z \"$IFACE\" ] || awk -v I=\"$IFACE\" '$1 ~ (I \":\") {printf \"%.0f\", $3*100/70}' /proc/net/wireless"]
        parser: data => (data || "").trim()
        interval: 2000
    }

    Command {
        id: wifiDetails
        command: ["sh", "-c", "R=$(iw dev 2>/dev/null | awk '/tx bitrate/{print $3\" \"$4; exit}'); [ -z \"$R\" ] && R=$(nmcli -t -f IN-USE,RATE dev wifi 2>/dev/null | awk -F: '/^\\*/{print $2}'); C=$(nmcli -t -f IN-USE,CHAN dev wifi 2>/dev/null | awk -F: '/^\\*/{print $2}'); [ -n \"$R\" ] && echo \"Rate $R\"; [ -n \"$C\" ] && echo \"Channel $C\""]
        parser: data => (data || "").trim()
        interval: 2000
    }

    Command {
        id: btInfo
        command: ["sh", "-c", "bluetoothctl devices Connected | head -n1 | cut -d' ' -f3-"]
        parser: data => {
            const s = String(data).trim()
            if (s !== "") return s
            return root.btEnabled ? "No devices connected" : "Bluetooth is off"
        }
        interval: 2000
    }

    Process { id: wifiSet;   command: ["sh", "-c", "nmcli radio wifi " + (root.wifiEnabled ? "off" : "on")] }
    Process { id: btSet;     command: ["sh", "-c", "bluetoothctl power " + (root.btEnabled ? "off" : "on")] }
    Process { id: audioSet;  command: ["sh", "-c", "pactl set-sink-volume @DEFAULT_SINK@ " + Math.round(root.audioVolume * 100) + "%"] }
    Process { id: brightSet; command: ["sh", "-c", "brightnessctl set " + Math.round(root.brightness * 100) + "%"] }
    Process { id: lockProc;  command: ["swaylock"] }
    Process { id: suspendProc; command: ["systemctl", "suspend"] }
    Process { id: rebootProc; command: ["systemctl", "reboot"] }
    Process { id: powerProc; command: ["systemctl", "poweroff"] }

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
            color: "#e6121418"
            border { width: 1; color: "#14ffffff" }

            Behavior on color {
                ColorAnimation { duration: 100 }
            }

            Row {
                anchors.centerIn: parent
                spacing: 12

                Toggle {
                    id: wifiToggle
                    icon: "󰤨"
                    checked: root.wifiEnabled
                    toolTipText: root.wifiTooltip
                    onToggled: {
                        root.wifiEnabled = !root.wifiEnabled
                        wifiSet.running = true
                    }
                }

                Toggle {
                    id: btToggle
                    icon: "󰂯"
                    checked: root.btEnabled
                    toolTipText: root.btTooltip
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
            color: "#e6121418"
            border { width: 1; color: "#14ffffff" }

            Behavior on color {
                ColorAnimation { duration: 100 }
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
                        font.pixelSize: 16
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
                            color: "#1affffff"

                            Rectangle {
                                width: audioSlider.visualPosition * parent.width
                                height: parent.height
                                radius: 2
                                color: "#ff453a"
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
                        font.pixelSize: 16
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
                            color: "#1affffff"

                            Rectangle {
                                width: brightSlider.visualPosition * parent.width
                                height: parent.height
                                radius: 2
                                color: "#ff453a"
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

        Rectangle {
            Layout.preferredWidth: 150
            Layout.fillHeight: true
            radius: 14
            color: "#e6121418"
            border { width: 1; color: "#14ffffff" }

            Behavior on color {
                ColorAnimation { duration: 100 }
            }

            Row {
                anchors.centerIn: parent
                spacing: 7

                Text {
                    width: 30
                    height: 30
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: "󰌾"
                    color: lockArea.containsMouse ? "#f5f5f7" : "#a1a1aa"
                    font.pixelSize: 16
                    font.family: "0xProto Nerd Font"

                    Behavior on color {
                        ColorAnimation { duration: 70 }
                    }

                    MouseArea {
                        id: lockArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: lockProc.running = true
                    }
                }

                Text {
                    width: 30
                    height: 30
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: "󰜉"
                    color: rebootArea.containsMouse ? "#f5f5f7" : "#a1a1aa"
                    font.pixelSize: 16
                    font.family: "0xProto Nerd Font"

                    Behavior on color {
                        ColorAnimation { duration: 70 }
                    }

                    MouseArea {
                        id: rebootArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: rebootProc.running = true
                    }
                }

                Text {
                    width: 30
                    height: 30
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: ""
                    color: sleepArea.containsMouse ? "#f5f5f7" : "#a1a1aa"
                    font.pixelSize: 16
                    font.family: "0xProto Nerd Font"

                    Behavior on color {
                        ColorAnimation { duration: 70 }
                    }

                    MouseArea {
                        id: sleepArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: suspendProc.running = true
                    }
                }

                Text {
                    width: 30
                    height: 30
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    text: "󰐥"
                    color: powerArea.containsMouse ? "#ff453a" : "#a1a1aa"
                    font.pixelSize: 16
                    font.family: "0xProto Nerd Font"

                    Behavior on color {
                        ColorAnimation { duration: 70 }
                    }

                    MouseArea {
                        id: powerArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: powerProc.running = true
                    }
                }
            }
        }
    }
}