return {
  {
    "bjarneo/aether.nvim",
    branch = "v3",
    name = "aether",
    priority = 1000,
    opts = {
      colors = {
        bg         = "#000000",
        dark_bg    = "#000000",
        darker_bg  = "#000000",
        lighter_bg = "#1a1a1a",

        fg         = "#D9C4AB",
        dark_fg    = "#a39380",
        light_fg   = "#dfcdb8",
        bright_fg  = "#e3d3c0",
        muted      = "#686163",

        red        = "#c45146",
        yellow     = "#977648",
        orange     = "#cd6b62",
        green      = "#977169",
        cyan       = "#6679bc",
        blue       = "#6174b4",
        purple     = "#9b6b92",
        brown      = "#7b403b",

        bright_red    = "#f47161",
        bright_yellow = "#bf9a5d",
        bright_green  = "#bf9489",
        bright_cyan   = "#889bf1",
        bright_blue   = "#8396e8",
        bright_purple = "#c58cbe",

        accent               = "#6174b4",
        cursor               = "#D9C4AB",
        foreground           = "#D9C4AB",
        background           = "#000000",
        selection             = "#1a1a1a",
        selection_foreground = "#D9C4AB",
        selection_background = "#1a1a1a",
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
