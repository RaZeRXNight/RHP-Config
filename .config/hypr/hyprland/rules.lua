-- Window and layer rules
-- e.g.
-- hl.window_rule({
--     name  = "float-pavucontrol",
--     match = { class = "pavucontrol" },
--     float = true,
-- })

hl.window_rule({
    name   = "float-terminal",
    match  = { title = "floating" },
    float  = true,
    size   = {"62.5%", "74%"},
    center = true,
})
