return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
  },
  keys = {
    { "<leader>tt", function() require("neotest").run.run() end, desc = "Run nearest test" },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run test file" },
    { "<leader>ta", function() require("neotest").run.run(vim.fn.getcwd()) end, desc = "Run all tests" },
    { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Rerun last test" },
    { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle test summary" },
    { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Show test output" },
    { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle output panel" },
    { "<leader>tx", function() require("neotest").run.stop() end, desc = "Stop tests" },
    { "]t", function() require("neotest").jump.next({ status = "failed" }) end, desc = "Next failed test" },
    { "[t", function() require("neotest").jump.prev({ status = "failed" }) end, desc = "Previous failed test" },
  },
  config = function()
    require("neotest").setup({
      adapters = { require("neotest-python")({ runner = "pytest" }) },
    })
  end,
}
