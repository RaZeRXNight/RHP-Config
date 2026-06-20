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
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("qs -c ii msg search toggle"), { description = "Open launcher/overview" })
hl.bind("SUPER + Escape", hl.dsp.exec_cmd("qs -c ii msg session toggle"), { description = "Power Menu / session" })

-- # _____________________________
-- # Apps
-- # _____________________________

hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd(browser), { description = "Open browser" })
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd(terminal .. " -e " .. editor), { description = "Open editor" })
hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd("spotify-launcher"), { description = "Open Spotify" })
hl.bind("SUPER + SHIFT + O", hl.dsp.exec_cmd("obsidian"), { description = "Open Obsidian" })
-- Old: omarchy-launch-floating-terminal btop
hl.bind("SUPER + CTRL + T", hl.dsp.exec_cmd("rhp-launch-floating-terminal btop"), { description = "Open btop++" })
hl.bind("SUPER + SHIFT + Z", hl.dsp.exec_cmd("zoom"), { description = "Open Zoom" })
hl.bind(
	"SUPER + SHIFT + D",
	-- Old: omarchy-launch-floating-terminal lazydocker
	hl.dsp.exec_cmd("rhp-launch-floating-terminal lazydocker"),
	{ description = "Open lazydocker" }
)

--
-- Web Apps
--

hl.bind(
	"SUPER + SHIFT + A",
	-- Old: omarchy-launch-webapp https://chatgpt.com/
	hl.dsp.exec_cmd("rhp-launch-webapp https://chatgpt.com/"),
	{ description = "Open Chatgpt" }
)
hl.bind(
	"SUPER + SHIFT + ALT + A",
	-- Old: omarchy-launch-webapp https://chatgpt.com/
	hl.dsp.exec_cmd("rhp-launch-webapp https://gemini.google.com/"),
	{ description = "Open Chatgpt" }
)
hl.bind(
	"SUPER + SHIFT + S",
	hl.dsp.exec_cmd("rhp-launch-webapp https://aistudio.google.com"),
	{ description = "Google Studio" }
)
hl.bind(
	"SUPER + SHIFT + W",
	hl.dsp.exec_cmd("rhp-launch-webapp https://docs.google.com"),
	{ description = "Google Docs" }
)
hl.bind(
	"SUPER + SHIFT + G",
	-- Old: omarchy-launch-webapp https://web.whatsapp.com/
	hl.dsp.exec_cmd("rhp-launch-webapp https://web.whatsapp.com/"),
	{ description = "Open whatsapp" }
)
-- Old: omarchy-webapp-handler-zoom
hl.bind("SUPER + SHIFT + Z", hl.dsp.exec_cmd("rhp-webapp-handler-zoom"), { description = "Open Zoom" })
hl.bind(
	"SUPER + SHIFT + C",
	-- Old: omarchy-launch-webapp https://calendar.google.com/calendar/u/0/r
	hl.dsp.exec_cmd("rhp-launch-webapp https://calendar.google.com/calendar/u/0/r"),
	{ description = "Open google calendar" }
)
hl.bind(
	"SUPER + SHIFT + E",
	-- Old: omarchy-launch-webapp https://mail.google.com/mail/u/0/
	hl.dsp.exec_cmd("rhp-launch-webapp https://mail.google.com/mail/u/0/"),
	{ description = "Open gmail" }
)

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
hl.bind("SUPER + TAB", hl.dsp.exec_cmd("qs -c ii msg search workspacesToggle"), { description = "Workspace overview" })
hl.bind("ALT + TAB", hl.dsp.focus({ last = true }), { description = "Previous workspace" })

-- # _____________________________
-- # System
-- # _____________________________

hl.bind("SUPER + L", hl.dsp.exec_cmd("qs -c ii msg lock activate"), { description = "Lock screen" })

-- # _____________________________
-- # Function Keys
-- # _____________________________

-- Audio
hl.bind("F8", hl.dsp.exec_cmd("rhp-volume -i m"), { repeating = false }, { description = "Toggle mic mute" })
hl.bind("F5", hl.dsp.exec_cmd("rhp-volume -o m"), { repeating = false }, { description = "Toggle mute" })
hl.bind("F6", hl.dsp.exec_cmd("rhp-volume -o d 5"), { repeating = true }, { description = "Volume down" })
hl.bind("F7", hl.dsp.exec_cmd("rhp-volume -o i 5"), { repeating = true }, { description = "Volume up" })
hl.bind(
	"SHIFT + F6",
	hl.dsp.exec_cmd("rhp-volume -o d 1"),
	{ repeating = true },
	{ description = "Volume down slightly" }
)
hl.bind(
	"SHIFT + F7",
	hl.dsp.exec_cmd("rhp-volume -o i 1"),
	{ repeating = true },
	{ description = "Volume up slightly" }
)

