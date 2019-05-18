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
skywind3000/asyncrun.vim
skywind3000/vimmake
vim-scripts/errormarker.vim
tpope/vim-fugitive
mhinz/vim-grepper
vim-scripts/Conque-GDB
rhysd/vim-clang-format
kana/vim-operator-user
)

github_ssh='git@github.com:'
github_https='https://github.com/'

function command_exists() {
    type "$1" &> /dev/null ;
}

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

    if command_exists clang-format; then
      echo "Dump clang format config to $HOME/.clang-format"
      clang-format --style=google --dump-config > $HOME/.clang-format
    else
      echo "Can not find clang-format"
    fi

    ln -s $LOCAL/.vim $HOME/.vim
    ln -s $LOCAL/.vimrc $HOME/.vimrc
    echo "Link $LOCAL/.vim to $HOME/.vim"
    echo "Link $LOCAL/.vimrc to $HOME/.vimrc"

    echo "#My-tools configurations" >> $HOME/.bash_profile
    echo "export PATH=\$HOME/.vim/my-tools:\$PATH" >> $HOME/.bash_profile

    cd $HOME/.vim/bundle/YouCompleteMe
    ./install.py --clang-completer
    cd -
}

function build_vim()
{
    cd $HOME/.vim/vim-source-code
    ./configure --prefix=/usr --with-features=huge --enable-pythoninterp --enable-python3interp --disable-perlinterp --disable-tclinterp --with-x=no --enable-gui=no --enable-multibyte --enable-cscope
    make
    make install DESTDIR=$HOME/.vim/vim-pkg
}

function install_vim()
{
    echo "#Vim configurations" >> $HOME/.bash_profile
    echo "export VIMRUNTIME=\$HOME/.vim/vim-pkg/usr/share/vim/vim80" >> $HOME/.bash_profile
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$HOME/.vim/vim-pkg/usr/lib64/:\$HOME/.vim/vim-pkg/usr/lib/" >> $HOME/.bash_profile
    rm -f $HOME/.vim/my-tools/vim
    ln -s $HOME/.vim/vim-pkg/usr/bin/vim $HOME/.vim/my-tools/vim
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

function update_submodule() {
    git submodule update --init --remote
}

function create_archive() {
    rm -f ../herman-vim.tar.gz
    tar zcvf ../herman-vim.tar.gz --exclude=.vim/bundle/YouCompleteMe --exclude=.vim/vim-pkg * .vim*
    temp_path=`pwd`
    echo 'Create archive:'
    echo ${temp_path%/*}'/herman-vim.tar.gz'
    echo 'Package size: '`du -sh ../herman-vim.tar.gz`
}

function usage()
{
    cat << HELP_END
./configure.sh [
    install         install vim configurations
    uninstall       uninstall vim configurations
    build_vim       build vim
    install_vim     install vim
    add_sub         add submodule
    co_sub          checkout submodules
    up_sub          update submodules
    tar             Compress documents to archive
HELP_END
}

LOCAL=`pwd`
#set -x

case $1 in
    install)
        install
    ;;
    install_vim)
        install_vim
    ;;
    build_vim)
        build_vim
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
    up_sub)
        update_submodule $plugins
    ;;
    tar)
        create_archive
    ;;
    --help|-h|*)
        usage
    ;;
esac
