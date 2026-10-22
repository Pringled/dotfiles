return {
  "zbirenbaum/copilot.lua",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      filetypes = { markdown = true },
      panel = { enabled = false },
      suggestion = {
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 75,
        keymap = {
          accept = "<C-l>",
          accept_word = false,
          accept_line = false,
          next = false,
          prev = false,
          dismiss = "<C-]>",
        },
      },
    })
  end,
}
