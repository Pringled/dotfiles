# Neovim

Neovim 0.12 config for terminal-heavy work and Python.

Requires Neovim 0.12+, Git, Make, ripgrep, Node.js and the tree-sitter CLI, which builds the syntax parsers (`brew install neovim ripgrep node tree-sitter-cli`). `../install.sh` links this folder to `~/.config/nvim`. On the first launch lazy.nvim installs the plugins pinned in `lazy-lock.json`, and Mason installs the language servers in the background; `:checkhealth` confirms everything once it's done. Update plugins with `:Lazy update` and roll back with `:Lazy restore`.

## What's included

- **lazy.nvim** — plugin manager
- **VS Code Dark+** — colorscheme matching the familiar VS Code palette
- **treesitter** — syntax highlighting for Python, Lua, HTML, JS/TS, JSON, YAML, TOML, Markdown, bash, Dockerfile, SQL
- **treesitter-textobjects** — select or jump by function, class, and argument
- **telescope** — fuzzy finder (files, grep, buffers, diagnostics)
- **LSP** (Mason + lspconfig) — basedpyright (types/nav/inlay hints, `standard` checking) plus Lua, JSON, YAML, and Bash servers; Ruff runs from each Python project's `uv` environment for linting, and sorts imports and formats on save (`<space>uf` toggles)
- **blink.cmp** — autocompletion with a docs panel
- **neotest** — run pytest tests from the editor with gutter results
- **persistence.nvim** — saves open files and splits per folder; restore from the dashboard (`s`) or `<space>qs`
- **todo-comments** — highlights TODO / FIXME / NOTE and lists them with `<space>ft`
- **agentic.nvim + pi** — pi in a chat panel (`<space>aa`) for co-coding; every file change pi proposes opens as a diff to approve (`1`) or reject (`2`). Needs `pi-acp` (`npm i -g pi-acp`)
- **Copilot** — inline GitHub Copilot suggestions in code and Markdown
- **Markdown Preview** — live browser preview in Google Chrome
- **gitsigns** — persistent branch-change indicators in normal code buffers and hunk actions
- **Diffview** — review working-tree changes or a feature branch against `origin/main`
- **lualine** — statusline
- **Snacks terminal** — full-width bottom terminal (`<C-\>`); `gf` on a path in its output opens that file
- **nvim-autopairs**, **Comment.nvim**, **nvim-tree**, **which-key** — quality of life and keymap discovery; NvimTree colours uncommitted Git filenames
- **nvim-key-insights** — records Neovim usage locally for reports and optional agent analysis
- **zen-mode.nvim** — centered, distraction-free writing layout with a 100-column content window
- **snacks.nvim dashboard** — custom ASCII-art start screen with recent files, projects, and actions
- **snacks.nvim UI polish** — indent guides, smooth scrolling, word highlights, notifications, floating input, and a tidy statuscolumn; set `enabled = false` per module in `lua/plugins/learning.lua` to turn one off
- **Native UI polish** — rounded float borders, smooth scrolling for wrapped lines, and Neovim 0.12's experimental message/cmdline UI (`use_ui2` in `lua/config/options.lua`)

## Key mappings (leader = space)

