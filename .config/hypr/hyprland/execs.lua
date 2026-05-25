-- Autostart applications
-- These run once on Hyprland startup.
-- hl.on("hyprland.start", function()
-- 	hl.exec_cmd("waybar")
-- end)
dofile(os.getenv("HOME") .. "/.config/RHPTheme/Theme/hyprland.conf")

hl.on("hyprland.start", function()
	hl.exec_cmd("swaybg -i $(" .. os.getenv("HOME") .. "/.local/bin/aether-wallpaper) -m fill")
end)
