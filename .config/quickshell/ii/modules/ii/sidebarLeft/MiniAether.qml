import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Io

Item {
    id: root
    property real padding: 4
    property var blueprints: []
    property string activeBlueprintName: ""
    property string applyingBlueprintName: ""
    property bool loadingBlueprints: true
    property bool hasError: false
    property var activeBlueprint: {
        if (root.activeBlueprintName.length === 0) return null;
        for (const bp of root.blueprints) {
            if (bp.name === root.activeBlueprintName) return bp;
        }
        return null;
    }
    property var inactiveBlueprints: root.blueprints.filter(bp => bp.name !== root.activeBlueprintName)
    property var allCommands: [
        {
            name: "refresh",
            description: Translation.tr("Refresh the list of available blueprints"),
            execute: () => {
                root.refreshBlueprints();
            }
        },
        {
            name: "current",
            description: Translation.tr("Show the currently active blueprint"),
            execute: () => {
                root.fetchCurrentTheme();
            }
        },
    ]

    onFocusChanged: focus => {
        if (focus) {
            blueprintListView.forceActiveFocus();
        }
    }

    function refreshBlueprints() {
        root.loadingBlueprints = true;
        root.hasError = false;
        listProc.running = true;
    }

    function fetchCurrentTheme() {
        currentProc.running = true;
    }

    function parseBlueprints(buffer) {
        const start = buffer.indexOf('{');
        if (start < 0) {
            root.hasError = true;
            root.loadingBlueprints = false;
            return;
        }
        try {
            const parsed = JSON.parse(buffer.substring(start));
            root.blueprints = parsed.blueprints || [];
            root.loadingBlueprints = false;
            // After listing, fetch current theme to determine active blueprint
            root.fetchCurrentTheme();
        } catch (e) {
            console.error("[MiniAether] Failed to parse blueprints:", e);
            root.hasError = true;
            root.loadingBlueprints = false;
        }
    }

    function parseCurrentTheme(buffer) {
        const start = buffer.indexOf('{');
        if (start < 0) return;
        try {
            const current = JSON.parse(buffer.substring(start));
            const currentAccent = current.colors?.[4] ?? "";
            // Find matching blueprint by accent color
            root.activeBlueprintName = "";
            for (const bp of root.blueprints) {
                if (bp.colors?.[4] === currentAccent) {
                    root.activeBlueprintName = bp.name;
                    break;
                }
            }
        } catch (e) {
            console.error("[MiniAether] Failed to parse current theme:", e);
        }
    }

    function applyBlueprint(name) {
        if (root.applyingBlueprintName.length > 0) return; // Already applying one
        root.applyingBlueprintName = name;
        applyProc.command = ["bash", "-c", `aether --apply-blueprint '${StringUtils.shellSingleQuoteEscape(name)}'`];
        applyProc.running = true;
    }

    Component.onCompleted: {
        root.refreshBlueprints();
    }

    Process {
        id: listProc
        command: ["bash", "-c", "aether --list-blueprints --json"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                root.parseBlueprints(text);
            }
        }
        stderr: SplitParser {
            onRead: data => {
                console.error("[MiniAether] list stderr:", data);
            }
        }
        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0) {
                root.hasError = true;
                root.loadingBlueprints = false;
                console.error("[MiniAether] Failed to list blueprints, exit code:", exitCode);
            }
        }
    }

    Process {
        id: currentProc
        command: ["bash", "-c", "aether --current-theme --json"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                root.parseCurrentTheme(text);
            }
        }
        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0) {
                console.error("[MiniAether] Failed to get current theme, exit code:", exitCode);
            }
        }
    }

    Process {
        id: applyProc
        running: false
        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) {
                // Success - update active blueprint name
                root.activeBlueprintName = root.applyingBlueprintName;
                // Refresh current theme to confirm
                root.fetchCurrentTheme();
                // Fire post-apply scripts in background (they set wallpaper + generate M3 colors)
                reloadPostApplyProc.running = true;
                quickshellPostApplyProc.command = [
                    "bash",
                    Directories.home + "/.config/aether/custom/quickshell/post-apply.sh",
                    root.applyingBlueprintName
                ];
                quickshellPostApplyProc.running = true;
            } else {
                console.error("[MiniAether] Failed to apply blueprint");
            }
            root.applyingBlueprintName = "";
        }
    }

    Process {
        id: reloadPostApplyProc
        command: ["bash", Directories.home + "/.config/aether/custom/reload/post-apply.sh"]
        running: false
    }

    Process {
        id: quickshellPostApplyProc
        command: ["bash", Directories.home + "/.config/aether/custom/quickshell/post-apply.sh"]
        running: false
    }

    Keys.onPressed: event => {
        if (event.key === Qt.Key_F5) {
            root.refreshBlueprints();
            event.accepted = true;
        }
        else if (event.key === Qt.Key_J) {
            blueprintListView.incrementCurrentIndex();
            event.accepted = true;
        }
        else if (event.key === Qt.Key_K) {
            blueprintListView.decrementCurrentIndex();
            event.accepted = true;
        }
        else if ((event.key === Qt.Key_Return || event.key === Qt.Key_Enter) && !root.applyingBlueprintName) {
            var item = blueprintListView.currentItem;
            if (item && item.modelData) {
                root.applyBlueprint(item.modelData.name);
                event.accepted = true;
            }
        }
    }

    ColumnLayout {
        anchors {
            fill: parent
            margins: root.padding
        }
        spacing: root.padding

        // Header row
        Item {
            Layout.fillWidth: true
            implicitHeight: headerRow.implicitHeight

            RowLayout {
                id: headerRow
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
                spacing: 6

                MaterialSymbol {
                    text: "palette"
                    iconSize: Appearance.font.pixelSize.huge
                    color: Appearance.colors.colOnLayer1
                }

                StyledText {
                    Layout.fillWidth: true
                    font {
                        pixelSize: Appearance.font.pixelSize.larger
                        family: Appearance.font.family.title
                        variableAxes: Appearance.font.variableAxes.title
                    }
                    color: Appearance.colors.colOnLayer1
                    text: Translation.tr("Mini Aether")
                }

                StyledText {
                    visible: !root.loadingBlueprints && root.blueprints.length > 0
                    font.pixelSize: Appearance.font.pixelSize.smaller
                    color: Appearance.colors.colSubtext
                    text: `(${root.blueprints.length})`
                }

                IconToolbarButton {
                    id: refreshButton
                    text: "refresh"
                    toggled: root.loadingBlueprints
                    onClicked: root.refreshBlueprints()
                    ToolTip.visible: hovered
                    ToolTip.text: Translation.tr("Refresh blueprints")
                }
            }
        }

        // Content area
        Rectangle {
            id: contentArea
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: Appearance.rounding.normal
            color: Appearance.colors.colLayer1
            clip: true

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: contentArea.width
                    height: contentArea.height
                    radius: Appearance.rounding.small
                }
            }

            // Loading state
            MaterialLoadingIndicator {
                id: loadingIndicator
                anchors.centerIn: parent
                loading: root.loadingBlueprints
                visible: loading
                z: 10
                scale: 1.2
            }

            // Error state
            Item {
                anchors.fill: parent
                visible: root.hasError && !root.loadingBlueprints
                z: 9

                PagePlaceholder {
                    anchors.centerIn: parent
                    icon: "error"
                    title: Translation.tr("Could not load blueprints")
                    description: Translation.tr("Make sure Aether is installed and available")
                }

                RippleButton {
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        bottom: parent.bottom
                        bottomMargin: 40
                    }
                    implicitWidth: 120
                    implicitHeight: 36
                    buttonRadius: Appearance.rounding.small
                    colBackground: Appearance.colors.colPrimary
                    contentItem: StyledText {
                        anchors.centerIn: parent
                        color: Appearance.colors.colOnPrimary
                        text: Translation.tr("Retry")
                        font.pixelSize: Appearance.font.pixelSize.small
                    }
                    onClicked: root.refreshBlueprints()
                }
            }

            // Empty state
            PagePlaceholder {
                anchors.fill: parent
                icon: "palette"
                title: Translation.tr("No blueprints saved")
                description: Translation.tr("Save a theme in Aether to see it here")
                shown: !root.loadingBlueprints && !root.hasError && root.blueprints.length === 0
            }

            // All blueprints are active (list empty)
            PagePlaceholder {
                anchors.centerIn: parent
                icon: "check_circle"
                title: Translation.tr("Only one blueprint — it's the active one above")
                description: ""
                shown: !root.loadingBlueprints && !root.hasError && root.blueprints.length > 0 && root.inactiveBlueprints.length === 0
            }

            // Active blueprint card (pinned top)
            Item {
                id: activeCardItem
                visible: root.activeBlueprint !== null && !root.loadingBlueprints && !root.hasError && root.inactiveBlueprints.length > 0
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                }
                implicitHeight: activeCardBackground.implicitHeight + 4

                Rectangle {
                    id: activeCardBackground
                    anchors {
                        left: parent.left
                        right: parent.right
                        margins: 2
                    }
                    radius: Appearance.rounding.normal
                    color: Appearance.colors.colSecondaryContainer
                    border {
                        width: 1
                        color: Appearance.colors.colSecondary
                    }
                    implicitHeight: activeCardLayout.implicitHeight + 12

                    RowLayout {
                        id: activeCardLayout
                        anchors {
                            fill: parent
                            margins: 6
                        }
                        spacing: 8

                        Rectangle {
                            implicitWidth: 3
                            implicitHeight: 36
                            radius: 2
                            color: Appearance.colors.colSecondary
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 4

                            StyledText {
                                Layout.fillWidth: true
                                font {
                                    pixelSize: Appearance.font.pixelSize.medium
                                    bold: true
                                }
                                color: Appearance.colors.colOnSecondaryContainer
                                text: root.activeBlueprint?.name ?? ""
                                elide: Text.ElideRight
                            }

                            Flow {
                                id: activeCardColorDotRow
                                Layout.fillWidth: true
                                spacing: 2
                                visible: (root.activeBlueprint?.colors?.length ?? 0) > 0
                                property list<var> bpColors: root.activeBlueprint?.colors ?? []

                                Repeater {
                                    model: activeCardColorDotRow.bpColors.length
                                    delegate: Rectangle {
                                        required property int index
                                        implicitWidth: 10
                                        implicitHeight: 10
                                        radius: 2
                                        color: activeCardColorDotRow.bpColors[index] ?? "#000000"
                                        border {
                                            width: 1
                                            color: Appearance.colors.colLayer1
                                        }
                                    }
                                }
                            }

                            Item {
                                id: activeThumbnailItem
                                Layout.fillWidth: true
                                Layout.preferredHeight: 140
                                clip: true
                                visible: (root.activeBlueprint?.wallpaper?.length ?? 0) > 0

                                ThumbnailImage {
                                    anchors.fill: parent
                                    sourcePath: root.activeBlueprint?.wallpaper ?? ""
                                    generateThumbnail: true
                                    fillMode: Image.PreserveAspectCrop

                                    layer.enabled: true
                                    layer.effect: OpacityMask {
                                        maskSource: Rectangle {
                                            width: activeThumbnailItem.width
                                            height: activeThumbnailItem.height
                                            radius: Appearance.rounding.small
                                        }
                                    }
                                }
                            }

                            StyledText {
                                visible: (root.activeBlueprint?.wallpaper?.length ?? 0) > 0
                                font.pixelSize: Appearance.font.pixelSize.smaller
                                color: Appearance.colors.colOnSecondaryContainer
                                text: {
                                    const path = root.activeBlueprint?.wallpaper ?? "";
                                    const parts = path.split("/");
                                    return parts[parts.length - 1] || "";
                                }
                                elide: Text.ElideLeft
                            }
                        }

                        StyledText {
                            Layout.alignment: Qt.AlignTop
                            font.pixelSize: Appearance.font.pixelSize.smaller
                            color: Appearance.colors.colOnSecondaryContainer
                            text: Translation.tr("Active")
                        }
                    }
                }
            }

            // Blueprint list
            ScrollEdgeFade {
                target: blueprintListView
                vertical: true
                fadeSize: 80
            }

            StyledListView {
                id: blueprintListView
                clip: true
                keyNavigationEnabled: true
                anchors {
                    top: activeCardItem.visible ? activeCardItem.bottom : parent.top
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }
                anchors.topMargin: 10
                anchors.bottomMargin: 4
                spacing: 6
                visible: !root.loadingBlueprints && !root.hasError && root.inactiveBlueprints.length > 0

                model: ScriptModel {
                    values: root.inactiveBlueprints
                }

                delegate: Item {
                    id: delegateRoot
                    required property var modelData
                    property bool isApplying: root.applyingBlueprintName.length > 0 && root.applyingBlueprintName === modelData.name

                    width: ListView.view.width
                    implicitHeight: cardBackground.implicitHeight + 2

                    Rectangle {
                        id: cardBackground
                        anchors {
                            left: parent.left
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                            margins: 2
                        }
                        radius: Appearance.rounding.normal
                        color: (mouseArea.containsMouse || blueprintListView.currentItem === delegateRoot) ? Appearance.colors.colSecondaryContainer : Appearance.colors.colLayer2
                        implicitHeight: cardContentLayout.implicitHeight + 12

                        Behavior on color {
                            animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
                        }

                        RowLayout {
                            id: cardContentLayout
                            anchors {
                                fill: parent
                                margins: 6
                            }
                            spacing: 8

                            ColumnLayout {
                                Layout.fillWidth: true
                                spacing: 4

                                // Blueprint name
                                StyledText {
                                    Layout.fillWidth: true
                                    font.pixelSize: Appearance.font.pixelSize.medium
                                    color: Appearance.colors.colOnLayer1
                                    text: modelData.name
                                    elide: Text.ElideRight
                                }

                                // 16-color dot row
                                Flow {
                                    id: colorDotRow
                                    Layout.fillWidth: true
                                    spacing: 2
                                    property list<var> bpColors: modelData.colors || []

                                    Repeater {
                                        model: colorDotRow.bpColors.length
                                        delegate: Rectangle {
                                            required property int index
                                            implicitWidth: 10
                                            implicitHeight: 10
                                            radius: 2
                                            color: colorDotRow.bpColors[index] ?? "#000000"
                                            border {
                                                width: 1
                                                color: Appearance.colors.colLayer1
                                            }
                                        }
                                    }
                                }

                                // Wallpaper preview thumbnail
                                Item {
                                    id: wallpaperPreviewItem
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 140
                                    clip: true
                                    visible: modelData.wallpaper?.length > 0

                                    ThumbnailImage {
                                        anchors.fill: parent
                                        sourcePath: modelData.wallpaper ?? ""
                                        generateThumbnail: true
                                        fillMode: Image.PreserveAspectCrop

                                        layer.enabled: true
                                        layer.effect: OpacityMask {
                                            maskSource: Rectangle {
                                                width: wallpaperPreviewItem.width
                                                height: wallpaperPreviewItem.height
                                                radius: Appearance.rounding.small
                                            }
                                        }
                                    }
                                }

                                // Wallpaper filename
                                StyledText {
                                    visible: modelData.wallpaper?.length > 0
                                    font.pixelSize: Appearance.font.pixelSize.smaller
                                    color: Appearance.colors.colSubtext
                                    text: {
                                        const path = modelData.wallpaper ?? "";
                                        const parts = path.split("/");
                                        return parts[parts.length - 1] || "";
                                    }
                                    elide: Text.ElideLeft
                                }
                            }

                            // Applying indicator
                            MaterialLoadingIndicator {
                                visible: delegateRoot.isApplying
                                implicitSize: 28
                                Layout.alignment: Qt.AlignVCenter
                            }
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (!delegateRoot.isApplying) {
                                    blueprintListView.currentIndex = (blueprintListView.currentItem === delegateRoot) ? -1 : index;
                                    root.applyBlueprint(modelData.name);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
