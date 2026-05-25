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

The `setup.sh` script should handle deployment. Suggested approach:

1. Back up existing `~/.config/` dirs and `~/.local/bin` that would be replaced
2. Symlink each directory under `.config/` into `~/.config/`
3. Symlink `.local/bin/` to `~/.local/bin/`
4. Install Arch packages with `sudo pacman -S --needed`

### Manual steps after setup

- ZDOTDIR: ensure `export ZDOTDIR="$HOME/.config/zsh"` is set (via `/etc/zsh/zshenv` or `~/.zshenv`)
- `~/.gitconfig` — copy or create manually
- Install oh-my-zsh if not already present: `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
- Set wallpaper: run `~/.local/bin/aether-wallpaper` to pick an initial wallpaper (needed for hyprlock)

## Credits

- [dots-hyprland](https://github.com/sh1zicus/dots-hyprland) — base Lua config structure
- [Omarchy](https://github.com/basecamp/omarchy) — utility scripts
- [HyDE-Project](https://github.com/HyDE-Project/HyDE) — utility concepts
- [Aether/RHPTheme](https://github.com/rubiin/aether) — theming engine

## License

MIT