| Keys | Action |
|---|---|
| `<space>ff` | Find files |
| `<space>fg` | Live grep |
| `<space>fb` | Find buffers |
| `<space>fd` | Diagnostics list |
| `<space>fs` | Jump to a symbol in the current file |
| `<space>ft` | Find TODO / FIXME comments |
| `<space>fk` | Search all keymaps |
| `<space>fh` | Search Neovim's built-in help, including motions such as `j` |
| `<space>?` | Show buffer-local keymaps in WhichKey |
| `gd` | Go to definition |
| `grr` | Go to references (Neovim default) |
| `K` | Hover docs |
| `<space>rn` | Rename symbol |
| `<space>ca` | Code action |
| `<space>cf` | Format buffer |
| `<space>cd` | Show diagnostic |
| `<space>mp` | Toggle Markdown preview in Google Chrome |
| `<C-Space>` / `<Tab>` / `<CR>` (Insert mode) | Open completion / next item / accept |
| `<C-l>` (Insert mode) | Accept Copilot suggestion |
| `<C-]>` (Insert mode) | Dismiss Copilot suggestion |
| `[d` / `]d` | Prev/next diagnostic |
| `[c` / `]c` | Prev/next git hunk |
| `<space>tt` / `<space>tf` / `<space>ta` | Run nearest test / file / all tests |
| `<space>tl` / `<space>ts` / `<space>to` | Rerun last / test summary / test output |
| `]t` / `[t` | Next/previous failed test |
| `<space>hp` | Preview git hunk |
| `<space>gb` | Toggle branch-change signs vs `origin/main` |
| `<space>gv` | Review working-tree changes |
| `<space>gM` | Review current branch vs `origin/main` |
| `<C-\>` | Toggle terminal (bottom split); `<C-h/j/k/l>` also move out of it |
| `<space>e` | Toggle file tree |
| `<space>z` | Toggle centered writing mode |
| `<space>ui` / `<space>us` / `<space>uw` | Toggle indent guides / smooth scroll / word highlights |
| `<space>uh` / `<space>uf` | Toggle inlay hints / Ruff format on save |
| `<space>ud` | Toggle dimming outside the current block |
| `<space>aa` / `<space>as` | Toggle pi chat / send selection (or file) to pi |
| `<space>an` / `<space>ar` | New pi session / restore a pi session |
| `<space>ad` / `<space>aD` | Send line / file diagnostics to pi |
| `<space>qs` / `<space>ql` / `<space>qd` | Restore folder session / restore last session / don't save this session |
| `af` `if` / `ac` `ic` / `aa` `ia` | Function / class / argument text objects, e.g. `vaf`, `dif`, `cia` |
| `]f` `[f` / `]k` `[k` | Next/previous function / class |
| `<space>un` | Notification history |
| `<space>ni` / `<space>nr` / `<space>na` | Key Insights status / report / agent analysis |
| `<C-h/j/k/l>` | Move between splits |

## Notes

- Clipboard is set to `unnamedplus`, so yanks go to the system clipboard. Over SSH,
  kitty's OSC52 support carries them across.
- The mouse is off (`opt.mouse = ""`). Set it to `"a"` in `lua/config/options.lua`
  to turn it on.
- Ruff handles both linting and formatting for Python — no need for a
  separate black/flake8 setup. Neovim runs `uv run ruff server`, so it uses the
  current project's locked Ruff version and `pyproject.toml` rules.
- Git signs compare the current branch against its merge-base with `origin/main`
  by default, so added (`+`) and changed (`~`) code stays marked after commit.
  Press `<space>gb` to toggle back to ordinary working-tree signs.
- NvimTree hides dotfiles and Git-ignored files by default, except
  `.secret.toml`, `.secrets.toml`, `local/`, `experiments/`, `models/`, and
  `data/`. Telescope keeps the contents of large ignored directories out of
  `Space ff` so file search stays fast; use NvimTree to browse those folders.
  In NvimTree, `H` toggles dotfiles and `I` toggles Git-ignored files when you
  need to inspect more broadly.
- On the first use, run `:Copilot auth` to sign in. Copilot suggestions appear
  automatically while typing; accept them with `<C-l>` or dismiss them with
  `<C-]>`.
- `which-key` shows available leader mappings after you press `<space>`.
- Key Insights starts a local usage session automatically and stores aggregated
  data under Neovim's state directory. It does not store inserted text or
  command/search contents. Generate a local report with `<space>nr`; the
  optional agent analysis is `<space>na`.
- Key Insights' report analyzer is installed separately:
  `cargo install --git https://github.com/beso1225/nvim-key-insights.git --tag v0.2.0 --locked key-insights`.
- Opening `nvim` without a file shows the Snacks dashboard. Its keys are `f`
  (files), `g` (grep), `r` (recent files), `c` (config), `z` (writing mode),
  and `q` (quit).
- Writing mode (`<space>z`) opens the current buffer in a centered 100-column
  window, dims the surrounding layout, hides the statusline, and temporarily
  removes code-oriented signs and columns. It does not modify the file. Toggle
  it again, or use `:ZenMode`, to return to the normal layout.
- This config uses four spaces for Python and two for JavaScript, TypeScript,
  JSON, and YAML. Markdown wraps at 88 columns and maps `j`/`k` to visual-line
  movement, so wrapped prose moves one screen row at a time. Use `gqap` to
  reflow the paragraph under the cursor. Project `.editorconfig` settings take
  precedence.
- Prefer a neighbouring Kitty pane for Pi, Claude Code, and long-running
  commands. The built-in terminal is useful for shorter commands when you
  want them inside Neovim.
