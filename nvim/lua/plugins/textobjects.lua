return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  lazy = false,
  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = { lookahead = true },
      move = { set_jumps = true },
    })

    local select = function(query)
      return function()
        require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
      end
    end
    local move = function(fn, query)
      return function()
        require("nvim-treesitter-textobjects.move")[fn](query, "textobjects")
      end
    end

    for keys, spec in pairs({
      af = { "@function.outer", "Around function" },
      ["if"] = { "@function.inner", "Inside function" },
      ac = { "@class.outer", "Around class" },
      ic = { "@class.inner", "Inside class" },
      aa = { "@parameter.outer", "Around argument" },
      ia = { "@parameter.inner", "Inside argument" },
    }) do
      vim.keymap.set({ "x", "o" }, keys, select(spec[1]), { desc = spec[2] })
    end

    for keys, spec in pairs({
      ["]f"] = { "goto_next_start", "@function.outer", "Next function" },
      ["[f"] = { "goto_previous_start", "@function.outer", "Previous function" },
      ["]k"] = { "goto_next_start", "@class.outer", "Next class" },
      ["[k"] = { "goto_previous_start", "@class.outer", "Previous class" },
    }) do
      vim.keymap.set({ "n", "x", "o" }, keys, move(spec[1], spec[2]), { desc = spec[3] })
    end
  end,
}
