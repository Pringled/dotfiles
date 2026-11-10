return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  opts = {
    languages = {
      "python", "lua", "javascript", "typescript", "json", "html",
      "yaml", "toml", "markdown", "bash", "dockerfile", "sql",
    },
  },
  config = function(_, opts)
    require("nvim-treesitter").install(opts.languages)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = opts.languages,
      callback = function(args) pcall(vim.treesitter.start, args.buf) end,
    })
  end,
}
