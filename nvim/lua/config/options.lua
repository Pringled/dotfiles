local opt = vim.opt

-- Leader key (space is the standard modern choice)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation (adjust per-project via .editorconfig if needed)
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true

local two_space_indent = vim.api.nvim_create_augroup("two_space_indent", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = two_space_indent,
  pattern = { "javascript", "typescript", "json", "yaml" },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
  end,
})

local prose_formatting = vim.api.nvim_create_augroup("prose_formatting", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = prose_formatting,
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.textwidth = 88
    vim.opt_local.formatoptions:append("t")
    vim.opt_local.formatoptions:remove("l")
    vim.keymap.set("n", "j", "gj", { buffer = true, desc = "Down visual line" })
    vim.keymap.set("n", "k", "gk", { buffer = true, desc = "Up visual line" })
  end,
})

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

-- UI
opt.termguicolors = true
opt.signcolumn = "yes"       -- avoid text-shift when diagnostics appear
opt.scrolloff = 8
opt.wrap = false
opt.cursorline = true
opt.splitright = true
opt.splitbelow = true

-- UI polish: delete or comment out any line to revert it
opt.winborder = "rounded"    -- rounded borders on all floating windows
opt.fillchars = { eob = " " } -- hide ~ after end of buffer
opt.smoothscroll = true

-- Experimental 0.12 message/cmdline UI; set to false to restore the classic cmdline.
-- It is a private module, so a Neovim upgrade that moves it falls back to the classic cmdline.
local use_ui2 = true
local has_ui2, ui2 = pcall(require, "vim._core.ui2")
if use_ui2 and has_ui2 then
  opt.cmdheight = 0
  ui2.enable({ msg = { targets = "msg" } })
end

-- Performance / behavior
opt.updatetime = 250
opt.timeoutlen = 300
opt.undofile = true          -- persistent undo across sessions
opt.swapfile = false
opt.backup = false

-- Reload files changed outside Neovim, e.g. by an agent
local reload_changed = vim.api.nvim_create_augroup("reload_changed", { clear = true })
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  group = reload_changed,
  callback = function()
    if vim.fn.getcmdwintype() == "" then vim.cmd.checktime() end
  end,
})

-- Clipboard: share with system clipboard (works over SSH with OSC52,
-- kitty supports this natively)
opt.clipboard = "unnamedplus"

-- Mouse (off by default since you're keyboard-driven; flip to "a" if wanted)
opt.mouse = ""

-- Completion menu behavior
opt.completeopt = { "menu", "menuone", "noselect" }

local highlight_yank = vim.api.nvim_create_augroup("highlight_yank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = highlight_yank,
  callback = function() vim.highlight.on_yank() end,
})
