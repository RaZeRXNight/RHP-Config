# RHP-Config

Arch Linux / Hyprland (Wayland) personal dotfiles.

## Non-obvious facts

- **Hyprland config is Lua**, not `hyprland.conf`. Entry: `.config/hypr/hyprland.lua` which `require()`s modules from `hyprland/`. Edit `keybinds.lua`, `general.lua`, etc.
- **App defaults** (terminal, browser, editor, menu) → `.config/hypr/hyprland/variables.lua`.
- **Theme integration** flows through `execs.lua` (does `dofile(".../RHPTheme/Theme/hyprland.conf")` — sets border colors).
- **Lock screen config lives in `.config/hyprlock/`**. `.config/hypr/hyprlock.conf` sources paths under `.config/hyprlock/`.
- **ZDOTDIR = `~/.config/zsh/`**. The installer writes `export ZDOTDIR="$HOME/.config/zsh"` to `~/.zshenv`. Inside ZDOTDIR, `.zshenv` sources `conf.d/*.zsh` first, then loads `oh-my-zsh`. Local overrides go in `user.zsh`.
- **Setup**: run `setup/install.sh`. It backs up existing configs, symlinks `.config/` and `.local/bin/`, installs Arch packages, configures ZDOTDIR, oh-my-zsh, and systemd user services.
- **Script naming**: `rhp-*` = custom utilities, `aether-*` = theme integration.

## Login / SDDM

- **SDDM is the display manager**, themed via [qylock](https://github.com/Darkkal44/qylock) (`material-you` default). Set up by `setup/sddm.sh` (called optionally from `install.sh`), NOT by symlinking — theme lives in `/usr/share/sddm/themes/<theme>` and config in `/etc/sddm.conf.d/` (both system dirs, need sudo).
- **`setup/sddm.sh [theme]`** clones qylock to a temp dir (repo is ~560 MB, video-heavy) and copies only the selected theme. Re-run with a different theme name to switch.
- **VT layout**: `sddm.service` has `Conflicts=getty@tty1`, so the greeter takes tty1 and the session lands on tty2. `getty@tty1` stays enabled as a fallback console.
- **Session start moved to SDDM**: the old `exec uwsm start default` block in `.config/zsh/user.zsh` is commented out. Choose the **Hyprland (uwsm)** session (`hyprland-uwsm.desktop`) in the greeter. To revert: uncomment that block and `systemctl disable sddm.service`.
- **Config**: `/etc/sddm.conf.d/10-general.conf` forces `DisplayServer=x11` and empties `InputMethod=` (stops qylock's virtual-keyboard popup). `10-theme.conf` sets the current theme. No autologin (password login).

## Quickshell (end-4 illogical-impulse minimal)

- **Shell**: `quickshell -c ii` — entrypoint is `.config/quickshell/ii/shell.qml`. Autostarted from `execs.lua`.
- **Minimal family** (`MinimalFamily.qml`) loads only: **Bar**, **Overview** (launcher + workspaces), **Lock**, **SessionScreen**.
- Sidebars, overlay, cheatsheet, dock, media controls, OSD, on-screen keyboard, wallpaper selector, polkit, region selector, and screen corners are unloaded.

## Quickshell IPC keybinds

All registered in `hypr/hyprland/keybinds.lua`. Trigger via `qs -c ii msg <target> <function>`.

| Binding | IPC Command | Function |
|---|---|---|
| `SUPER + SPACE` | `search toggle` | Open launcher/overview |
| `SUPER + Escape` | `session toggle` | Power menu / session screen |
| `SUPER + TAB` | `search workspacesToggle` | Workspace overview |
| `SUPER + L` | `lock activate` | Lock screen |
| `SUPER + V` | `search clipboardToggle` | Clipboard in overview |
| `SUPER + CTRL + B` | `bar toggle` | Toggle bar visibility |
| `SUPER + CTRL + D` | `theme toggleLightDark` | Toggle dark/light mode |
| `SUPER + ALT + Print` | `region screenshot` | Region screenshot |
| `SUPER + SHIFT + R` | `region record` | Start screen recording |
| `SUPER + PERIOD` | `search emojiToggle` | Emoji picker |
| `F2` | `brightness decrement` | Brightness down |
| `F3` | `brightness increment` | Brightness up |

Fine-step brightness (`SHIFT + F2/F3`) uses `rhp-brightness` script. Stop recording (`SUPER + ALT + R`) uses `rhp-capture-screenrecording --stop-recording`.

## Theme bridge: Aether → Quickshell

- **Aether custom template**: `.config/aether/custom/quickshell/` — `config.json` describes template, `colors.json` defines palette placeholders, `post-apply.sh` converts palette to M3 JSON.
- **Generated output**: `.config/quickshell/ii/theme/AetherTheme.json` — Material3 colors computed from Aether palette. Symlink at `.config/quickshell/ii/theme/colors.json` → `.config/aether/theme/quickshell-colors.json`.
- **Live reload**: `MaterialThemeLoader.qml` watches `AetherTheme.json` with `FileView.watchChanges` (100ms debounce). On change, parses JSON and assigns each key to `Appearance.m3colors`. Auto-detects dark mode from background lightness.
- **IPC for theme**: `qs -c ii msg theme toggleLightDark` toggles dark/light from Hyprland keybinds.

## `.local/bin/` scripts

- `rhp-*` = custom utilities, `aether-*` = theme integration.
- `rhp-brightness` kept for fine-step fallback (`SHIFT + F2/F3`).
- **Wallpaper**: set via `aether-wallpaper`. `awww` daemon autostarted from `execs.lua`.

## Removed features (slimming)

- **Waybar**, **wlogout**, **swayosd**, **ghostty**, **rofi** — removed entirely (replaced by quickshell II).
- **II sidebars, overlay, cheatsheet, dock, media controls, OSD, OSK, wallpaper selector, polkit, region selector, screen corners** — unloaded from Quickshell.
- **Omarchy battery monitor** — removed (Quickshell bar handles battery).
- **ydotool service** — removed (clipboard via wl-clipboard).
- **Wallpapers service, FirstRunExperience, ConflictKiller, Updates** — removed from shell.qml init.
- **Stale scripts**: `emoji-picker`, `keybinds-hint`, `calculator`, `oh-my-posh`, `rhp-swayosd-brightness` — removed.
- **Unused Aether templates**: waybar, wofi, mako, swayosd, kitty, ghostty, warp, vencord, walker — removed.

## Note

- **`plugin.zsh` (Zinit) disabled** via `return 1` at line 3; active system is oh-my-zsh sourced from `.zshenv`.
- **`illogical-impulse/` is gitignored** — runtime config generated by II settings UI.
- **`hl` API** is Hyprland's Lua DSL (`hl.bind`, `hl.config`, `hl.exec_cmd`, `hl.dsp.*`, etc.) — not a custom library.
- **No CI, tests, lint, or typecheck** — no verification commands exist.
