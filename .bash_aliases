#!/bin/bash

function realias() {
    source ~/.bash_aliases
    if [ -f ~/.bash_job ]; then
        source ~/.bash_job
    fi
}

if [ `uname` == 'Linux' ]; then
    alias ls='ls --color=auto'
else
    alias ls='ls -G'
fi

alias cd..='cd ..'

function gitRepack() {
    #ulimit -v 100000000
    git repack -a -d -f --window=10000 --depth=100 --window-memory=1500m
}

export FZF_DEFAULT_OPTS='--reverse --inline-info'

if [ -r `which nvim` ]; then
    alias vim=nvim
fi


