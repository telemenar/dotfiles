# Homebrew must be available before completion, language tools, and prompt setup.
if [[ -z ${HOMEBREW_PREFIX:-} ]]; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi
typeset -U path fpath
path=("$HOME/.local/bin" $path)
[[ -d "$HOME/tools/bin" ]] && path=("$HOME/tools/bin" $path)
if [[ -n ${HOMEBREW_PREFIX:-} ]]; then
  [[ -d "$HOMEBREW_PREFIX/share/zsh-completions" ]] && fpath=("$HOMEBREW_PREFIX/share/zsh-completions" $fpath)
fi
autoload -Uz compinit bashcompinit
compinit
bashcompinit
[[ $OSTYPE == darwin* ]] && alias ls='ls -G' || alias ls='ls --color=auto'
alias cd..='cd ..'
if (( $+commands[nvim] )); then
  alias vim=nvim
  export EDITOR=nvim VISUAL=nvim
else
  export EDITOR=vim VISUAL=vim
fi
export FZF_DEFAULT_OPTS='--reverse --inline-info'
if [[ -t 0 && -t 1 ]] && (( $+commands[fzf] )); then
  source <(fzf --zsh)
elif [[ -t 0 && -t 1 && -r "$HOME/.fzf.zsh" ]]; then
  source "$HOME/.fzf.zsh"
fi
if [[ -t 0 ]]; then
  stty ixany ixoff -ixon stop undef start undef
fi
export NINJA_STATUS='[%u/%r/%f]'
setopt AUTO_CD NO_CASE_GLOB EXTENDED_HISTORY SHARE_HISTORY APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS HIST_FIND_NO_DUPS HIST_REDUCE_BLANKS
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
export PYENV_ROOT="$HOME/.pyenv"
[[ -d "$PYENV_ROOT/bin" ]] && path=("$PYENV_ROOT/bin" $path)
(( $+commands[pyenv] )) && eval "$(pyenv init - zsh)"
# JDK selection is owned by the private work profile, not Jenv.
if [[ -r "$HOME/.config/work-setup/shell/work.zsh" ]]; then
  source "$HOME/.config/work-setup/shell/work.zsh"
elif [[ -r "$HOME/.zsh_job" ]]; then
  source "$HOME/.zsh_job"
fi
PS1=' %~ $ '
if [[ -t 0 && -t 1 && ${TERM_PROGRAM:-} == iTerm.app && -r "${HOMEBREW_PREFIX:-}/share/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  source "$HOMEBREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme"
  [[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
fi
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
if [[ -x "$HOME/.claude/hooks/tab-chroma/tab-chroma.sh" ]]; then
  alias tab-chroma='"$HOME/.claude/hooks/tab-chroma/tab-chroma.sh"'
  claude() {
    command claude "$@"
    local command_exit=$?
    "$HOME/.claude/hooks/tab-chroma/tab-chroma.sh" reset >/dev/null 2>&1
    return "$command_exit"
  }
fi
# Syntax highlighting is loaded after other widgets and keybindings.
[[ -t 0 && -t 1 && -r "${HOMEBREW_PREFIX:-}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
true
