return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local languages = {
      "python", "lua", "javascript", "typescript", "json", "html",
      "yaml", "toml", "markdown", "bash", "dockerfile", "sql",
    }

    require("nvim-treesitter").install(languages)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = languages,
      callback = function(args) pcall(vim.treesitter.start, args.buf) end,
    })
  end,
}
