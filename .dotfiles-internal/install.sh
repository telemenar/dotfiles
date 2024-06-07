#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/.dotfiles                    # dotfiles directory
olddir=~/.dotfiles_old             # old dotfiles backup directory
files="bashrc bash_aliases vimrc vim gitconfig tmux.conf zshrc"    # list of files/folders to symlink in homedir

##########

cd $dir

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks 
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$file $olddir
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

if [ `uname` = "Darwin" ]; then
    if [ ! $(which brew) ]; then
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    brew install bash bash-completion vim git the_silver_searcher ninja cmake
fi

cd $dir
git submodule init
git submodule sync
git submodule update

tic ./xterm-256color-italic.terminfo
tic ./screen-256color-italic.terminfo
tic ./tmux.terminfo

mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
ln -s ~/.vim $XDG_CONFIG_HOME/nvim

rm ~/.emptyvimrc
touch ~/.emptyvimrc

curl -fLo ~/.vim/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim +PlugInstall
