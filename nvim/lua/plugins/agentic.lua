-- pi runs through two optional local helpers when they are installed: pi-acp-cocoding, a pi-acp wrapper that
-- hides reasoning traces and startup text, and pi-nvim, which starts pi in a sandbox. Without them this is plain pi-acp.
local function has(cmd) return vim.fn.executable(cmd) == 1 end
-- PI_COCODING lets a pi extension ask before every file change when Neovim is the one driving pi
local env = { PI_COCODING = "1" }
if has("pi-acp-cocoding") then
  env.PI_ACP_HIDE_THINKING = "1"
  env.PI_ACP_QUIET_STARTUP = "1"
end
if has("pi-nvim") then env.PI_ACP_PI_COMMAND = "pi-nvim" end

return {
  "carlos-algms/agentic.nvim",
  keys = {
    { "<leader>aa", function() require("agentic").toggle() end, mode = { "n", "v" }, desc = "Toggle pi chat" },
    {
      "<leader>as",
      function() require("agentic").add_selection_or_file_to_context() end,
      mode = { "n", "v" },
      desc = "Send selection (or file) to pi",
    },
    { "<leader>an", function() require("agentic").new_session() end, desc = "New pi session" },
    { "<leader>ar", function() require("agentic").restore_session() end, desc = "Restore a pi session" },
    { "<leader>ad", function() require("agentic").add_current_line_diagnostics() end, desc = "Send line diagnostic to pi" },
    { "<leader>aD", function() require("agentic").add_buffer_diagnostics() end, desc = "Send file diagnostics to pi" },
  },
  opts = {
    provider = "pi-acp",
    acp_providers = {
      ["pi-acp"] = {
        name = "pi",
        command = has("pi-acp-cocoding") and "pi-acp-cocoding" or "pi-acp",
        env = env,
      },
    },
    diff_preview = { layout = "split" },
    -- One line per tool call, like pi-polish; za expands one
    folding = { tool_calls = { threshold = 0 } },
    -- No bar above the prompt box; the grey status line below it already shows the send/mode keys
    headers = {
      input = function() return nil end,
      -- pi-style info line: pi · model · context used/size (%) · cost
      chat = function(_, state)
        local parts = { "pi" }
        if state then
          local model = state:get_model_name()
          if model then table.insert(parts, (model:gsub("^.-/", ""))) end
          local used, size = state:get_context_used(), state:get_context_size()
          local used_raw, size_raw = state:get_context_used_raw(), state:get_context_size_raw()
          if used and size and used_raw and size_raw and size_raw > 0 then
            table.insert(parts, string.format("%s/%s (%d%%)", used, size, math.floor(used_raw / size_raw * 100 + 0.5)))
          end
          local cost = state:get_cost_amount_raw()
          if cost and cost > 0 then table.insert(parts, "$" .. string.format("%.2f", cost)) end
        end
        return table.concat(parts, " · ")
      end,
    },
    -- Monochrome symbols instead of the default emoji
    chat_icons = { user = "›", agent = "π" },
    message_icons = { thinking = "∴", finished = "✓", stopped = "■", error = "✗" },
    spinner_chars = {
      thinking = { "·", "✢", "✳", "∗", "✻", "✽" },
      searching = { "·  ", "·· ", "···" },
    },
  },
  init = function()
    -- Colours from pi's "claude" theme (~/.pi/agent/themes/claude.json); agentic only fills in groups left unset
    local c = {
      coral = "#D97757", cream = "#E8E6E1", ink = "#1F1E1C", warm_dim = "#6B6862", warm_dark = "#4A4741",
      gold = "#E5B567", cyan = "#7DCFCF", badge_pending = "#8A4E3B", badge_ok = "#3E5A2E", badge_fail = "#7A3A2F",
      word_add = "#2F4A26", word_del = "#5A2A24",
    }
    local groups = {
      AgenticTitle = { bg = c.coral, fg = c.ink, bold = true },
      AgenticThinking = { fg = c.warm_dim, italic = true },
      AgenticStatusPending = { bg = c.badge_pending, fg = c.cream },
      AgenticStatusCompleted = { bg = c.badge_ok, fg = c.cream },
      AgenticStatusFailed = { bg = c.badge_fail, fg = c.cream },
      AgenticPermissionButtonAllow = { bg = c.badge_ok, fg = c.cream, bold = true },
      AgenticPermissionButtonReject = { bg = c.badge_fail, fg = c.cream, bold = true },
      AgenticCodeBlockFence = { fg = c.warm_dark },
      AgenticSpinnerGenerating = { fg = c.coral, bold = true },
      AgenticSpinnerThinking = { fg = c.gold, bold = true },
      AgenticSpinnerSearching = { fg = c.cyan, bold = true },
      AgenticDiffAddWord = { bg = c.word_add, bold = true },
      AgenticDiffDeleteWord = { bg = c.word_del, bold = true },
    }
    local function apply()
      for name, spec in pairs(groups) do vim.api.nvim_set_hl(0, name, spec) end
    end
    apply()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = apply })

    -- Other splits (NvimTree, the terminal, a screen change) reflow the panel; keep it at 40% wide
    -- and the prompt box at its default 10 rows so the chat gets the rest
    vim.api.nvim_create_autocmd({ "VimResized", "WinNew", "WinClosed" }, {
      callback = vim.schedule_wrap(function()
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          if vim.api.nvim_win_is_valid(win) then
            local ft = vim.bo[vim.api.nvim_win_get_buf(win)].filetype
            if ft == "AgenticChat" then vim.api.nvim_win_set_width(win, math.floor(vim.o.columns * 0.4)) end
            if ft == "AgenticInput" then vim.api.nvim_win_set_height(win, 10) end
          end
        end
      end),
    })

    -- agentic.nvim leaves the chat buffer without a highlighter; start markdown so code blocks get syntax colours
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "AgenticChat",
      callback = function(args) pcall(vim.treesitter.start, args.buf, "markdown") end,
    })
  end,
}
