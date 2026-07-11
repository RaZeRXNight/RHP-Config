# RHP-Config

Minimal Hyprland dotfiles — Arch Linux, Hyprland (Wayland), zsh, Aether theming.

Designed for lightweight operation: Hyprland compositor, end-4 quickshell bar, Aether theme injection.

## Active components

- **Hyprland** — Wayland compositor (Lua config, modular)
- **Quickshell II** — bar + launcher + workspace overview + lock screen + session screen
- **Aether** — color palette generation injected into Quickshell, Hyprland, Neovim, VS Code, Zed
- **awww** — animated wallpaper daemon
- **PipeWire / WirePlumber** — audio
- **NetworkManager** — networking

## Directory Structure

```
~/.RHP-Config/
├── .config/
│   ├── hypr/               # Modular Lua-driven Hyprland config
│   ├── hyprlock/           # Lock screen config + layouts
│   ├── quickshell/         # Quickshell II with MinimalFamily
│   ├── aether/             # Theme engine + color templates
│   ├── RHPTheme/           # External theme provider (hyprland + alacritty colors)
│   ├── zsh/                # Shell config
│   ├── alacritty/          # Terminal
│   ├── nvim/               # Neovim (LazyVim)
│   ├── btop/               # System monitor
│   └── starship.toml       # Prompt theme
└── .local/
    └── bin/                # Utility scripts (volume, brightness, screenshots, etc.)
```

## Keybindings

| Key | Action |
|---|---|
| `SUPER + Return` | Terminal |
| `SUPER + Space` | Launcher / overview |
| `SUPER + TAB` | Workspace overview |
| `SUPER + Escape` | Session / power menu |
| `SUPER + L` | Lock screen |
| `SUPER + V` | Clipboard in overview |
| `SUPER + .` | Emoji picker |
| `SUPER + W` | Close window |
| `SUPER + CTRL + N` | Toggle night mode (hyprsunset) |
| `SUPER + CTRL + B` | Toggle bar visibility |
| `SUPER + CTRL + D` | Toggle dark/light mode |
| `F2` / `F3` | Brightness down/up |
| `F5` | Toggle mute |
| `F6` / `F7` | Volume down/up |
| `F8` | Toggle mic mute |
| `F9`-`F11` | Media control |
| `Print` | Full screenshot |
| `SUPER + Print` | Smart screenshot |
| `SUPER + ALT + Print` | Region screenshot |
| `SUPER + SHIFT + R` | Start screen recording |

## Dependencies

### Packages (Arch Linux)

- `hyprland hyprlock hypridle hyprpolkitagent hyprsunset`
- `illogical-impulse-quickshell-git`
- `alacritty zsh starship fzf neovim`
- `grim slurp wl-clipboard cliphist`
- `brightnessctl pamixer playerctl`
- `awww hyprpicker`
- `swaync`
- `pipewire pipewire-pulse wireplumber`
- `networkmanager blueman`
- `pavucontrol qt6ct`
- `jq curl python xdg-user-dirs xdg-utils`
- `firefox nautilus btop`
- `ffmpeg mpv`
- `illogical-impulse-backlight`
- `aether`

### Scripts

All in `~/.local/bin/` — symlinked into this repo.

## Setup

Run the interactive installer:

```bash
cd ~/.RHP-Config
./setup/install.sh
```

The installer walks through:
1. Environment checks (Arch, sudo, git)
2. Package installation (official repos + AUR via yay/paru)
3. Backup of existing configs (timestamped)
4. Symlink deployment from repo → `~/.config/` and `~/.local/bin/`
5. Post-install: ZDOTDIR, oh-my-zsh, gitconfig, systemd services

### Manual steps after setup

- Set Zsh as default shell: `chsh -s /bin/zsh`
- Set wallpaper: `~/.local/bin/aether-wallpaper`

## Credits

- [end-4/illogical-impulse](https://github.com/end-4/illogical-impulse) — Quickshell shell
- [dots-hyprland](https://github.com/sh1zicus/dots-hyprland) — base Lua config structure
- [Omarchy](https://github.com/basecamp/omarchy) — utility script inspiration
- [Aether](https://github.com/rubiin/aether) — theming engine

## License

MIT
