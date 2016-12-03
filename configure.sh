#!/bin/bash

plugins=(
Valloric/YouCompleteMe
jiangmiao/auto-pairs
davidhalter/jedi-vim
Shougo/neobundle.vim
Shougo/neocomplcache.vim
Shougo/neocomplete.vim
Shougo/neosnippet.vim
Shougo/neosnippet-snippets
honza/vim-snippets
scrooloose/nerdtree
Lokaltog/vim-powerline
klen/python-mode
majutsushi/tagbar
vim-airline/vim-airline-themes
vim-airline/vim-airline
tpope/vim-pathogen
fholgado/minibufexpl.vim
mhinz/vim-startify
vim-scripts/taglist.vim
)

github_ssh='git@github.com:'
github_https='https://github.com/'

function install() 
{
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
    
    ln -s $LOCAL/.vim $HOME/.vim
    ln -s $LOCAL/.vimrc $HOME/.vimrc
    echo "Link $LOCAL/.vim to $HOME/.vim"
    echo "Link $LOCAL/.vimrc to $HOME/.vimrc"
}

function uninstall()
{
    if [ -L $HOME/.vim ]; then
        echo "Remove .vim link"
        rm -f $HOME/.vim
    else
        echo "Not installed."
    fi

    if [ -L $HOME/.vimrc ]; then
        echo "Remove .vimrc link"
        rm -f $HOME/.vimrc
    fi

    if [ -e $HOME/.vim_bak ]; then
        mv $HOME/.vim_bak $HOME/.vim
        echo "Recover .vim_bak to $HOME/.vim"
    fi

    if [ -e $HOME/.vimrc_bak ]; then
        mv $HOME/.vimrc_bak $HOME/.vimrc
        echo "Recover .vimrc_bak to $HOME/.vimrc"
    fi
}

function add_submodule() {
    local plugins=$@;
    for plugin in ${plugins[@]}; do
        plugin_name=`echo ${plugin}|awk -F'/' '{print $2}'` 
        if [ -e .vim/bundle/${plugin_name} ]; then
            echo "${plugin_name} already exists"
        else
            git submodule add ${github_https}${plugin}.git .vim/bundle/${plugin_name}
        fi
    done
}

function checkout_submodule() {
    git submodule update --init --recursive 
    git checkout 
}

function usage()
{
    cat << HELP_END
./configure.sh [
    install         install vim configurations
    uninstall       uninstall vim configurations
    add_sub         add submodule
    co_sub          checkout submodules
HELP_END
}

LOCAL=`pwd`
#set -x

case $1 in
    install)
        install
    ;;
    uninstall)
        uninstall
    ;;
    add_sub)
        add_submodule ${plugins[@]}
    ;;
    co_sub)
        checkout_submodule $plugins
    ;;
    --help|-h|*)
        usage
    ;;
esac
