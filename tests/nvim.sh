#!/usr/bin/env bash
# Installs the plugins pinned in nvim/lazy-lock.json into throwaway folders, then starts Neovim and fails on any error.
set -euo pipefail

repo="$(cd "$(dirname "$0")/.." && pwd)"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$tmp/config"
cp -R "$repo/nvim" "$tmp/config/nvim"
export XDG_CONFIG_HOME="$tmp/config" XDG_DATA_HOME="$tmp/data" XDG_STATE_HOME="$tmp/state" XDG_CACHE_HOME="$tmp/cache"

nvim --headless "+Lazy! restore" +qa

printf 'def greet(name):\n    return f"hi {name}"\n' > "$tmp/example.py"
nvim --headless "$tmp/example.py" \
  "+lua vim.defer_fn(function() local m = vim.api.nvim_exec2('messages', { output = true }).output; if vim.v.errmsg ~= '' or m:find('E%d+:') or m:find('Error') then io.stderr:write(m .. vim.v.errmsg .. '\n'); vim.cmd('cquit 1') else vim.cmd('qa!') end end, 3000)"

echo "nvim: config loads without errors"
