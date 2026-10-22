return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "Restore session for this folder" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "Don't save this session" },
  },
  opts = {},
  init = function()
    -- Side panels don't restore cleanly, so close them before the session is saved
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistenceSavePre",
      callback = function() pcall(vim.cmd, "NvimTreeClose") end,
    })
  end,
}
