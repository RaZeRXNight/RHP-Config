.pragma library

// Left sidebar: Alt+1/2/3 for direct tab access
// swipeView: SwipeView to navigate
// tabIndexHelper: function(feature) => swipe index for "translator"/"aether", or -1 if disabled
function handleLeftSidebarAltKey(event, swipeView, tabIndexHelper) {
    if (event.modifiers !== Qt.AltModifier) return false;

    if (event.key >= Qt.Key_1 && event.key <= Qt.Key_2) {
        var map = ["translator", "aether"];
        var idx = tabIndexHelper(map[event.key - Qt.Key_1]);
        if (idx >= 0) swipeView.currentIndex = idx;
        return true;
    }
    return false;
}

// Right sidebar bottom group: Alt+1/2/3 for Calendar/Todo/Timer
// Also expands the group if it was collapsed
function handleBottomGroupAltKey(event, bottomGroup) {
    if (event.modifiers !== Qt.AltModifier) return false;

    if (event.key >= Qt.Key_1 && event.key <= Qt.Key_3) {
        bottomGroup.selectedTab = event.key - Qt.Key_1;
        if (bottomGroup.collapsed) bottomGroup.setCollapsed(false);
        return true;
    }
    return false;
}
