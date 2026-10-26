#!/usr/bin/env bash
# Checks that the configs parse, and that the pi theme matches pi's theme schema.
set -euo pipefail

repo="$(cd "$(dirname "$0")/.." && pwd)"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

python3 -c 'import sys, tomllib; tomllib.load(open(sys.argv[1], "rb"))' "$repo/herdr/config.toml"
echo "herdr: config.toml parses"
python3 -c 'import sys, tomllib; tomllib.load(open(sys.argv[1], "rb"))' "$repo/atuin/config.toml"
echo "atuin: config.toml parses"
git config --file "$repo/git/delta.gitconfig" --list >/dev/null
echo "git: delta.gitconfig parses"
ruby -c "$repo/Brewfile" >/dev/null
echo "brew: Brewfile parses"
python3 -m json.tool "$repo/zed/settings.json" >/dev/null
echo "zed: settings.json parses"

if command -v zsh >/dev/null; then
  zsh -n "$repo/zsh/shell.zsh"
  echo "zsh: shell.zsh parses"
else
  echo "zsh: not installed, skipped"
fi

curl -fsSL https://pi.dev/schemas/theme.schema.json -o "$tmp/theme.schema.json"
uvx --quiet check-jsonschema --schemafile "$tmp/theme.schema.json" "$repo/pi/themes/claude.json"
echo "pi: theme matches pi's theme schema"

if command -v kitty >/dev/null; then
  # kitty reports unknown options as warnings and bad values as errors; treat both as failures
  out=$(kitty +runpy 'from kitty.config import load_config; import sys; load_config(sys.argv[-1])' "$repo/kitty/kitty.conf" 2>&1)
  [ -z "$out" ] || { echo "$out" >&2; exit 1; }
  echo "kitty: kitty.conf loads cleanly"
else
  echo "kitty: not installed, skipped"
fi
