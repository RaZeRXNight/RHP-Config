# RHP-Config

Arch Linux / Hyprland (Wayland) personal dotfiles.

## Non-obvious facts

- **Hyprland config is Lua**, not `hyprland.conf`. Entry: `.config/hypr/hyprland.lua` which `require()`s modules from `hyprland/`. Edit `keybinds.lua`, `colors.lua`, `general.lua`, etc.
- **App defaults** (terminal, browser, editor, menu) → `.config/hypr/hyprland/variables.lua`.
- **Theme integration** flows through `execs.lua` (line 6 does `dofile(".../RHPTheme/Theme/hyprland.conf")` — sets border colors). `aether.lua` has the same code **commented out**; edit `execs.lua`, not `aether.lua`.
- **Lock screen config lives in `.config/hyprlock/`**. `.config/hypr/hyprlock.conf` is a 4-line stub that sources paths under `.config/hyprlock/`.
- **ZDOTDIR = `~/.config/zsh/`**. The installer writes `export ZDOTDIR="$HOME/.config/zsh"` to `~/.zshenv`. Inside ZDOTDIR, `.zshenv` sources `conf.d/*.zsh` first, then loads `oh-my-zsh`. Local overrides go in `user.zsh`.
- **Setup**: run `setup/install.sh`. It backs up existing configs, symlinks `.config/` and `.local/bin/`, installs Arch packages from `setup/packages.required` (and prompts for `setup/packages.optional`), configures ZDOTDIR, oh-my-zsh, and systemd user services.
- **`.gitignore` is empty** — everything tracked.
- **Script naming**: `rhp-*` = custom utilities, `aether-*` = theme integration.
- **Aether theme** at `.config/RHPTheme/Theme/`. Alacritty imports `Theme/alacritty.toml`. Waybar, rofi, hyprlock all reference `Theme/` paths for colors.
- **Wallpaper**: set via `~/.local/bin/aether-wallpaper`. `execs.lua` runs it on Hyprland start.
- **Stale / symlink-contaminated files**:
  - `.config/btop/` — **heavily contaminated**. The entire directory is polluted with unrelated configs (`.zshenv`, `hyprland.lua`, `hyprlock.conf`, etc.) — treat everything in there as suspect.
  - `.config/hypr/backup.conf` — broken quickshell-era Lua, unused.
- **`plugin.zsh` (Zinit) disabled** via `return 1` at line 3; active system is oh-my-zsh sourced from `.zshenv`.
- **`keybinds-hint`** script parses `keybinds.lua` descriptions at runtime — add/rename binds and the hint UI stays in sync.
- **Extensibility**: uncomment `require("custom.*")` calls in `hyprland.lua`; overrides live in `.config/hypr/custom/`.
- **Waybar `config.jsonc` uses `jsonc`** (trailing commas are valid). File is at `.config/waybar/config.jsonc` with companion scripts in `scripts/`.
- **`hl` API** is Hyprland's Lua DSL (`hl.bind`, `hl.config`, `hl.exec_cmd`, `hl.dsp.*`, etc.) — not a custom library. See `hyprland/` modules for usage examples.
- **No CI, tests, lint, or typecheck** — no verification commands exist.
