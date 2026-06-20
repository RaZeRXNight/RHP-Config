# RHP-Config

Arch Linux / Hyprland (Wayland) personal dotfiles.

## Non-obvious facts

- **Hyprland config is Lua**, not `hyprland.conf`. Entry: `.config/hypr/hyprland.lua` which `require()`s modules from `hyprland/`. Edit `keybinds.lua`, `colors.lua`, `general.lua`, etc.
- **App defaults** (terminal, browser, editor, menu) → `.config/hypr/hyprland/variables.lua`.
- **Theme integration** flows through `execs.lua` (line 6 does `dofile(".../RHPTheme/Theme/hyprland.conf")` — sets border colors). `aether.lua` has the same code **commented out**; edit `execs.lua`, not `aether.lua`.
- **Lock screen config lives in `.config/hyprlock/`**. `.config/hypr/hyprlock.conf` is a 4-line stub that sources paths under `.config/hyprlock/`.
- **ZDOTDIR = `~/.config/zsh/`**. The installer writes `export ZDOTDIR="$HOME/.config/zsh"` to `~/.zshenv`. Inside ZDOTDIR, `.zshenv` sources `conf.d/*.zsh` first, then loads `oh-my-zsh`. Local overrides go in `user.zsh`.
- **Setup**: run `setup/install.sh`. It backs up existing configs, symlinks `.config/` and `.local/bin/`, installs Arch packages from `setup/packages.required` (and prompts for `setup/packages.optional`), configures ZDOTDIR, oh-my-zsh, and systemd user services.
- **Script naming**: `rhp-*` = custom utilities, `aether-*` = theme integration.

## Quickshell (end-4 illogical-impulse)

- **Shell**: `quickshell -c ii` — entrypoint is `.config/quickshell/ii/shell.qml`. Autostarted from `execs.lua`.
- **Bar/panels/overlays**: All rendered by QML (`ii/` family), not Waybar. Waybar config is kept as a fallback only.
- **Launcher**: `SUPER + SPACE` → `qs -c ii msg search toggle`. Rofi config/theme is kept as a fallback only.
- **Keybind hint overlay**: `SUPER + SLASH` → `qs -c ii msg cheatsheet toggle` (was `keybinds-hint` rofi script).
- **Emoji picker**: `SUPER + PERIOD` → `qs -c ii msg search emojiToggle` (was `emoji-picker` rofi script).
- **Power menu**: `SUPER + Escape` → `qs -c ii msg session toggle` (was `wlogout`).

## Quickshell IPC keybinds

All registered in `hypr/hyprland/keybinds.lua`. Trigger via `qs -c ii msg <target> <function>`.

| Binding | IPC Command | Function |
|---|---|---|
| `SUPER + SPACE` | `search toggle` | Open launcher/overview |
| `SUPER + Escape` | `session toggle` | Power menu / session screen |
| `SUPER + TAB` | `search workspacesToggle` | Workspace overview |
| `SUPER + L` | `lock activate` | Lock screen |
| `SUPER + V` | `search clipboardToggle` | Clipboard in overview |
| `SUPER + I` | `sidebarRight toggle` | Toggle right sidebar |
| `SUPER + B` | `sidebarLeft toggle` | Toggle left sidebar |
| `SUPER + O` | `overlay toggle` | Toggle overlay |
| `SUPER + CTRL + B` | `bar toggle` | Toggle bar visibility |
| `SUPER + CTRL + M` | `mediaControls toggle` | Toggle media controls |
| `SUPER + CTRL + W` | `wallpaperSelector toggle` | Toggle wallpaper picker |
| `SUPER + CTRL + D` | `theme toggleLightDark` | Toggle dark/light mode |
| `SUPER + CTRL + K` | `osk toggle` | Toggle on-screen keyboard |
| `SUPER + CTRL + Print` | `region ocr` | OCR screen region |
| `SUPER + ALT + Print` | `region screenshot` | Region screenshot |
| `SUPER + SHIFT + R` | `region record` | Start screen recording |
| `SUPER + PERIOD` | `search emojiToggle` | Emoji picker |
| `SUPER + SLASH` | `cheatsheet toggle` | Show keybinds cheatsheet |
| `F2` | `brightness decrement` | Brightness down |
| `F3` | `brightness increment` | Brightness up |

Fine-step brightness (`SHIFT + F2/F3`) still uses `rhp-brightness` script since IPC doesn't support step params. Stop recording (`SUPER + ALT + R`) uses `rhp-capture-screenrecording --stop-recording`.

## Theme bridge: Aether → Quickshell

- **Aether custom template**: `.config/aether/custom/quickshell/` — `config.json` describes template, `colors.json` defines palette placeholders, `post-apply.sh` converts palette to M3 JSON.
- **Generated output**: `.config/quickshell/ii/theme/AetherTheme.json` — Material3 colors computed from Aether palette. Symlink at `.config/quickshell/ii/theme/colors.json` → `.config/aether/theme/quickshell-colors.json` for legacy compat.
- **Live reload**: `MaterialThemeLoader.qml` watches `AetherTheme.json` with `FileView.watchChanges` (100ms debounce). On change, parses JSON and assigns each key to `Appearance.m3colors` (converts `snake_case` → `m3camelCase`). Auto-detects dark mode from background lightness.
- **IPC for theme**: `qs -c ii msg theme toggleLightDark` toggles dark/light from Hyprland keybinds.
- **AetherTheme.json is gitignored** — regenerated on every `aether apply`.

## `.local/bin/` scripts

- `rhp-*` = custom utilities, `aether-*` = theme integration.
- Several scripts now delegate to quickshell IPC when `qs` is available:
  - `emoji-picker` → `qs -c ii msg search emojiToggle`
  - `keybinds-hint` → `qs -c ii msg cheatsheet toggle`
  - `rhp-capture-screenshot region` → `qs -c ii msg region screenshot`
  - `rhp-capture-screenrecording` (no args) → `qs -c ii msg region record`
  - `rhp-brightness` kept for fine-step fallback (`SHIFT + F2/F3`)
- **Wallpaper**: set via `aether-wallpaper`. Quickshell's `Wallpapers.qml` service manages wallpaper display; `execs.lua` starts `swaybg` independently for DMENU fallback.

## Stale / symlink-contaminated files

- `.config/btop/` — **heavily contaminated**. The entire directory is polluted with unrelated configs (`.zshenv`, `hyprland.lua`, `hyprlock.conf`, etc.) — treat everything in there as suspect.
- **`plugin.zsh` (Zinit) disabled** via `return 1` at line 3; active system is oh-my-zsh sourced from `.zshenv`.
- **Extensibility**: uncomment `require("custom.*")` calls in `hyprland.lua`; overrides live in `.config/hypr/custom/`.
- **Waybar config** kept as a fallback (`.config/waybar/config.jsonc`). Not auto-started.
- **`hl` API** is Hyprland's Lua DSL (`hl.bind`, `hl.config`, `hl.exec_cmd`, `hl.dsp.*`, etc.) — not a custom library. See `hyprland/` modules for usage examples.
- **No CI, tests, lint, or typecheck** — no verification commands exist.