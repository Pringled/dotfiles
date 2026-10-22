-- Entry point. Loads core settings, then lazy.nvim plugin manager.
if vim.fn.has("nvim-0.12.0") == 0 then
  error("This config requires Neovim 0.12.0 or later.")
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("config.options")
require("config.keymaps")
require("config.lazy")
