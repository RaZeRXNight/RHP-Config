import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Qt.labs.synchronizer
import "../../common/SidebarKeybinds.js" as SidebarKeybinds

Item {
    id: root
    required property var scopeRoot
    property int sidebarPadding: 10
    anchors.fill: parent
    property bool translatorEnabled: Config.options.sidebar.translator.enable
    property bool miniAetherEnabled: Config.options.policies.aether !== 0

    // Tab registry — add new tabs by adding a Component + one object entry here
    property var tabs: [
        {
            "name": Translation.tr("Translator"),
            "icon": "translate",
            "feature": "translator",
            "page": component_translator,
            "enabled": root.translatorEnabled
        },
        {
            "name": Translation.tr("Mini Aether"),
            "icon": "palette",
            "feature": "aether",
            "page": component_miniAether,
            "enabled": root.miniAetherEnabled
        },
    ]

    property var tabButtonList: {
        var list = [];
        for (var i = 0; i < root.tabs.length; i++) {
            if (root.tabs[i].enabled)
                list.push({"icon": root.tabs[i].icon, "name": root.tabs[i].name});
        }
        if (list.length === 0)
            list.push({"icon": "block", "name": Translation.tr("No tabs")});
        return list;
    }

    function tabIndex(feature) {
        var idx = 0;
        for (var i = 0; i < root.tabs.length; i++) {
            if (!root.tabs[i].enabled) continue;
            if (root.tabs[i].feature === feature) return idx;
            idx++;
        }
        return -1;
    }

    Connections {
        target: GlobalStates
        function onSidebarLeftOpenChanged() {
            if (GlobalStates.sidebarLeftOpen) {
                if (root.miniAetherEnabled) {
                    var idx = root.tabIndex("aether");
                    if (idx >= 0) swipeView.currentIndex = idx;
                }
                Qt.callLater(root.focusActiveItem);
            }
        }
    }

    function focusActiveItem() {
        swipeView.currentItem.forceActiveFocus()
    }

    Keys.onPressed: (event) => {
        if (event.modifiers === Qt.ControlModifier) {
            if (event.key === Qt.Key_PageDown) {
                swipeView.incrementCurrentIndex()
                event.accepted = true;
            }
            else if (event.key === Qt.Key_PageUp) {
                swipeView.decrementCurrentIndex()
                event.accepted = true;
            }
        }
        else if (SidebarKeybinds.handleLeftSidebarAltKey(event, swipeView, root.tabIndex)) {
            event.accepted = true;
        }
    }

    ColumnLayout {
        anchors {
            fill: parent
            margins: sidebarPadding
        }
        spacing: sidebarPadding

        Toolbar {
            visible: tabButtonList.length > 0 && tabButtonList[0].name !== Translation.tr("No tabs")
            Layout.alignment: Qt.AlignHCenter
            enableShadow: false
            ToolbarTabBar {
                id: tabBar
                Layout.alignment: Qt.AlignHCenter
                tabButtonList: root.tabButtonList
                currentIndex: swipeView.currentIndex
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            implicitWidth: swipeView.implicitWidth
            implicitHeight: swipeView.implicitHeight
            radius: Appearance.rounding.normal
            color: Appearance.colors.colLayer1

            SwipeView {
                id: swipeView
                anchors.fill: parent
                spacing: 10
                currentIndex: tabBar.currentIndex

                clip: true
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        width: swipeView.width
                        height: swipeView.height
                        radius: Appearance.rounding.small
                    }
                }

                Component.onCompleted: {
                    var pages = [];
                    for (var i = 0; i < root.tabs.length; i++) {
                        if (root.tabs[i].enabled)
                            pages.push(root.tabs[i].page.createObject());
                    }
                    if (pages.length === 0)
                        pages.push(placeholder.createObject());
                    contentChildren = pages;
                }
            }
        }

        Component {
            id: component_translator
            Translator {}
        }
        Component {
            id: component_miniAether
            MiniAether {}
        }
        Component {
            id: placeholder
            Item {
                StyledText {
                    anchors.centerIn: parent
                    text: Translation.tr("Enjoy your empty sidebar...")
                    color: Appearance.colors.colSubtext
                }
            }
        }
    }
}
