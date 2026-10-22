#!/usr/bin/env bash
# Symlinks the configs in this repo into place. Anything already there is moved to <name>.backup-<time> first.
# Run with --dry-run to see what it would do.
set -euo pipefail

repo="$(cd "$(dirname "$0")" && pwd)"
dry_run=false
[ "${1:-}" = "--dry-run" ] && dry_run=true
stamp="$(date +%Y%m%d-%H%M%S)"

run() {
  if $dry_run; then echo "  would run: $*"; else "$@"; fi
}

link() {
  local source="$repo/$1" target="$2"
  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    echo "ok       $target"
    return
  fi
  if [ -e "$target" ] || [ -L "$target" ]; then
    echo "backup   $target -> $target.backup-$stamp"
    run mv "$target" "$target.backup-$stamp"
  fi
  echo "link     $target -> $source"
  run mkdir -p "$(dirname "$target")"
  run ln -s "$source" "$target"
}

link kitty/kitty.conf "$HOME/.config/kitty/kitty.conf"
link kitty/theme.conf "$HOME/.config/kitty/theme.conf"
link kitty/bg.png "$HOME/.config/kitty/bg.png"
link herdr/config.toml "$HOME/.config/herdr/config.toml"
link nvim "$HOME/.config/nvim"
link pi/themes/claude.json "$HOME/.pi/agent/themes/claude.json"
