pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Singleton {
    id: root
    property string filePath: Directories.home + "/.config/quickshell/ii/theme/AetherTheme.json"

    function reapplyTheme() {
        themeFileView.reload()
    }

    function applyColors(fileContent) {
        try {
            const json = JSON.parse(fileContent)
            for (const key in json) {
                if (json.hasOwnProperty(key)) {
                    const camelCaseKey = key.replace(/_([a-z])/g, (g) => g[1].toUpperCase())
                    const m3Key = `m3${camelCaseKey}`
                    Appearance.m3colors[m3Key] = json[key]
                }
            }
            Appearance.m3colors.darkmode = (Appearance.m3colors.m3background.hslLightness < 0.5)
        } catch (e) {
            console.error("MaterialThemeLoader: failed to parse", e)
        }
    }

    function resetFilePathNextTime() {
        resetFilePathNextWallpaperChange.enabled = true
    }

    Connections {
        id: resetFilePathNextWallpaperChange
        enabled: false
        target: Config.options.background
        function onWallpaperPathChanged() {
            root.filePath = ""
            root.filePath = Directories.home + "/.config/quickshell/ii/theme/AetherTheme.json"
            resetFilePathNextWallpaperChange.enabled = false
        }
    }

    Timer {
        id: delayedFileRead
        interval: 100
        repeat: false
        running: false
        onTriggered: {
            themeFileView.reload()
            root.applyColors(themeFileView.text())
        }
    }

    FileView {
        id: themeFileView
        path: Qt.resolvedUrl(root.filePath)
        watchChanges: true
        onFileChanged: {
            themeFileView.reload()
            delayedFileRead.start()
        }
        onLoaded: {
            const fileContent = themeFileView.text()
            root.applyColors(fileContent)
        }
        onLoadFailed: root.resetFilePathNextTime();
    }

    function toggleLightDark() {
        const currentlyDark = Appearance.m3colors.darkmode
        Appearance.m3colors.darkmode = !currentlyDark
        Quickshell.execDetached(["sh", "-c",
            `gsettings set org.gnome.desktop.interface color-scheme '${!currentlyDark ? "prefer-dark" : "prefer-light"}'`
        ])
    }

    GlobalShortcut {
        name: "toggleLightDark"
        description: "Toggles between dark theme and light theme"
        onPressed: root.toggleLightDark()
    }

    IpcHandler {
        target: "theme"
        function toggleLightDark(): void {
            root.toggleLightDark()
        }
    }
}
