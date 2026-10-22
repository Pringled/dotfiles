return {
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
      "saghen/blink.cmp",
    },
    opts = {
      -- Ruff runs through each project's uv environment; Mason manages the rest.
      ensure_installed = {
        "basedpyright", "lua_ls", "jsonls", "yamlls", "bashls",
      },
      automatic_enable = { exclude = { "ruff", "pyright" } },
    },
    config = function(_, opts)
      local function ruff_organize_imports(client, bufnr)
        local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
        params.context = { only = { "source.organizeImports.ruff" }, diagnostics = {} }
        local response = client:request_sync("textDocument/codeAction", params, 1000, bufnr)
        for _, action in ipairs(response and response.result or {}) do
          if not action.edit then
            local resolved = client:request_sync("codeAction/resolve", action, 1000, bufnr)
            action = resolved and resolved.result or action
          end
          if action.edit then vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding) end
        end
      end

      local capabilities = require("blink.cmp").get_lsp_capabilities()

      local on_attach = function(client, bufnr)
        if client.name == "ruff" then
          client.server_capabilities.hoverProvider = false
          -- Sort imports and format on save; toggle with <leader>uf
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("ruff_format_on_save_" .. bufnr, { clear = true }),
            buffer = bufnr,
            callback = function()
              if vim.g.autoformat == false then return end
              ruff_organize_imports(client, bufnr)
              vim.lsp.buf.format({ bufnr = bufnr, id = client.id, timeout_ms = 2000 })
            end,
          })
        end

        local map = function(keys, fn, desc)
          vim.keymap.set("n", keys, fn, { buffer = bufnr, desc = desc })
        end
        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("K", vim.lsp.buf.hover, "Hover docs")
        map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("<leader>cf", function()
          vim.lsp.buf.format({
            async = true,
            filter = function(formatter) return formatter.name ~= "basedpyright" end,
          })
        end, "Format buffer")
      end

      local servers = { "jsonls", "yamlls", "bashls" }
      for _, server in ipairs(servers) do
        vim.lsp.config(server, { capabilities = capabilities, on_attach = on_attach })
      end

      vim.lsp.config("basedpyright", {
        capabilities = capabilities,
        on_attach = on_attach,
        -- "standard" matches plain Pyright; basedpyright defaults to much stricter checks
        -- exclude keeps basedpyright's defaults plus local/, the globally gitignored scratch dir (cloned repos, notebooks)
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "standard",
              exclude = { "**/node_modules", "**/__pycache__", "**/.*", "**/local" },
            },
          },
        },
      })

      vim.lsp.config("ruff", {
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = { "uv", "run", "ruff", "server" },
      })

      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = { Lua = { diagnostics = { globals = { "vim" } } } },
      })

      vim.diagnostic.config({
        virtual_text = true,
        severity_sort = true,
        float = { border = "rounded" },
      })

      require("mason-lspconfig").setup(opts)
      vim.lsp.enable("ruff")
    end,
  },
}
