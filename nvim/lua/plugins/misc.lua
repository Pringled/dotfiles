local branch_review_enabled = true

local function branch_base(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr)
  local cwd = path == "" and vim.fn.getcwd() or vim.fs.dirname(path)
  if vim.fn.isdirectory(cwd) == 0 then cwd = vim.fn.getcwd() end

  for _, ref in ipairs({ "origin/main", "main" }) do
    local result = vim.system({ "git", "merge-base", ref, "HEAD" }, {
      cwd = cwd,
      text = true,
    }):wait()
    if result.code == 0 then return vim.trim(result.stdout), ref end
  end
end

local function set_branch_review(enabled, bufnr, notify)
  local gitsigns = require("gitsigns")
  if not enabled then
    gitsigns.reset_base(true)
    if notify then vim.notify("Git signs: showing working-tree changes") end
    return true
  end

  local base, ref = branch_base(bufnr or vim.api.nvim_get_current_buf())
  if not base then
    if notify then vim.notify("Git signs: could not find origin/main or main", vim.log.levels.WARN) end
    return false
  end

  gitsigns.change_base(base, true)
  if notify then vim.notify("Git signs: showing branch changes vs " .. ref) end
  return true
end

return {
  -- Git signs in the gutter + hunk navigation
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    opts = {
      base = branch_base(vim.api.nvim_get_current_buf()),
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local map = function(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end
        map("n", "]c", ":Gitsigns next_hunk<CR>", "Next git hunk")
        map("n", "[c", ":Gitsigns prev_hunk<CR>", "Previous git hunk")
        map("n", "<leader>hp", ":Gitsigns preview_hunk<CR>", "Preview hunk")
        map("n", "<leader>hs", ":Gitsigns stage_hunk<CR>", "Stage hunk")
        map("n", "<leader>gb", function()
          if branch_review_enabled then
            branch_review_enabled = false
            set_branch_review(false, bufnr, true)
          elseif set_branch_review(true, bufnr, true) then
            branch_review_enabled = true
          end
        end, "Toggle branch review signs")
      end,
    },
  },

  -- Review working-tree or feature-branch changes in a dedicated diff tab
  {
    "sindrets/diffview.nvim",
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<CR>", desc = "Review working tree" },
      { "<leader>gM", "<cmd>DiffviewOpen origin/main...HEAD<CR>", desc = "Review branch vs main" },
    },
    opts = {},
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { options = { theme = "vscode" } },
  },

  -- Visual list of open buffers; this is not the same as native tab pages
  {
    "akinsho/bufferline.nvim",
    enabled = false,
    version = "*",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>bd", "<cmd>BufferLinePickClose<CR>", desc = "Close buffer" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", desc = "Close other buffers" },
    },
    opts = {
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        separator_style = "slant",
        always_show_bufferline = false,
        show_buffer_close_icons = true,
        show_close_icon = false,
        offsets = {
          { filetype = "NvimTree", text = "File Explorer", text_align = "left" },
        },
      },
    },
  },

  -- Shows available leader mappings while learning the config
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>?",
        function() require("which-key").show({ global = false }) end,
        desc = "Show buffer keymaps",
      },
    },
    opts = {
      triggers = { { "<leader>", mode = { "n", "v" } } },
    },
  },

  -- Highlight TODO / FIXME / NOTE comments and search them project-wide
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "Find TODOs" },
    },
    opts = {},
  },

  -- Auto-close brackets/quotes
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- Comment toggling (gcc, gc in visual mode)
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- File explorer sidebar (optional — telescope covers most navigation)
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = { { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" } },
    opts = {
      filters = {
        dotfiles = true,
        git_ignored = true,
        exclude = {
          "/%.secret%.toml$",
          "/%.secrets%.toml$",
          "/local$",
          "/local/",
          "/experiments$",
          "/experiments/",
          "/models$",
          "/models/",
          "/data$",
          "/data/",
        },
      },
      renderer = { highlight_git = "name" },
      view = { preserve_window_proportions = true },
    },
  },
}
