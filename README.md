# dotfiles

![kitty with herdr, Pi and Neovim](https://raw.githubusercontent.com/Pringled/dotfiles/main/assets/setup.png)

My macOS setup for coding with agents.

## What's in it

| Tool | What I use it for | Config |
|---|---|---|
| [kitty](https://sw.kovidgoyal.net/kitty/) | Terminal | [`kitty/`](kitty) |
| [herdr](https://herdr.dev) | Panes and tabs for agents | [`herdr/`](herdr) |
| [Neovim](https://neovim.io) | Editor, with Pi in a side panel | [`nvim/`](nvim), key mappings in [`nvim/README.md`](nvim/README.md) |
| [Pi](https://pi.dev) | Coding agent | [`pi/packages.txt`](pi/packages.txt) for the packages, [`pi/themes/claude.json`](pi/themes/claude.json) for the theme |
| zsh | Shell: history search with [atuin](https://atuin.sh), `cd` with [zoxide](https://github.com/ajeetdsouza/zoxide), `ls` with [eza](https://eza.rocks), `cat` with [bat](https://github.com/sharkdp/bat), `.venv` activation | [`zsh/shell.zsh`](zsh/shell.zsh), [`atuin/`](atuin) |
| git | Side-by-side diffs with [delta](https://github.com/dandavison/delta) | [`git/delta.gitconfig`](git/delta.gitconfig) |
| [Handy](https://handy.computer) | Push-to-talk dictation | |
| [Hammerspoon](https://www.hammerspoon.org) | Focus lock: `ctrl+alt+l` keeps you in the current app | [`hammerspoon/init.lua`](hammerspoon/init.lua) |

Everything is installed from the [`Brewfile`](Brewfile). My own Pi packages live in [pi-extensions](https://github.com/Pringled/pi-extensions).

## Install

```bash
git clone https://github.com/Pringled/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
./install.sh --dry-run   # shows what it will do
./install.sh
```

Then add this line to `~/.zshrc`:

```zsh
source ~/.config/zsh/shell.zsh
```

`install.sh` links each config into place, so edits on either side show up in the repo, and moves anything already there to `<name>.backup-<time>`. It then installs what's missing from the Brewfile and `pi/packages.txt`; `--no-install` skips that. Running it again changes nothing.

## Update

`git pull`, then `./install.sh` for any new tools or packages.

## Tests

`tests/install.sh` runs the installer in throwaway home folders, `tests/configs.sh` checks that the configs parse, and `tests/nvim.sh` installs the pinned Neovim plugins and starts Neovim. CI runs them on every pull request.

## Author

Thomas van Dongen

## License

MIT
