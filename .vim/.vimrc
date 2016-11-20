" VIM configuration
set nu
set autoindent
set smarttab
set tabstop=4
set shiftwidth=4
set expandtab
set pastetoggle=<F9>
set hls
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set backspace=indent,eol,start

" Syntax highlight enable
syntax on
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set python mode plugin
" Don't autofold code
let g:pymode_folding = 0 
" Disable colorcolumn display at max_line_length
let g:pymode_options_colorcolumn = 0
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set taglist plugin
" Open the taglist window on the right hand side
let Tlist_Use_Right_Window = 1 
" Other setting
let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Sort_Type = "name"
let Tlist_Auto_Open = 0
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set neocomplete plugin
" Enable at startup
let g:neocomplete#enable_at_startup = 1
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set neocomplcache plugin
" Enable at startup
let g:neocomplcache_enable_at_startup = 1
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set vim-airline plugin
" Set airlien theme
" let g:airline_theme='base16color'
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set neosnippet plugin
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1

" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Neobundle
" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif

if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.vim/bundle/neobundle.vim/

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!
NeoBundle 'Shougo/my-plugin'
if (version > 704 || (version == 704 && has('patch143'))) && (has('python') || has('python3'))
    NeoBundle 'Shougo/YouCompleteMe'
elseif has('lua')
    NeoBundle 'Shougo/neocomplete'
else
    NeoBundle 'Shougo/neocomplcache'
endif
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
if has('conceal')
    NeoBundle 'Shougo/jedi-vim'
else
    NeoBundle 'Shougo/python-mode'
endif
NeoBundle 'Shougo/auto-pairs'
NeoBundle 'Shougo/nerdtree'
NeoBundle 'Shougo/vim-pathogen'
NeoBundle 'Shougo/vim-plugin-minibufexpl'
NeoBundle 'Shougo/vim-taglist-plus'
NeoBundle 'Shougo/tagbar'
"NeoBundle 'Shougo/vim-airline'
"NeoBundle 'Shougo/vim-airline-themes'
NeoBundle 'Shougo/vim-startify'

call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Auto open Tagbar
autocmd VimEnter * TagbarOpen
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Map some specific keys for shortcuts
" Key for taglist plugin
noremap tt :TagbarToggle<CR>
noremap ff :w<CR>

" Key for NerdTree plugin
noremap <C-n> :NERDTreeToggle<CR>

" Other keys
" noremap ff :w<CR>
" noremap <F5> :!ctags -R --c++-kinds=+px --fields=+iaS --extra=+q<CR><CR>:TlistUpdate<CR>
cnoremap Ctags :!ctags -R<CR><CR>:set tags=tags<CR>
" noremap <F6> :!grep * -Irn --color --exclude=tags -e ""<Left>
" cnoremap Grep :!grep * -Irn --color --exclude=tags -e "<C-R>=expand("<cword>")<CR>"<CR>

inoremap <S-Tab> <BS>
inoremap <C-b> <BS>
inoremap <C-d> <Del>

" If you like control + vim direction key to navigate
" windows then perform the remapping
"
noremap <C-J>     <C-W>j
noremap <C-K>     <C-W>k
noremap <C-H>     <C-W>h
noremap <C-L>     <C-W>l

" If you like control + arrow key to navigate windows
" then perform the remapping
"
noremap <C-Down>  <C-W>j
noremap <C-Up>    <C-W>k

" If you like <C-Left> and <C-Right> to switch buffers
" in the current window then perform the remapping
"
noremap <C-Left>  :bp<CR>
noremap <C-Right> :bn<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Choose colorscheme
colorscheme peachpuff
" Modify some color of the scheme
" Set comment color
highlight Comment term=bold ctermfg=lightGray guifg=lightGray
""""""""""""""""""""""""""""""""""""""""""""""""""""""
