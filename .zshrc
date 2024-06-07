[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Base17 Shell
BASE16_SHELL="$HOME/.dotfiles/extras/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

if [ `uname` = "Linux" ]; then
    alias ls='ls --color=auto'
else
    alias ls='ls -G'
fi

alias cd..='cd ..'


if [ -r "$(which nvim)" ]; then
    alias vim=nvim
fi


export FZF_DEFAULT_OPTS='--reverse --inline-info'

stty ixany
stty ixoff -ixon
stty stop undef
stty start undef

function parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}


if [ -f ~/.zsh_job ]; then
    . ~/.zsh_job
fi

# User specific aliases and functions
function precmd() {
    local last_command="%?" # Must come first!
    PS1=""
    local red='%F{red}'
    local green='%F{green}'
    local yellow='%F{yellow}'
    local blue='%F{blue}'
    local purple='%F{purple}'
    local cyan='%F{cyan}'
    local white='%F{white}'
    local reset='%f%b'
    local fancyX='✘'
    local checkmark='✔'
    local triangle='▸'
    local circle='●'

    PS1+="$white%?%(?.$green$triangle.$red$triangle) "
    if [[ $EUID == 0 ]]; then
        PS1+="$red%m:"
    else
        PS1+="$green%n$yellow@$green%m:"
    fi
    PS1+="$blue%B%~%b "

    local bracketColor=$green
    type -t job_bracket_color &> /dev/null &&  bracketColor=$(job_bracket_color)

    local repo=`git rev-parse --show-toplevel 2> /dev/null`
    type -t job_prompt &> /dev/null && job_prompt || if [[ -e "$repo" ]]; then
        PS1+="$bracketColor($cyan$(bash -c 'git branch' | grep '\*' | tr -d '* ')$bracketColor)"
    fi

    PS1+="$green%# $reset"

}


if [ ! "$SETPATH" ] && [ -d ~/tools/bin ] ; then
    export SETPATH=1
    export PATH="$HOME/tools/bin:$PATH"
fi


export NINJA_STATUS="[%u/%r/%f]"


#if [ -r "$(`which nvim`)" ]; then
#    export EDITOR=nvim;
#else 
#    export EDITOR="vim -u ~/.emptyvimrc"
#fi

autoload -Uz compinit && compinit
autoload bashcompinit && bashcompinit
setopt AUTO_CD
setopt NO_CASE_GLOB
setopt EXTENDED_HISTORY
SAVEHIST=5000
HISTSIZE=2000
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST 
# do not store duplications
setopt HIST_IGNORE_DUPS
#ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# removes blank lines from history
setopt HIST_REDUCE_BLANKS
setopt CORRECT
setopt CORRECT_ALL


