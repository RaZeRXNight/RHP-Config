return {
  {
    "bjarneo/aether.nvim",
    branch = "v3",
    name = "aether",
    priority = 1000,
    opts = {
      colors = {
        bg         = "#010103",
        dark_bg    = "#010102",
        darker_bg  = "#010102",
        lighter_bg = "#1a1a1c",

        fg         = "#999999",
        dark_fg    = "#737373",
        light_fg   = "#a8a8a8",
        bright_fg  = "#b3b3b3",
        muted      = "#5a5a61",

        red        = "#996b6e",
        yellow     = "#708b68",
        orange     = "#a88184",
        green      = "#58846e",
        cyan       = "#70a8b1",
        blue       = "#7c89b0",
        purple     = "#a588ab",
        brown      = "#654d4f",

        bright_red    = "#c28d91",
        bright_yellow = "#799d6d",
        bright_green  = "#599779",
        bright_cyan   = "#6bbbc8",
        bright_blue   = "#8698cc",
        bright_purple = "#ba93c2",

        accent               = "#7c89b0",
        cursor               = "#999999",
        foreground           = "#999999",
        background           = "#010103",
        selection             = "#1a1a1c",
        selection_foreground = "#999999",
        selection_background = "#1a1a1c",
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
