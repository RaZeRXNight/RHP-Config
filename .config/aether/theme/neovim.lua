return {
  {
    "bjarneo/aether.nvim",
    branch = "v3",
    name = "aether",
    priority = 1000,
    opts = {
      colors = {
        bg         = "#000010",
        dark_bg    = "#00000c",
        darker_bg  = "#000008",
        lighter_bg = "#1a1a28",

        fg         = "#FDFC00",
        dark_fg    = "#bebd00",
        light_fg   = "#fdfc26",
        bright_fg  = "#fefd40",
        muted      = "#5a5d63",

        red        = "#e03d37",
        yellow     = "#EFE100",
        orange     = "#e55a55",
        green      = "#F4E800",
        cyan       = "#66869C",
        blue       = "#577fa0",
        purple     = "#a7647a",
        brown      = "#893633",

        bright_red    = "#ff5d52",
        bright_yellow = "#fff100",
        bright_green  = "#fff400",
        bright_cyan   = "#87abc7",
        bright_blue   = "#77a3ce",
        bright_purple = "#d384a0",

        accent               = "#577fa0",
        cursor               = "#FDFC00",
        foreground           = "#FDFC00",
        background           = "#000010",
        selection             = "#1a1a28",
        selection_foreground = "#FDFC00",
        selection_background = "#1a1a28",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "aether",
    },
  },
}
