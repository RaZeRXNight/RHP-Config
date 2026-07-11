-- Autostart applications
-- These run once on Hyprland startup.
-- hl.on("hyprland.start", function()
-- 	hl.exec_cmd("waybar")
-- end)
dofile(os.getenv("HOME") .. "/.config/RHPTheme/Theme/hyprland.conf")

hl.on("hyprland.start", function()
	hl.exec_cmd("quickshell -c ii")
	hl.exec_cmd(os.getenv("HOME") .. "/.local/bin/rhp-wallpaper")
	hl.exec_cmd("if command -v chromium >/dev/null && [ -f \"$HOME/.config/chromium/Default/Preferences\" ]; then " .. os.getenv("HOME") .. "/.local/bin/aether-chromium-theme; fi")
end)