-- Brightness
hl.bind(
	"F2",
	hl.dsp.exec_cmd("qs -c ii msg brightness decrement"),
	{ repeating = true },
	{ description = "Brightness down" }
)
hl.bind(
	"F3",
	hl.dsp.exec_cmd("qs -c ii msg brightness increment"),
	{ repeating = true },
	{ description = "Brightness up" }
)
hl.bind(
	"SHIFT + F2",
	-- Old: rhp-brightness d 1 (fine step, routed through script since IPC doesn't support step param)
	hl.dsp.exec_cmd("rhp-brightness d 1"),
	{ repeating = true },
	{ description = "Brightness down slightly" }
)
hl.bind(
	"SHIFT + F3",
	-- Old: rhp-brightness i 1 (fine step)
	hl.dsp.exec_cmd("rhp-brightness i 1"),
	{ repeating = true },
	{ description = "Brightness up slightly" }
)

-- Media
hl.bind("F9", hl.dsp.exec_cmd("playerctl previous"), { description = "Previous track" })
hl.bind("F10", hl.dsp.exec_cmd("playerctl play-pause"), { description = "Play/Pause" })
hl.bind("F11", hl.dsp.exec_cmd("playerctl next"), { description = "Next track" })

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd("rhp-capture-screenshot fullscreen save"), { description = "Full screenshot" })
hl.bind("SUPER + Print", hl.dsp.exec_cmd("rhp-capture-screenshot smart"), { description = "Smart screenshot" })
hl.bind("SUPER + ALT + Print", hl.dsp.exec_cmd("qs -c ii msg region screenshot"), { description = "Region screenshot" })
hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("qs -c ii msg region record"), { description = "Start screen recording" })
hl.bind(
	"SUPER + ALT + R",
	hl.dsp.exec_cmd("rhp-capture-screenrecording --stop-recording"),
	{ description = "Stop screen recording" }
)
-- # _____________________________
-- # Utility Scripts
-- # _____________________________

hl.bind("SUPER + PERIOD", hl.dsp.exec_cmd("qs -c ii msg search emojiToggle"), { description = "Emoji picker" })
hl.bind("SUPER + CTRL + N", hl.dsp.exec_cmd("hyprsunset -t"), { description = "Toggle night mode" })
hl.bind("SUPER + SLASH", hl.dsp.exec_cmd("qs -c ii msg cheatsheet toggle"), { description = "Show keybinds" })

-- # _____________________________
-- # end-4 illogical-impulse shell IPC shortcuts
-- # Trigger via: qs -c ii msg <target> <function>
-- # Registered by QML shell widgets; bound here via Hyprland for consistency.
-- # _____________________________
-- Already bound above:
--   searchToggle           → SUPER + SPACE
--   overviewWorkspacesToggle → SUPER + TAB
--   overviewEmojiToggle    → SUPER + PERIOD
--   cheatsheetToggle       → SUPER + SLASH
--   regionScreenshot       → SUPER + ALT + Print
--   regionRecord           → SUPER + SHIFT + R
--   lock                   → SUPER + L
--   brightnessIncrease     → F3
--   brightnessDecrease     → F2
--   sessionToggle          → SUPER + Escape

hl.bind("SUPER + V", hl.dsp.exec_cmd("qs -c ii msg search clipboardToggle"), { description = "Clipboard in overview" })
hl.bind("SUPER + I", hl.dsp.exec_cmd("qs -c ii msg sidebarRight toggle"), { description = "Toggle right sidebar" })
hl.bind("SUPER + B", hl.dsp.exec_cmd("qs -c ii msg sidebarLeft toggle"), { description = "Toggle left sidebar" })
hl.bind("SUPER + O", hl.dsp.exec_cmd("qs -c ii msg overlay toggle"), { description = "Toggle overlay" })
hl.bind("SUPER + CTRL + B", hl.dsp.exec_cmd("qs -c ii msg bar toggle"), { description = "Toggle bar visibility" })
hl.bind(
	"SUPER + CTRL + M",
	hl.dsp.exec_cmd("qs -c ii msg mediaControls toggle"),
	{ description = "Toggle media controls" }
)
hl.bind("SUPER + CTRL + Print", hl.dsp.exec_cmd("qs -c ii msg region ocr"), { description = "OCR region" })
hl.bind(
	"SUPER + CTRL + W",
	hl.dsp.exec_cmd("qs -c ii msg wallpaperSelector toggle"),
	{ description = "Toggle wallpaper picker" }
)
hl.bind(
	"SUPER + CTRL + D",
	hl.dsp.exec_cmd("qs -c ii msg theme toggleLightDark"),
	{ description = "Toggle dark/light mode" }
)
hl.bind("SUPER + CTRL + K", hl.dsp.exec_cmd("qs -c ii msg osk toggle"), { description = "Toggle on-screen keyboard" })
-- Unbound: osdTrigger, screenTranslate, regionSearch, regionRecordWithSound