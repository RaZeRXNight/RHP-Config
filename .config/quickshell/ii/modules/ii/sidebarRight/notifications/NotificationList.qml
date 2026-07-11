import qs.modules.common
import qs.modules.common.widgets
import qs.services
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    property int currentGroupIndex: 0

    function getGroupCount() {
        return Notifications.appNameList.length;
    }

    function autoExpandCurrent() {
        var group = listview.itemAtIndex(currentGroupIndex);
        if (group) group.expanded = true;
    }

    function dismissCurrent() {
        var group = listview.itemAtIndex(currentGroupIndex);
        if (group) group.destroyWithAnimation();
        var count = getGroupCount();
        if (count > 0) {
            currentGroupIndex = Math.min(currentGroupIndex, count - 1);
        } else {
            currentGroupIndex = 0;
        }
    }

    function ensureCurrentVisible() {
        listview.positionViewAtIndex(currentGroupIndex, ListView.Contain);
    }

    Keys.onPressed: (event) => {
        var count = getGroupCount();
        if (count === 0) {
            if (event.key === Qt.Key_H || event.key === Qt.Key_L ||
                event.key === Qt.Key_Left || event.key === Qt.Key_Right ||
                event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
                event.accepted = true;
            }
            else if ((event.key === Qt.Key_J || event.key === Qt.Key_K ||
                      event.key === Qt.Key_Down || event.key === Qt.Key_Up) &&
                     !(event.modifiers & Qt.ShiftModifier)) {
                event.accepted = true;
            }
            return;
        }

        if ((event.key === Qt.Key_J || event.key === Qt.Key_Down) && !(event.modifiers & Qt.ShiftModifier)) {
            currentGroupIndex = Math.min(currentGroupIndex + 1, count - 1);
            ensureCurrentVisible();
            autoExpandCurrent();
            event.accepted = true;
        }
        else if ((event.key === Qt.Key_K || event.key === Qt.Key_Up) && !(event.modifiers & Qt.ShiftModifier)) {
            currentGroupIndex = Math.max(currentGroupIndex - 1, 0);
            ensureCurrentVisible();
            autoExpandCurrent();
            event.accepted = true;
        }
        else if (event.key === Qt.Key_H || event.key === Qt.Key_L ||
                 event.key === Qt.Key_Left || event.key === Qt.Key_Right) {
            event.accepted = true;
        }
        else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
            dismissCurrent();
            event.accepted = true;
        }
    }

    NotificationListView { // Scrollable window
        id: listview
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: statusRow.top
        anchors.bottomMargin: 5

        clip: true
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: listview.width
                height: listview.height
                radius: Appearance.rounding.normal
            }
        }

        popup: false
    }

    // Placeholder when list is empty
    PagePlaceholder {
        shown: Notifications.list.length === 0
        icon: "notifications_active"
        description: Translation.tr("Nothing")
        shape: MaterialShape.Shape.Ghostish
        descriptionHorizontalAlignment: Text.AlignHCenter
    }

    ButtonGroup {
        id: statusRow
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        NotificationStatusButton {
            Layout.fillWidth: false
            buttonIcon: "notifications_paused"
            toggled: Notifications.silent
            onClicked: () => {
                Notifications.silent = !Notifications.silent;
            }
        }
        NotificationStatusButton {
            enabled: false
            Layout.fillWidth: true
            buttonText: Translation.tr("%1 notifications").arg(Notifications.list.length)
        }
        NotificationStatusButton {
            Layout.fillWidth: false
            buttonIcon: "delete_sweep"
            onClicked: () => {
                Notifications.discardAllNotifications()
            }
        }
    }
}
