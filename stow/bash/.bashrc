[[ $- == *i* ]] || return 0
[[ -f /etc/bashrc ]] && source /etc/bashrc
export EDITOR=vim
command -v nvim >/dev/null && { alias vim=nvim; export EDITOR=nvim; }
export VISUAL="$EDITOR"
export FZF_DEFAULT_OPTS='--reverse --inline-info'
if command -v fzf >/dev/null; then
  eval "$(fzf --bash)"
fi
case "$(uname -s)" in
  Darwin) alias ls='ls -G' ;;
  *) alias ls='ls --color=auto' ;;
esac
alias cd..='cd ..'
[[ -r "$HOME/.bashrc.local" ]] && source "$HOME/.bashrc.local"
true
