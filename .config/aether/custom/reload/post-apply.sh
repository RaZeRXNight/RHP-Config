#!/bin/bash
WALLPAPER=$(~/.local/bin/aether-wallpaper)

killall waybar 2>/dev/null
waybar &

if [ -n "$WALLPAPER" ]; then
    killall swaybg 2>/dev/null
    swaybg -i "$WALLPAPER" -m fill &
    ln -sf "$WALLPAPER" ~/.config/aether/theme/backgrounds/current
fi

~/.local/bin/aether-chromium-theme
