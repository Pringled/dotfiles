return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "AgenticChat" },
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  -- Only the pi panel: render tables, code blocks and headings like pi does, without heading icons or backgrounds
  opts = {
    file_types = { "AgenticChat" },
    heading = { sign = false, position = "inline", icons = { "", "", "", "", "", "" }, backgrounds = {} },
    code = { sign = false, width = "block", left_pad = 1, right_pad = 1, language_icon = false },
    bullet = { icons = { "•", "◦" } },
  },
  init = function()
    -- Headings in gold bold, like pi's "claude" theme (mdHeading)
    local function apply()
      for level = 1, 6 do vim.api.nvim_set_hl(0, "RenderMarkdownH" .. level, { fg = "#E5B567", bold = true }) end
    end
    apply()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = apply })
  end,
}
