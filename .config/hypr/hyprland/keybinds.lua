require("hyprland.lib")
require("hyprland.variables")
-- if is_file_exists(HOME .. "/.config/hypr/custom/variables.lua") then
-- 	require("custom.variables")
-- end

-- local qsScripts = "$HOME/.config/quickshell/$qsConfig/scripts"
-- local hyprScripts = "$HOME/.config/hypr/hyprland/scripts"
-- local qsIpcCall = "qs -c " .. qsConfig .. " ipc call"
-- local qsIsAlive = qsIpcCall .. " TEST_ALIVE"

-- # _____________________________
-- # Shell
-- # _____________________________

-- # _____________________________
-- # Applications
-- # _____________________________

hl.bind("SUPER + Return", hl.dsp.exec_cmd(terminal), { description = "Open terminal" })
hl.bind("SUPER + SHIFT + F", hl.dsp.exec_cmd(fileManager), { description = "Open file manager" })
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd(menu), { description = "Open launcher" })
hl.bind("SUPER + Escape", hl.dsp.exec_cmd("wlogout"), { description = "Power Menu" })

-- # _____________________________
-- # Apps
-- # _____________________________

hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd(browser), { description = "Open browser" })
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd(terminal .. " -e " .. editor), { description = "Open editor" })
hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd("spotify-launcher"), { description = "Open Spotify" })
hl.bind("SUPER + SHIFT + O", hl.dsp.exec_cmd("obsidian"), { description = "Open Obsidian" })
hl.bind("SUPER + CTRL + T", hl.dsp.exec_cmd(terminal .. " -e btop"), { description = "Open btop++" })
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("rofi -show ssh"), { description = "SSH Configs" })
hl.bind("SUPER + SHIFT + Z", hl.dsp.exec_cmd("zoom"), { description = "Open Zoom" })
hl.bind("SUPER + SHIFT + D", hl.dsp.exec_cmd(terminal .. " -e lazydocker"), { description = "Open lazydocker" })

-- # _____________________________
-- # Window Management
-- # _____________________________

hl.bind("SUPER + W", hl.dsp.window.close(), { description = "Close focused window" })
hl.bind("ALT + F4", hl.dsp.window.close(), { description = "Close focused window" })
hl.bind("SUPER + T", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle floating" })
hl.bind("SUPER + G", hl.dsp.group.toggle(), { description = "Toggle group" })
hl.bind(
	"SUPER + F",
	hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }),
	{ description = "Toggle fullscreen" }
)
-- hl.bind("SUPER + SHIFT + T", hl.dsp.exec_cmd("hyde-shell window.pin"), { description = "Toggle pin on focused window" })

-- Focus
hl.bind("SUPER + left", hl.dsp.focus({ direction = "l" }), { description = "Focus left" })
hl.bind("SUPER + right", hl.dsp.focus({ direction = "r" }), { description = "Focus right" })
hl.bind("SUPER + up", hl.dsp.focus({ direction = "u" }), { description = "Focus up" })
hl.bind("SUPER + down", hl.dsp.focus({ direction = "d" }), { description = "Focus down" })

-- Move
hl.bind("SUPER + SHIFT + left", hl.dsp.window.move({ direction = "l" }), { description = "Move window left" })
hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "r" }), { description = "Move window right" })
hl.bind("SUPER + SHIFT + up", hl.dsp.window.move({ direction = "u" }), { description = "Move window up" })
hl.bind("SUPER + SHIFT + down", hl.dsp.window.move({ direction = "d" }), { description = "Move window down" })

-- Resize
hl.bind(
	"SUPER + equal",
	hl.dsp.window.resize({ x = 0, y = 30, relative = true }),
	{ repeating = true },
	{ description = "Resize window taller" }
)
hl.bind(
	"SUPER + minus",
	hl.dsp.window.resize({ x = 0, y = -30, relative = true }),
	{ repeating = true },
	{ description = "Resize window shorter" }
)
hl.bind(
	"SUPER + SHIFT + equal",
	hl.dsp.window.resize({ x = 30, y = 0, relative = true }),
	{ repeating = true },
	{ description = "Resize window wider" }
)
hl.bind(
	"SUPER + SHIFT + minus",
	hl.dsp.window.resize({ x = -30, y = 0, relative = true }),
	{ repeating = true },
	{ description = "Resize window narrower" }
)

-- # _____________________________
-- # Workspaces
-- # _____________________________

for i = 1, 10 do
	local key = i % 10
	hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }), { description = "Switch to workspace " .. i })
	hl.bind(
		"SUPER + SHIFT + " .. key,
		hl.dsp.window.move({ workspace = i }),
		{ description = "Move window to workspace " .. i }
	)
end

hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { description = "Next empty workspace" })
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { description = "Previous empty workspace" })
hl.bind("SUPER + TAB", hl.dsp.exec_cmd("rofi -show window"), { description = "Window switcher" })
hl.bind("ALT + TAB", hl.dsp.focus({ last = true }), { description = "Previous workspace" })

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

-- # _____________________________
-- # System
-- # _____________________________

hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprlock"), { description = "Lock screen" })

-- # _____________________________
-- # Function Keys
-- # _____________________________

-- Audio
hl.bind("F5", hl.dsp.exec_cmd("hyde-volume -o m"), { repeating = false }, { description = "Toggle mute" })
hl.bind("F6", hl.dsp.exec_cmd("hyde-volume -o d 5"), { repeating = true }, { description = "Volume down" })
hl.bind("F7", hl.dsp.exec_cmd("hyde-volume -o i 5"), { repeating = true }, { description = "Volume up" })

-- Brightness
hl.bind("F2", hl.dsp.exec_cmd("hyde-brightness d 5"), { repeating = true }, { description = "Brightness down" })
hl.bind("F3", hl.dsp.exec_cmd("hyde-brightness i 5"), { repeating = true }, { description = "Brightness up" })

-- Media
hl.bind("F9", hl.dsp.exec_cmd("playerctl previous"), { description = "Previous track" })
hl.bind("F10", hl.dsp.exec_cmd("playerctl play-pause"), { description = "Play/Pause" })
hl.bind("F11", hl.dsp.exec_cmd("playerctl next"), { description = "Next track" })

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd("omarchy-capture-screenshot fullscreen save"), { description = "Full screenshot" })
hl.bind("SUPER + Print", hl.dsp.exec_cmd("omarchy-capture-screenshot smart"), { description = "Smart screenshot" })
hl.bind(
	"SUPER + ALT + Print",
	hl.dsp.exec_cmd("omarchy-capture-screenshot region"),
	{ description = "Region screenshot" }
)
hl.bind(
	"SUPER + SHIFT + R",
	hl.dsp.exec_cmd("omarchy-capture-screenrecording"),
	{ description = "Start screen recording" }
)
hl.bind(
	"SUPER + ALT + R",
	hl.dsp.exec_cmd("omarchy-capture-screenrecording --stop-recording"),
	{ description = "Stop screen recording" }
)
-- # _____________________________
-- # Utility Scripts
-- # _____________________________

hl.bind("SUPER + PERIOD", hl.dsp.exec_cmd("emoji-picker"), { description = "Emoji picker" })
hl.bind("SUPER + ALT + C", hl.dsp.exec_cmd("calculator"), { description = "Calculator" })
hl.bind("SUPER + CTRL + N", hl.dsp.exec_cmd("hyprsunset -t"), { description = "Toggle night mode" })
hl.bind("SUPER + SLASH", hl.dsp.exec_cmd("keybinds-hint"), { description = "Show keybinds" })
