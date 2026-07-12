return {
  "milanglacier/minuet-ai.nvim",
  config = function()
    local function get_opencode_key()
      -- 1. Prefer the env var (populated at shell init via conf.d/opencode-key.zsh)
      local key = vim.env.OPENCODE_GO_API_KEY
      if key and key ~= "" then
        return key
      end
      -- 2. Fallback: read directly from the freedesktop Secret Service
      local handle = io.popen("secret-tool lookup application opencode key api_key 2>/dev/null")
      if handle then
        key = handle:read("*a")
        handle:close()
        key = key and key:gsub("%s+$", "")
        if key and key ~= "" then
          return key
        end
      end
      -- 3. Final fallback: plain file (gitignored, chmod 600)
      local f = io.open(vim.fn.expand("~/.config/opencode/api_key"), "r")
      if f then
        key = f:read("*a")
        f:close()
        key = key and key:gsub("%s+$", "")
        if key and key ~= "" then
          return key
        end
      end
      return nil
    end

    require("minuet").setup({
      provider = "openai_compatible",
      notify = "warn",
      request_timeout = 3,
      throttle = 1500, -- reduce cost / avoid rate limits
      debounce = 600, -- reduce cost / avoid rate limits
      provider_options = {
        openai_compatible = {
          api_key = get_opencode_key, -- function: resolves key at request time
          end_point = "https://opencode.ai/zen/v1/chat/completions",
          model = "deepseek-v4-flash-free", -- free tier on opencode gateway
          name = "Opencode",
          optional = {
            max_tokens = 128,
            top_p = 0.9,
            thinking = { type = "disabled" }, -- disable thinking to avoid first-token latency
          },
        },
        -- Fallback if OPENCODE_GO_API_KEY is unavailable:
        -- openai_compatible = {
        --   api_key = "OPENROUTER_API_KEY",
        --   end_point = "https://openrouter.ai/api/v1/chat/completions",
        --   model = "deepseek/deepseek-v4-flash:free",
        --   name = "Openrouter",
        --   optional = { max_tokens = 56, top_p = 0.9, reasoning = { effort = "none" } },
        -- },
      },
      virtualtext = {
        auto_trigger_ft = { "*" },
        keymap = {
          accept = "<A-A>",
          accept_line = "<A-a>",
          accept_n_lines = "<A-z>",
          prev = "<A-[>",
          next = "<A-]>",
          dismiss = "<A-e>",
        },
      },
    })
  end,
}
