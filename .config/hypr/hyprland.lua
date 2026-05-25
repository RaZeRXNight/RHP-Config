--  This config is a STUB! This should never be generated.
--  Use the default lua config from https://github.com/hyprwm/Hyprland/blob/main/example/hyprland.lua

-- $mainMod = SUPER
-- $terminal = alacritty
-- $fileManager = nautilus
-- $menu = hyprlauncher

-- This file sources other files in `hyprland` and `custom` folders
-- You wanna add your stuff in files in `custom`

-- Internal stuff --
require("hyprland.lib")
require("hyprland.services")

-- -- Environment variables --
-- require("hyprland.env")
-- if is_file_exists(HOME .. "/.config/hypr/custom/env.lua") then
-- 	require("custom.env")
-- end

-- Default configurations --
require("hyprland.execs")
require("hyprland.general")
require("hyprland.rules")
require("hyprland.colors")
require("hyprland.keybinds")

-- -- Custom configurations --
-- if is_file_exists(HOME .. "/.config/hypr/custom/execs.lua") then
-- 	require("custom.execs")
-- end
-- if is_file_exists(HOME .. "/.config/hypr/custom/general.lua") then
-- 	require("custom.general")
-- end
-- if is_file_exists(HOME .. "/.config/hypr/custom/rules.lua") then
-- 	require("custom.rules")
-- end
-- if is_file_exists(HOME .. "/.config/hypr/custom/keybinds.lua") then
-- 	require("custom.keybinds")
-- end

-- Aether theming integration --
require("hyprland.aether")

-- Shell overrides --
require("hyprland.shellOverrides.main")
