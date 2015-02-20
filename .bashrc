# .bashrc

if [ "$(tty)" != "not a tty" ]; then
    # Source global definitions
    if [ -f /etc/bashrc ]; then
        . /etc/bashrc
    fi

    if [ -f ~/.dotfiles/extras/base-16-sh/base16-pop.dark.sh ]; then
        . ~/.dotfiles/extras/base-16-sh/base16-pop.dark.sh
    fi

    if [ -f ~/.bash_job ]; then
        . ~/.bash_job
    fi

    stty ixany
    stty ixoff -ixon
    stty stop undef
    stty start undef

    function parse_git_branch() {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
    }

    # User specific aliases and functions
    function set_prompt () {
        local last_command=$? # Must come first!
        PS1=""
        local red='\[\e[00;31m\]'
        local redBold='\[\e[01;31m\]'
        local green='\[\e[00;32m\]'
        local greenBold='\[\e[01;32m\]'
        local yellow='\[\e[00;33m\]'
        local yellowBold='\[\e[00;33m\]'
        local blue='\[\e[00;34m\]'
        local blueBold='\[\e[01;34m\]'
        local purple='\[\e[00;35m\]'
        local purpleBold='\[\e[01;35m\]'
        local cyan='\[\e[00;36m\]'
        local cyanBold='\[\e[01;36m\]'
        local white='\[\e[00;37m\]'
        local whiteBold='\[\e[01;37m\]'
        local reset='\[\e[00m\]'
        local fancyX='\342\234\227'
        local checkmark='\342\234\223'
        local triangle='\342\200\243'
        local circle='\342\200\242'

        PS1+="$white\$?"
        if [[ $last_command == 0 ]]; then
           PS1+="$green$triangle "
        else
           PS1+="$red$triangle "
        fi
        if [[ $EUID == 0 ]]; then
           PS1+="$red\\h:"
        else
           PS1+="$green\\u$yellow@$green\\h:"
        fi
        PS1+="$blueBold\\w "

        local bracketColor=$green
        test job_bracket_color &> /dev/null &&  bracketColor=$(job_bracket_color)
       
        local repo=`git rev-parse --show-toplevel 2> /dev/null`
        test job_prompt &> /dev/null && job_prompt || if [[ -e "$repo" ]]; then
            PS1+="$bracketColor($cyan$(bash -c 'git branch' | grep '\*' | tr -d '* ')$bracketColor)"
        fi
         
        PS1+=" $green\\\$$reset "

    }
    PROMPT_COMMAND=set_prompt
#    PS1='\[\e[0;32m\]\u\[\e[m\]\[\e[0;33m\]@\[\e[m\]\[\e[0;32m\]\h\[\e[m\]\[\e[0;37m\]:\[\e[m\]\[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\e[0;37m\]'

    if [ ! "$SETPATH" ] && [ -d ~/tools/bin ] ; then
        export SETPATH=1
        export PATH="~/tools/bin:$PATH"
    fi

    export NINJA_STATUS="[%u/%r/%f]"

    export BASHRC=1

    # Load Aliases
    if [ -f ~/.bash_aliases ]; then
        . ~/.bash_aliases
    fi


fi

