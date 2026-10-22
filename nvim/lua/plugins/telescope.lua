local function find_files_command()
  return {
    "sh",
    "-c",
    [[
{
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    git ls-files --cached --others --exclude-standard
    for file in .secret.toml .secrets.toml; do
      [ -f "$file" ] && printf "%s\\n" "$file"
    done
  else
    rg --files --hidden --color never --glob '!.git/**'
  fi
} | awk -F/ '{
  if ($NF == ".secret.toml" || $NF == ".secrets.toml") { print; next }
  for (i = 1; i < NF; i++) if ($i == "local" || $i == "experiments") { print; next }
  for (i = 1; i <= NF; i++) if ($i ~ /^\./) next
  print
}'
]],
  }
end

return {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Grep in project" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find buffers" },
    { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
    { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnostics" },
    { "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Symbols in file" },
    { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Keymaps" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Search Neovim help" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        file_ignore_patterns = {
          "%.git/",
          "__pycache__/",
          "%.venv/",
          "%.pytest_cache/",
          "%.mypy_cache/",
          "%.ruff_cache/",
          "node_modules/",
        },
      },
      pickers = {
        find_files = { find_command = find_files_command },
        live_grep = {
          additional_args = function()
            return { "--hidden" }
          end,
        },
      },
    })
    pcall(telescope.load_extension, "fzf")
  end,
}
