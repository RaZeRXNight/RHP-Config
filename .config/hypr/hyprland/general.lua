-- General Hyprland settings
hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 20,
		layout = "dwindle",
	},
})

-- Monitor configuration
-- Get monitor names with: hyprctl monitors
--
-- Simple string format:
-- hl.monitor("eDP-1, 1920x1080@60, 0x0, 1")
-- hl.monitor("DP-1, 2560x1440@144, 1920x0, 1.25")
-- hl.monitor("HDMI-A-1, 3840x2160@60, 4480x0, 2")
--
-- Table format:
hl.monitor({
	output = "eDP-1",
	-- mode = "1920x1080",
	mode = "preferred",
	position = "0x0",
	scale = 1,
	vrr = 0,
})
--
-- Disable a monitor:
-- hl.monitor("DP-1, disable")
