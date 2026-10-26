# dotfiles

My terminal and editor setup on macOS: [kitty](https://sw.kovidgoyal.net/kitty/), [herdr](https://herdr.dev), [Neovim](https://neovim.io), a theme for the [pi](https://pi.dev) coding agent, and the shell tools and apps around them.

![kitty with herdr, pi and Neovim](https://raw.githubusercontent.com/Pringled/dotfiles/main/assets/setup.png)

## Install

```bash
git clone https://github.com/Pringled/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
./install.sh --dry-run   # shows what it will do
./install.sh
```

`install.sh` symlinks each config into place, so edits on either side show up in the repo. Anything already there is moved to `<name>.backup-<time>` first, and running it again changes nothing. It then installs everything in the [`Brewfile`](Brewfile) with Homebrew; pass `--no-brew` to skip that.

The shell setup is loaded from your own `~/.zshrc`, so add this line to it:

```zsh
source ~/.config/zsh/shell.zsh
```

## What's in it

- **kitty** (`brew install --cask kitty`): JetBrains Mono, the Ayu Mirage colors, slanted tabs, no title bar, and a static gradient background (`bg.png`) instead of transparency, so the look doesn't depend on the window behind it.
- **herdr** (`brew install herdr`): transparent panels so kitty's background shows through, and brighter tab labels.
- **Neovim**: a Neovim 0.12 config for Python with pi in a side panel. See [`nvim/README.md`](nvim/README.md) for what's included and the key mappings.
- **zsh** (`zsh/shell.zsh`): [atuin](https://atuin.sh) for history search, [zoxide](https://github.com/ajeetdsouza/zoxide) so `cd` jumps to folders you've visited, `ls` and `cat` through [eza](https://eza.rocks) and [bat](https://github.com/sharkdp/bat) (`ll` for a long list with git status, `lt` for newest last), kitty tabs named after the current folder, and a project's `.venv` activated when you `cd` into it.
- **git**: diffs side by side through [delta](https://github.com/dandavison/delta). `install.sh` includes `git/delta.gitconfig` from your `~/.gitconfig`, so the rest of it stays yours.
- **Hammerspoon** (optional): a soft focus lock. `ctrl+alt+l` locks the current app, and switching away sends you back with a reminder until you press it again.
- **pi theme**: `claude`, warm Claude Code-like colors with VS Code Dark+ syntax colors that match the Neovim colorscheme. Pick it with `/settings` in pi, or set `"theme": "claude"` in `~/.pi/agent/settings.json`. My pi extensions live in [pi-extensions](https://github.com/Pringled/pi-extensions).

## Tests

`tests/install.sh` runs the installer against throwaway home folders, `tests/configs.sh` checks that the configs and the Brewfile parse (and the pi theme against pi's schema), and `tests/nvim.sh` installs the pinned plugins and starts Neovim. CI runs all three on every pull request.

## Author

Thomas van Dongen

## License

MIT
