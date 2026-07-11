import QtQuick
import Quickshell

import qs.modules.common
import qs.modules.ii.bar
import qs.modules.ii.lock
import qs.modules.ii.overview
import qs.modules.ii.sessionScreen
import qs.modules.ii.regionSelector

Scope {
    PanelLoader { component: Bar {} }
    PanelLoader { component: Lock {} }
    PanelLoader { component: Overview {} }
    PanelLoader { component: SessionScreen {} }
    PanelLoader { component: RegionSelector {} }
}
