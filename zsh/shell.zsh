# Shell setup to source from ~/.zshrc. install.sh links it to ~/.config/zsh/shell.zsh.

# History search on ctrl+r and the up arrow
command -v atuin >/dev/null && eval "$(atuin init zsh)"
# cd jumps to a matching folder you've visited before, such as `cd dotfiles`
command -v zoxide >/dev/null && eval "$(zoxide init zsh --cmd cd)"

alias n='nvim'
command -v bat >/dev/null && alias cat='bat --paging=never'
if command -v eza >/dev/null; then
  alias ls='eza'
  alias ll='eza -l --git'
  # Newest last, like ls -ltr
  alias lt='eza -l -s modified'
fi

autoload -Uz add-zsh-hook

# Names the kitty tab after the current folder
_kitty_tab_title() {
  [[ "$TERM" == "xterm-kitty" && -n "$KITTY_LISTEN_ON" ]] || return
  kitty @ set-tab-title "$(basename "$PWD")" >/dev/null 2>&1
}
add-zsh-hook chpwd _kitty_tab_title

# Activates the nearest .venv when you cd into a project, and deactivates it when you leave
typeset -g AUTO_VENV_ROOT=""
_find_venv_root() {
  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    [[ -f "$dir/.venv/bin/activate" ]] && { echo "$dir"; return 0; }
    dir="${dir:h}"
  done
  return 1
}
auto_venv() {
  local root
  if [[ -n "$VIRTUAL_ENV" && -n "$AUTO_VENV_ROOT" && "$PWD" != "$AUTO_VENV_ROOT"/* && "$PWD" != "$AUTO_VENV_ROOT" ]]; then
    type deactivate >/dev/null 2>&1 && deactivate
    AUTO_VENV_ROOT=""
  fi
  if [[ -z "$VIRTUAL_ENV" ]]; then
    root="$(_find_venv_root)" || return 0
    AUTO_VENV_ROOT="$root"
    source "$root/.venv/bin/activate"
  fi
}
add-zsh-hook chpwd auto_venv
auto_venv

# Activates ./.venv by hand
v() {
  if [[ -f .venv/bin/activate ]]; then
    source .venv/bin/activate
  else
    echo "No .venv found in $(pwd)"
  fi
}
