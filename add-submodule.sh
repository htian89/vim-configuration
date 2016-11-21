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

LOCAL=`pwd`

set -x
for plugin in ${plugins[@]}
do
    plugin_name=`echo ${plugin}|awk -F'/' '{print $2}'` 
    git submodule add ${github_ssh}${plugin}.git .vim/bundle/${plugin_name}
done
