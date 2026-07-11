import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth

import qs.modules.ii.sidebarRight.quickToggles.classicStyle

AbstractQuickPanel {
    id: root
    Layout.alignment: Qt.AlignHCenter
    implicitWidth: buttonGroup.implicitWidth
    implicitHeight: buttonGroup.implicitHeight
    color: "transparent"
    property int focusIndex: 0

    function getToggles() {
        var toggles = [];
        for (var i = 0; i < buttonGroup.children.length; i++) {
            var child = buttonGroup.children[i];
            if (child.visible && "clicked" in child) {
                toggles.push(child);
            }
        }
        return toggles;
    }

    Keys.onPressed: (event) => {
        var toggles = getToggles();
        if (toggles.length === 0) {
            event.accepted = true;
            return;
        }

        if (event.key === Qt.Key_H || event.key === Qt.Key_Left) {
            focusIndex = Math.max(0, focusIndex - 1);
            toggles[focusIndex].forceActiveFocus();
            event.accepted = true;
        }
        else if (event.key === Qt.Key_L || event.key === Qt.Key_Right) {
            focusIndex = Math.min(focusIndex + 1, toggles.length - 1);
            toggles[focusIndex].forceActiveFocus();
            event.accepted = true;
        }
        else if ((event.key === Qt.Key_J || event.key === Qt.Key_K ||
                  event.key === Qt.Key_Down || event.key === Qt.Key_Up) &&
                 !(event.modifiers & Qt.ShiftModifier)) {
            event.accepted = true;
        }
        else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
            event.accepted = true;
        }
    }

    ButtonGroup {
        id: buttonGroup
        spacing: 5
        padding: 5
        color: Appearance.colors.colLayer1

        NetworkToggle {
            altAction: () => {
                root.openWifiDialog();
            }
        }
        BluetoothToggle {
            altAction: () => {
                root.openBluetoothDialog();
            }
        }
        NightLight {}
        GameMode {}
        IdleInhibitor {}
        EasyEffectsToggle {}
        CloudflareWarp {}
    }
}
