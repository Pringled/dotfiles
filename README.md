# dotfiles

![kitty with herdr, Pi and Neovim](https://raw.githubusercontent.com/Pringled/dotfiles/main/assets/setup.png)

My macOS setup for coding with agents.

## What's in it

### Terminal and agents

| Tool                                      | What I use it for                                                               | Config            |
| ----------------------------------------- | ------------------------------------------------------------------------------- | ----------------- |
| [kitty](https://sw.kovidgoyal.net/kitty/) | Terminal emulator, with some customizations                                     | [`kitty/`](kitty) |
| [herdr](https://herdr.dev)                | Terminal multiplexer, for running several agents side by side in panes and tabs | [`herdr/`](herdr) |
| [Pi](https://pi.dev)                      | Coding agent, with the extensions I use                                         | [`pi/`](pi)       |

### Editing

| Tool                        | What I use it for                                             | Config          |
| --------------------------- | ------------------------------------------------------------- | --------------- |
| [Neovim](https://neovim.io) | Quick edits directly in my terminal so I don't have to switch | [`nvim/`](nvim) |
| [Zed](https://zed.dev)      | IDE for longer coding sessions and manual edits               | [`zed/`](zed)   |

### Shell

| Tool                                                            | What I use it for                                                    | Config            |
| --------------------------------------------------------------- | -------------------------------------------------------------------- | ----------------- |
| zsh                                                             | Shell, with aliases and a project's `.venv` activated on `cd`        | [`zsh/`](zsh)     |
| [atuin](https://atuin.sh)                                       | Shell history search                                                 | [`atuin/`](atuin) |
| [zoxide](https://github.com/ajeetdsouza/zoxide)                 | Jumping to folders I've visited                                      |                   |
| [eza](https://eza.rocks), [bat](https://github.com/sharkdp/bat) | Nicer `ls` and `cat`                                                 |                   |
| git                                                             | Side-by-side diffs with [delta](https://github.com/dandavison/delta) | [`git/`](git)     |

### Around it

| Tool                            | What I use it for                                                   | Config |
| ------------------------------- | ------------------------------------------------------------------- | ------ |
| [Obsidian](https://obsidian.md) | Second brain that my agents read and update through a `brain` skill |        |
| [Handy](https://handy.computer) | Dictating prompts with a push-to-talk key                           |        |

Everything is installed from the [`Brewfile`](Brewfile). My own Pi packages live in [pi-extensions](https://github.com/Pringled/pi-extensions).

<details>
<summary>Shortcuts</summary>

| Where  | Keys                  | What it does                                    |
| ------ | --------------------- | ----------------------------------------------- |
| Handy  | `option+space`        | Dictate: hold to talk, or tap to start and stop |
|        | `option+shift+space`  | Dictate with post-processing                    |
|        | `esc`                 | Cancel                                          |
| zsh    | `ctrl+r`, `↑`         | Search shell history (atuin)                    |
|        | `cd <part of a name>` | Jump to a folder you've visited (zoxide)        |
|        | `ll`, `lt`            | Long list with git status, newest last          |
|        | `n`, `v`              | Open Neovim, activate `./.venv`                 |
| Neovim |                       | See [`nvim/README.md`](nvim/README.md)          |

kitty and herdr use their default keys.

</details>

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

## Author

Thomas van Dongen

## License

MIT
