#!/usr/bin/env bash
# Runs install.sh against throwaway home folders and checks the links and backups it leaves behind.
set -euo pipefail

repo="$(cd "$(dirname "$0")/.." && pwd)"
targets=(.config/kitty/kitty.conf .config/kitty/theme.conf .config/kitty/bg.png .config/herdr/config.toml .config/nvim .pi/agent/themes/claude.json .config/zsh/shell.zsh .config/atuin/config.toml .hammerspoon/init.lua .config/zed/settings.json .config/zed/keymap.json)

fail() { echo "FAIL: $*" >&2; exit 1; }
check_links() {
  for t in "${targets[@]}"; do
    [ -L "$1/$t" ] || fail "$t is not a symlink"
    [ -e "$1/$t" ] || fail "$t points nowhere"
  done
}

home=$(mktemp -d)
trap 'rm -rf "$home"' EXIT

# A dry run changes nothing
HOME="$home" "$repo/install.sh" --dry-run >/dev/null
[ -z "$(ls -A "$home")" ] || fail "dry run created files"

# A fresh home gets every link
HOME="$home" "$repo/install.sh" --no-install >/dev/null
check_links "$home"
git config --file "$home/.gitconfig" --get-all include.path | grep -q "git/delta.gitconfig" || fail "delta settings not included in .gitconfig"

# Running again changes nothing
out=$(HOME="$home" "$repo/install.sh" --no-install)
[ "$(grep -c '^ok' <<<"$out")" = "$((${#targets[@]} + 1))" ] || fail "second run was not a no-op"
[ "$(git config --file "$home/.gitconfig" --get-all include.path | grep -c delta)" = 1 ] || fail "delta was included twice"

# Existing configs are backed up, not overwritten
rm -rf "$home" && mkdir -p "$home/.config/kitty" "$home/.config/nvim"
echo "mine" > "$home/.config/kitty/kitty.conf"
echo "mine" > "$home/.config/nvim/init.lua"
HOME="$home" "$repo/install.sh" --no-install >/dev/null
check_links "$home"
grep -q mine "$home"/.config/kitty/kitty.conf.backup-* || fail "kitty.conf was not backed up"
grep -q mine "$home"/.config/nvim.backup-*/init.lua || fail "nvim config was not backed up"

echo "install.sh: all checks passed"
