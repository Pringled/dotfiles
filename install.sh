#!/usr/bin/env bash
# Symlinks the configs in this repo into place. Anything already there is moved to <name>.backup-<time> first.
# Then installs what's missing from the Brewfile and pi/packages.txt, unless run with --no-install.
# Run with --dry-run to see what it would do.
set -euo pipefail

repo="$(cd "$(dirname "$0")" && pwd)"
dry_run=false
install=true
for arg in "$@"; do
  case "$arg" in
    --dry-run) dry_run=true ;;
    --no-install) install=false ;;
    *) echo "unknown option: $arg" >&2; exit 1 ;;
  esac
done
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
link zsh/shell.zsh "$HOME/.config/zsh/shell.zsh"
link atuin/config.toml "$HOME/.config/atuin/config.toml"
link hammerspoon/init.lua "$HOME/.hammerspoon/init.lua"
link zed/settings.json "$HOME/.config/zed/settings.json"

# delta's settings are included from ~/.gitconfig, so the rest of your git config stays yours
if git config --global --get-all include.path | grep -qxF "$repo/git/delta.gitconfig"; then
  echo "ok       ~/.gitconfig includes git/delta.gitconfig"
else
  echo "include  git/delta.gitconfig in ~/.gitconfig"
  run git config --global --add include.path "$repo/git/delta.gitconfig"
fi

if ! grep -qsF ".config/zsh/shell.zsh" "$HOME/.zshrc"; then
  echo "note     add this line to ~/.zshrc: source ~/.config/zsh/shell.zsh"
fi

if $install && command -v brew >/dev/null; then
  # Installs what's missing; tools you already have stay at their version
  echo "brew     bundle --no-upgrade --file=$repo/Brewfile"
  run brew bundle --no-upgrade --file="$repo/Brewfile"
fi

if $install && command -v pi >/dev/null; then
  # pi list creates Pi's folders, so it's skipped when Pi has no settings yet and nothing can be installed
  installed=""
  if [ -f "${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}/settings.json" ]; then
    installed=$(pi list | sed -e 's/^ *//' -e 's/ (filtered)$//')
  fi
  sed -e 's/#.*//' -e 's/[[:space:]]*$//' "$repo/pi/packages.txt" | grep . | while read -r package; do
    if grep -qxF "$package" <<<"$installed"; then
      echo "ok       pi package $package"
    else
      echo "pi       install $package"
      run pi install "$package"
    fi
  done
fi
