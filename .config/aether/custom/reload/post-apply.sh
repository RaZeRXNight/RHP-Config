#!/bin/bash
WALLPAPER=$(~/.local/bin/aether-wallpaper)

# LEGACY: waybar no longer used — quickshell/ii handles the bar
# killall waybar 2>/dev/null
# waybar &

if [ -n "$WALLPAPER" ]; then
    awww img "$WALLPAPER"
    ln -sf "$WALLPAPER" ~/.config/aether/theme/backgrounds/current
fi

~/.local/bin/aether-chromium-theme
