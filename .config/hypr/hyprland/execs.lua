-- Autostart / shutdown managed processes (formerly exec-once)

hl.on("hyprland.start", function()
    hl.exec_cmd("qs -c ii")
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("bash -c 'pidof hyprsunset >/dev/null || /usr/bin/hyprsunset'")
    hl.exec_cmd("bash -c 'pidof hypridle >/dev/null || hypridle'")
end)

hl.on("hyprland.shutdown", function()
    hl.exec_cmd("pkill -f 'qs -c ii'")
    hl.exec_cmd("pkill -f awww-daemon")
    hl.exec_cmd("pkill -f hypridle")
end)
