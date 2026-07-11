hl.config({
    animations = {
        enabled = true,
    },
})

hl.animation({ leaf = "global",        enabled = true, speed = 4,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 3,   bezier = "default" })
hl.animation({ leaf = "windows",       enabled = true, speed = 3,   bezier = "default" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 2.5, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 2,   bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "fade",          enabled = true, speed = 2.5, bezier = "default" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 2,   bezier = "default" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.5, bezier = "default" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3,   bezier = "default" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 2.5, bezier = "default", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5, bezier = "default", style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 2,   bezier = "default" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.5, bezier = "default" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 3,   bezier = "default", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 2.5, bezier = "default", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 2.5, bezier = "default", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 4,   bezier = "default" })
