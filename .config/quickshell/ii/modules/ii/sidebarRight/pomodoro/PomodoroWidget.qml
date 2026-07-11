import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    property var tabButtonList: [
        {"name": Translation.tr("Pomodoro"), "icon": "search_activity"},
        {"name": Translation.tr("Stopwatch"), "icon": "timer"}
    ]

    // These are keybinds for stopwatch and pomodoro
    Keys.onPressed: (event) => {
        if (event.modifiers === Qt.NoModifier) {
            if (event.key === Qt.Key_Left || event.key === Qt.Key_H || event.key === Qt.Key_PageUp) {
                tabBar.decrementCurrentIndex();
                event.accepted = true
            }
            else if (event.key === Qt.Key_Right || event.key === Qt.Key_L || event.key === Qt.Key_PageDown) {
                tabBar.incrementCurrentIndex();
                event.accepted = true
            }
            else if (event.key === Qt.Key_Space || event.key === Qt.Key_S) { // Pause/resume with Space or S
                if (tabBar.currentIndex === 0) {
                    TimerService.togglePomodoro()
                } else {
                    TimerService.toggleStopwatch()
                }
                event.accepted = true
            }
            else if (event.key === Qt.Key_R) { // Reset with R
                if (tabBar.currentIndex === 0) {
                    TimerService.resetPomodoro()
                } else {
                    TimerService.stopwatchReset()
                }
                event.accepted = true
            }
            else if (event.key === Qt.Key_L) { // Record lap with L
                TimerService.stopwatchRecordLap()
                event.accepted = true
            }
        }
    }

    onFocusChanged: {
        if (activeFocus && swipeView.currentItem)
            swipeView.currentItem.forceActiveFocus();
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        SecondaryTabBar {
            id: tabBar
            currentIndex: swipeView.currentIndex

            Repeater {
                model: root.tabButtonList
                delegate: SecondaryTabButton {
                    buttonText: modelData.name
                    buttonIcon: modelData.icon
                }
            }
        }

        SwipeView {
            id: swipeView
            Layout.topMargin: 10
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10
            clip: true
            currentIndex: tabBar.currentIndex

            // Tabs
            PomodoroTimer {}
            Stopwatch {}
        }
    }
}
