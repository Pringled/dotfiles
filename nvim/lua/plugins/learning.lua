local function open_telescope(picker, opts)
  require("lazy").load({ plugins = { "telescope.nvim" } })
  require("telescope.builtin")[picker](opts)
end

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
      { "<leader>ui", function() Snacks.toggle.indent():toggle() end, desc = "Toggle indent guides" },
      { "<leader>us", function() Snacks.toggle.scroll():toggle() end, desc = "Toggle smooth scroll" },
      { "<leader>uw", function() Snacks.toggle.words():toggle() end, desc = "Toggle word highlights" },
      { "<leader>ud", function() Snacks.toggle.dim():toggle() end, desc = "Toggle dim outside current block" },
      { "<leader>uh", function() Snacks.toggle.inlay_hints():toggle() end, desc = "Toggle inlay hints" },
      {
        "<leader>uf",
        function()
          vim.g.autoformat = vim.g.autoformat == false
          vim.notify("Format on save: " .. (vim.g.autoformat and "on" or "off"))
        end,
        desc = "Toggle format on save",
      },
      { "<leader>un", function() Snacks.notifier.show_history() end, desc = "Notification history" },
      { "<C-\\>", function() Snacks.terminal.toggle() end, mode = { "n", "t" }, desc = "Toggle terminal" },
    },
    opts = {
      -- UI polish: set enabled = false to turn a module off permanently
      indent = { enabled = true },
      scroll = { enabled = true },
      words = { enabled = true },
      notifier = { enabled = true },
      input = { enabled = true },
      statuscolumn = { enabled = true },
      -- Terminal as a full-width bottom split (Ctrl-\ toggles); gf opens a file path from its output
      terminal = { win = { position = "bottom", height = 0.25 } },
      image = {
        enabled = true,
        force = vim.env.KITTY_WINDOW_ID ~= nil,
      },
      dashboard = {
        enabled = true,
        width = 60,
        preset = {
          header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
]],
          keys = {
            {
              icon = " ",
              key = "f",
              desc = "Find File",
              action = function() open_telescope("find_files") end,
            },
            {
              icon = " ",
              key = "g",
              desc = "Find Text",
              action = function() open_telescope("live_grep") end,
            },
            {
              icon = " ",
              key = "r",
              desc = "Recent Files",
              action = function() open_telescope("oldfiles") end,
            },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = function()
                open_telescope("find_files", { cwd = vim.fn.stdpath("config") })
              end,
            },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = " ", key = "z", desc = "Writing Mode", action = ":ZenMode" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        formats = {
          header = { "%s", hl = "Function" },
        },
        sections = {
          { section = "header", indent = 6, padding = 1 },
          { section = "keys", gap = 1, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          { section = "startup" },
        },
      },
    },
  },
  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    keys = {
      { "<leader>z", "<cmd>ZenMode<CR>", desc = "Toggle writing mode" },
    },
    opts = {
      window = {
        width = 100,
        height = 1,
        backdrop = 0.8,
        options = {
          number = false,
          relativenumber = false,
          signcolumn = "no",
          cursorline = false,
          foldcolumn = "0",
        },
      },
      plugins = {
        options = {
          enabled = true,
          ruler = false,
          showcmd = false,
          laststatus = 0,
        },
        gitsigns = { enabled = false },
      },
    },
  },
  {
    "kamegoro/tobira.nvim",
    enabled = false,
    event = "VeryLazy",
    keys = {
      { "<leader>tt", "<cmd>Tobira<CR>", desc = "Show Neovim tip" },
      { "<leader>tg", "<cmd>TobiraGuide<CR>", desc = "Open Neovim guide" },
      { "<leader>ts", "<cmd>TobiraStats<CR>", desc = "Show Neovim stats" },
    },
    opts = {},
    config = function(_, opts)
      local notify = vim.notify
      vim.notify = function(message, level, options)
        if level == vim.log.levels.DEBUG
            and type(message) == "string"
            and message:match("^tobira: .+ is remapped .+ removed from suggestion pool$") then
          return
        end
        notify(message, level, options)
      end
      require("tobira").setup(opts)
    end,
  },
  {
    "beso1225/nvim-key-insights",
    version = "v0.2.0",
    event = "VeryLazy",
    keys = {
      { "<leader>ni", "<cmd>KeyInsightsStatus<CR>", desc = "Show Neovim usage status" },
      { "<leader>nr", "<cmd>KeyInsightsReport<CR>", desc = "Generate Neovim usage report" },
      { "<leader>na", "<cmd>KeyInsightsAnalyze<CR>", desc = "Analyze Neovim usage" },
    },
    opts = {
      privacy = {
        capture_control_keys = true,
      },
    },
    config = function(_, opts)
      local key_insights = require("key-insights")
      key_insights.setup(opts)
      key_insights.start()
    end,
  },
}
