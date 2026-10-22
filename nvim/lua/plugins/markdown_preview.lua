return {
  "iamcco/markdown-preview.nvim",
  ft = { "markdown" },
  build = function() vim.fn["mkdp#util#install_sync"](true) end,
  init = function()
    vim.g.mkdp_browser = "Google Chrome"
    vim.g.mkdp_filetypes = { "markdown" }
    vim.g.mkdp_theme = "dark"
  end,
  keys = {
    { "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", desc = "Toggle Markdown preview" },
  },
}
