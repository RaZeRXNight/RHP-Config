# Quickshell / end-4 II config

Launch: `quickshell -c ii` — Entry at `ii/shell.qml` → `IllogicalImpulseFamily.qml` → panels via `PanelLoader`

## Import paths

- `qs.modules.common` — shared: `Appearance`, `Config`, `GlobalStates`, `Directories`
- `qs.modules.common.widgets` — StyledListView, StyledText, ToolbarTabBar, etc.
- `qs.modules.common.functions` — utility functions
- `qs.modules.ii.*` — module per panel (bar, sidebarLeft, overlay, lock, etc.)
- `qs.services` — all services (50+): MaterialThemeLoader, Notifications, Wallpapers, Audio, etc.

## Shell.qml pragma env

```qml
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000
```

## Code style

`.qmlformat.ini`: 4-space indent, 110 max column width, `ObjectsSpacing=true`, `NormalizeOrder=false`.

## Config & theme

- `Config.options.*` — user settings, backed by `~/.config/illogical-impulse/config.json`
- `Appearance.*` — theme singleton: `colors`, `rounding`, `animation`, `font`, `sizes`, `m3colors`
- `Appearance.m3colors` — Material3 colors, populated by `MaterialThemeLoader` (singleton service)
- `colors.json` → symlink to `~/.config/aether/theme/quickshell-colors.json`
- `AetherTheme.json` → generated M3 colors (gitignored)
- Live reload: Aether writes → `colors.json` symlink → `MaterialThemeLoader` watches → applies M3 colors to `Appearance.m3colors` programmatically

## IPC

```sh
qs -c ii msg <target> <action>
```
Targets: `sidebarLeft`, `sidebarRight`, `overlay`, `search`, `bar`, `clipboard`, `region`, etc. Actions: `toggle`/`open`/`close`.

## Panel visibility state

All booleans on `GlobalStates.*`: `sidebarLeftOpen`, `sidebarRightOpen`, `overlayOpen`, `searchOpen`, `barOpen`, `overviewOpen`, lock-related, etc.

Notable: opening `sidebarRight` auto-dismisses notifications (`onSidebarRightOpenChanged` calls `Notifications.timeoutAll()` + `markAllRead()`).

## PanelLoader conditional loading

```qml
PanelLoader { extraCondition: Config.options.bar.vertical; component: VerticalBar {} }
PanelLoader { extraCondition: Config.options.dock.enable; component: Dock {} }
```

## Left sidebar

- Widths: `Appearance.sizes.sidebarWidth` = 460, `sidebarWidthExtended` = 750
- Pin (Ctrl+P): reserves `exclusiveZone` so bar avoids it
- Detach (Ctrl+D): floats as `FloatingWindow`
- Extend (Ctrl+O): toggles expanded width
- Tab navigation in sidebar: Alt+1 (translator), Alt+2 (aether) via `SidebarKeybinds.js`

### MiniAether (blueprint list)

Highlight driven by `currentItem === delegateRoot` (object reference, never `index`):
```qml
color: (mouseArea.containsMouse || blueprintListView.currentItem === delegateRoot)
    ? Appearance.colors.colSecondaryContainer
    : Appearance.colors.colLayer2
```
`StyledListView` with `keyNavigationEnabled: true` for arrow keys; Enter applies via `Keys.onPressed`.

## Gotchas

- `ScriptModel` + `required property var modelData`: `index` scoping is unreliable. Always use `currentItem === delegateRoot` for comparison.
- `StyledListView` has its own `MouseArea` for touchpad scroll (`acceptedButtons: Qt.NoButton`) — doesn't interfere with delegate clicks/hovers.
- All theme values from `Appearance.*` — never hardcode colors/sizes/fonts.

## Secondary systems

- **Translations**: `ii/translations/` has 14 locales (`.json`), with tools at `translations/tools/` (`manage-translations.sh` for extract/update/status).
- **Scripts**: `ii/scripts/` has subdirs for ai, colors, hyprland, images, videos, cava, etc.
- **Assets**: `ii/assets/icons/fluent/` — modified Windows 11 icons (CC BY 4.0).
