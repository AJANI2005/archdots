import QtQuick
import Quickshell
import Quickshell.Io
import "../components"

Item {
    id: root

    property string title: meta.value ? String(meta.value).split("||")[0] : ""
    property string artist: meta.value ? String(meta.value).split("||")[1] : ""
    property bool playing: playState.value === true
    property string artUrl: meta.value ? String(meta.value).split("||")[2] : ""

    Process {
        id: nextProc
        command: ["playerctl", "next"]
    }

    Process {
        id: prevProc
        command: ["playerctl", "previous"]
    }

    Process {
        id: playProc
        command: ["playerctl", "play-pause"]
    }

    function toggle() { playProc.running = true }
    function next() { nextProc.running = true }
    function previous() { prevProc.running = true }

    Command {
        id: meta
        command: [
            "sh", "-c",
            "playerctl --format '{{title}}||{{artist}}||{{mpris:artUrl}}' metadata"
        ]
        parser: data => data
        interval: 1000
    }

    Command {
        id: playState
        command: ["playerctl", "status"]
        parser: data => data.trim() === "Playing"
        interval: 500
    }
}