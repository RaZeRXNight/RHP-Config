# RHP-Config

My personal Hyprland dotfiles — Arch Linux, Hyprland (Wayland), zsh, Aether theming.

These configs were created by mashing up multiple dotfiles such as Omarchy, HyDE, and dots-hyprland, then stripped down to what I actually use.

## Directory Structure

```
~/.RHP-Config/
├── .config/
│   ├── hypr/               # Modular Lua-driven Hyprland config
│   │   ├── hyprland.lua    # Entry point (sources modules)
│   │   └── hyprland/       # keybinds, execs, general, rules, colors, services, variables, lib
│   ├── hyprlock/           # Lock screen config + scripts
│   ├── waybar/             # Status bar (config.jsonc + style.css)
│   ├── rofi/               # Application launcher
│   ├── wlogout/            # Power/logout menu
│   ├── RHPTheme/           # Theme engine (borders, waybar scripts)
│   ├── aether/             # Wallpapers + theme CSS
│   ├── zsh/                # Shell config (aliases, path, prompt, functions)
│   ├── alacritty/          # Terminal
│   ├── nvim/               # Editor
│   ├── btop/               # System monitor
│   ├── systemd/            # User services (waybar, polkit, etc.)
│   ├── gtk-3.0/            # GTK theme settings
│   ├── starship.toml       # Prompt theme
│   └── QtProject.conf      # Qt theme settings
└── .local/
    └── bin/                # Utility scripts (volume, brightness, screenshots, etc.)
```

## Keybindings

| Key                | Action                                     |
| ------------------ | ------------------------------------------ |
| `SUPER + Return`   | Terminal                                   |
| `SUPER + Space`    | Launcher (rofi)                            |
| `SUPER + W`        | Close window                               |
| `SUPER + Print`    | Smart screenshot                           |
| `SUPER + L`        | Lock screen                                |
| `SUPER + .`        | Emoji picker                               |
| `SUPER + ALT + C`  | Calculator                                 |
| `SUPER + CTRL + N` | Toggle night mode (hyprsunset)             |
| `SUPER + /`        | Keybind hints                              |
| `F2` / `F3`        | Brightness down/up (progress notification) |
| `F5`               | Toggle mute (progress notification)        |
| `F6` / `F7`        | Volume down/up (progress notification)     |

## Dependencies

### Packages (Arch Linux)

- `hyprland waybar rofi wlogout hyprlock grim slurp wl-clipboard jq`
- `cliphist brightnessctl pamixer playerctl wf-recorder hyprsunset`
- `swaybg swayosd networkmanager blueman pavucontrol dunst hypridle`
- `alacritty neovim btop starship oh-my-zsh fzf lsd fastfetch curl imagemagick`

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

- [dots-hyprland](https://github.com/sh1zicus/dots-hyprland) — base Lua config structure
- [Omarchy](https://github.com/basecamp/omarchy) — utility scripts
- [HyDE-Project](https://github.com/HyDE-Project/HyDE) — utility concepts
- [Aether/RHPTheme](https://github.com/rubiin/aether) — theming engine

## License

MIT
