# dotfiles

My terminal and editor setup on macOS: [kitty](https://sw.kovidgoyal.net/kitty/), [herdr](https://herdr.dev), [Neovim](https://neovim.io) and a theme for the [pi](https://pi.dev) coding agent.

![kitty with herdr, pi and Neovim](https://raw.githubusercontent.com/Pringled/dotfiles/main/assets/setup.png)

## Install

```bash
git clone https://github.com/Pringled/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
./install.sh --dry-run   # shows what it will do
./install.sh
```

`install.sh` symlinks each config into place, so edits on either side show up in the repo. Anything already there is moved to `<name>.backup-<time>` first, and running it again changes nothing.

## What's in it

- **kitty** (`brew install --cask kitty`): JetBrains Mono, the Ayu Mirage colors, slanted tabs, no title bar, and a static gradient background (`bg.png`) instead of transparency, so the look doesn't depend on the window behind it.
- **herdr** (`brew install herdr`): transparent panels so kitty's background shows through, and brighter tab labels.
- **Neovim**: a Neovim 0.12 config for Python with pi in a side panel. See [`nvim/README.md`](nvim/README.md) for what's included and the key mappings.
- **pi theme**: `claude`, warm Claude Code-like colors with VS Code Dark+ syntax colors that match the Neovim colorscheme. Pick it with `/settings` in pi, or set `"theme": "claude"` in `~/.pi/agent/settings.json`. My pi extensions live in [pi-extensions](https://github.com/Pringled/pi-extensions).

## Tests

`tests/install.sh` runs the installer against throwaway home folders, `tests/configs.sh` checks that the kitty, herdr and pi configs parse (and the pi theme against pi's schema), and `tests/nvim.sh` installs the pinned plugins and starts Neovim. CI runs all three on every pull request.

## Author

Thomas van Dongen

## License

MIT
