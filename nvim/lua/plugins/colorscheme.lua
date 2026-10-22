return {
  "Mofiqul/vscode.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.o.background = "dark"
    require("vscode").setup({
      transparent = true, -- let Kitty's translucent background show through
      italic_comments = false,
      disable_nvimtree_bg = true,
      terminal_colors = false,
      color_overrides = { vscBack = "#212733" },
    })
    vim.cmd.colorscheme("vscode")
  end,
}
