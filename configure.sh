#!/bin/bash

plugins=(
Valloric/YouCompleteMe
jiangmiao/auto-pairs
davidhalter/jedi-vim
Shougo/dein.vim
Shougo/neobundle.vim
Shougo/neocomplcache.vim
Shougo/neocomplete.vim
Shougo/deoplete.nvim
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
sysOS=`uname -s`
if [ $sysOS == "Darwin" ];then
	install_cmd='brew install'
	checkpkg_cmd='brew info'
elif [ $sysOS == "Linux" ];then
	install_cmd='sudo yum install -y'
	checkpkg_cmd='rpm -q'
else
	echo "Other OS: $sysOS"
fi

function execshell() {
  echo "[execshell]$@ begin."
  eval $@
  [[ $? != 0 ]] && {
    echo "[execshell]$@ failed."
      exit 1
    }
  echo "[execshell]$@ success."
  return 0
}

function command_exists() {
    type "$1" &> /dev/null ;
}

function link_target() {
  local targets=$@
  for target in ${targets[@]}; do
    if [ -e $HOME/${target} ]; then
      if [ -L $HOME/${target} ]; then
        echo "Remove old ${target} link"
        /bin/rm -f $HOME/${target}
      else
        echo "Move old ${target} to $HOME/${target}_bak"
        /bin/rm -rf $HOME/${target}_bak
        mv $HOME/${target} $HOME/${target}_bak
      fi
    fi
    ln -s $LOCAL/${target} $HOME/${target}
    echo "Link $LOCAL/${target} to $HOME/${target}"
  done
}

function package_check() {
  local packages=$@
  for pkg in ${packages[@]}; do
    ${checkpkg_cmd} ${pkg} &> /dev/null
    if [ $? -ne 0 ]; then
      list+=(${pkg})
    fi
  done
  if [ ${#list[@]} -ne 0 ]; then
    ${install_cmd} ${list[@]}
  fi
}

function install() {
  package_check epel-release the_silver_searcher ctags clang cmake gcc gcc-c++
  if command_exists clang-format; then
    echo "Dump clang format config to $HOME/.clang-format"
    clang-format --style=google --dump-config > $HOME/.clang-format
  else
    echo "Need clang"
    exit 1
  fi

  link_target .vim .vimrc

  cd $HOME/.vim/bundle/YouCompleteMe
  git submodule update --init --recursive
  ./install.py --clang-completer || exit 1
  cd -

  echo "#My-tools configurations" >> $HOME/.bash_profile
  echo "export PATH=\$HOME/.vim/my-tools:\$PATH" >> $HOME/.bash_profile
}

function install_zsh() {
  package_check "git zsh autojump autojump-fish autojump-zsh \
    the_silver_searcher ctags"

  sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

  execshell link_target ".zshrc"

  cd $HOME/.oh-my-zsh/custom/plugins/
  if [ ! -d zsh-autosuggestions ]; then
    git clone git://github.com/zsh-users/zsh-autosuggestions.git
  fi
  if [ ! -d zsh-syntax-highlighting ]; then
    git clone git://github.com/zsh-users/zsh-syntax-highlighting.git
  fi
  cd -
}

function install_cmake() {
  local CMAKE_VERSION="3.11.2"
  package_check "make wget"
  local pkg_name=cmake-$CMAKE_VERSION
  if [ ! -f $pkg_name.tar.gz ]; then
    execshell "wget https://cmake.org/files/v3.11/$pkg_name.tar.gz"
  fi
  if [ ! -f $pkg_name.tar.gz ]; then
    return 0
  fi

  if [ ! -d $pkg_name ]; then
    execshell "tar xvf $pkg_name.tar.gz"
  fi
  cd $pkg_name \
    && ./bootstrap --prefix=~/.vim/cmake \
    && make && make install \
    && cd - && rm -rf $pkg_name && rm -f $pkg_name.tar.gz
  if [ ! -L ~/.vim/my-tools/cmake ]; then
    ln -s ~/.vim/cmake/bin/cmake ~/.vim/my-tools/cmake
  fi
}

function download_vim() {
  cd ./.vim/
  if [ -d vim-source-code ]; then
    return 0
  fi
  centos_package_check "wget bzip2"
  wget https://ftp.nluug.nl/pub/vim/unix/vim-8.1.tar.bz2
  tar xvf vim-8.1.tar.bz2
  mv vim81 vim-source-code
}

#./configure --prefix=/usr --with-features=huge --enable-pythoninterp --enable-python3interp --disable-perlinterp --disable-tclinterp --with-x=no --enable-gui=no --enable-multibyte --enable-cscope
function build_vim() {
  package_check "cscope ncurses ncurses-devel ncurses-libs ncurses-base \
    python-libs ruby-devel python34 python34-pip python-devel python3-devel \
    python34-devel"
  cd $HOME/.vim/vim-source-code
  make distclean
  ./configure \
    --prefix=/usr \
    --enable-multibyte \
    --enable-rubyinterp \
    --enable-pythoninterp \
    --enable-python3interp \
    --with-python-config-dir=/usr/lib64/python2.7/config \
    --with-python3-config-dir=/usr/lib64/python3.4/config-3.4m \
    --enable-cscope \
    --enable-gui=auto \
    --with-features=huge \
    --enable-fontset \
    --enable-largefile \
    --disable-netbeans && make && make install DESTDIR=$HOME/.vim/vim-pkg
  cd -
}

function install_vim()
{
    echo "#Vim configurations" >> $HOME/.bash_profile
    echo "export VIMRUNTIME=\$HOME/.vim/vim-pkg/usr/share/vim/vim81" >> $HOME/.bash_profile
    echo "export LD_LIBRARY_PATH=\$LD_LIBRARY_PATH:\$HOME/.vim/vim-pkg/usr/lib64/:\$HOME/.vim/vim-pkg/usr/lib/" >> $HOME/.bash_profile
    /bin/rm -f $LOCAL/.vim/my-tools/vim
    ln -s $LOCAL/.vim/vim-pkg/usr/bin/vim $LOCAL/.vim/my-tools/vim
    /bin/rm -f $LOCAL/.vim/my-tools/vimdiff
    ln -s $LOCAL/.vim/vim-pkg/usr/bin/vimdiff $LOCAL/.vim/my-tools/vimdiff
}

function uninstall()
{
    if [ -L $HOME/.vim ]; then
        echo "Remove .vim link"
        /bin/rm -f $HOME/.vim
    else
        echo "Not installed."
    fi

    if [ -L $HOME/.vimrc ]; then
        echo "Remove .vimrc link"
        /bin/rm -f $HOME/.vimrc
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
    /bin/rm -f ../herman-vim.tar.gz
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
    install_zsh     install zsh
    install_cmake   install cmake
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
    install_zsh)
        execshell install_zsh
    ;;
    install_cmake)
        execshell install_cmake
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
