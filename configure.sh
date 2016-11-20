#!/bin/bash

if [ -e $HOME/.vim ]; then
    if [ -L $HOME/.vim ]; then
        echo "Remove old .vim link"
        rm -f $HOME/.vim
    else
        echo "Move old .vim to $HOME/.vim_bak"
        rm -rf $HOME/.vim_bak
        mv $HOME/.vim $HOME/.vim_bak
    fi
fi

if [ -e $HOME/.vimrc ]; then
    if [ -L $HOME/.vimrc ]; then
        echo "Remove old .vimrc link."
        rm -f $HOME/.vimrc
    else
        echo "Move old .vimrc to $HOME/.vimrc_bak"
        rm -f $HOME/.vimrc_bak
        mv $HOME/.vimrc $HOME/.vimrc_bak
    fi
fi

LOCAL=`pwd`

set -x
ln -s $LOCAL/.vim $HOME/.vim
ln -s $LOCAL/.vimrc $HOME/.vimrc
