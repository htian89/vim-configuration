" VIM configuration
set nu
set autoindent
set smarttab
set tabstop=2
set shiftwidth=2
set expandtab
set pastetoggle=<F9>
set hls
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set backspace=indent,eol,start
set fileformat=unix
set makeprg=rbuild\ $*
set splitright
set viminfo='1000,f1
"set errorformat=%f:%l:\ error:\ %m

" Syntax highlight enable
syntax on
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Restore cursor to file position in previous editing session
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set YouCompeleteMe plugin
" 自动补全配置
set completeopt=longest,menu
"让Vim的补全菜单行为与一般IDE一致(参考VimTip1228)
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
"离开插入模式后自动关闭预览窗口
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
"回车即选中当前项
"上下左右键的行为 会显示其他信息
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" :
"\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" :
"\<PageUp>"

"youcompleteme  默认tab  s-tab 和自动补全冲突
"let g:ycm_key_list_select_completion=['<c-n>']
let g:ycm_key_list_select_completion = ['<Down>']
"let g:ycm_key_list_previous_completion=['<c-p>']
let g:ycm_key_list_previous_completion = ['<Up>']
let g:ycm_confirm_extra_conf=0 "关闭加载.ycm_extra_conf.py提示
let g:ycm_key_list_stop_completion = ['<CR>']

let g:ycm_collect_identifiers_from_tags_files=1 " 开启 YCM 基于标签引擎
let g:ycm_min_num_of_chars_for_completion=1 "从第1个键入字符就开始罗列匹配项
let g:ycm_cache_omnifunc=0  " 禁止缓存匹配项,每次都重新生成匹配项
let g:ycm_seed_identifiers_with_syntax=1  " 语法关键字补全
nnoremap <F5> :YcmForceCompileAndDiagnostics<CR>  "force recomile with syntastic
"nnoremap <leader>lo :lopen<CR> "open locationlist
"nnoremap <leader>lc :lclose<CR>  "close locationlist
inoremap <leader><leader> <C-x><C-o>
"在注释输入中也能补全
let g:ycm_complete_in_comments = 1
"在字符串输入中也能补全
let g:ycm_complete_in_strings = 1
"注释和字符串中的文字也会被收入补全
let g:ycm_collect_identifiers_from_comments_and_strings = 0

nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR> "
"跳转到定义处"
let g:ycm_server_python_interpreter='/usr/bin/python'
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
" 补全候选项的最小字符数
let g:ycm_min_num_identifier_candidate_chars = 0
" 关闭诊断显示功能(已经使用了ale进行异步语法检查)
let g:ycm_show_diagnostics_ui = 0
" 在用户接受提供的完成字符串后自动关闭窗口
let g:ycm_autoclose_preview_window_after_completion = 1
" 自动触发语义补全
let g:ycm_semantic_triggers =  {
            \ 'c,cc,cpp,python,java,go,erlang,perl': ['re!\w{1}'],
            \ 'cs,lua,javascript': ['re!\w{1}'],
            \ }
" 遇到下列文件时才会开启YCM
"let g:ycm_filetype_whitelist = {
"            \ "c":1,
"            \ "cc":1,
"            \ "cpp":1,
"            \ "python":1,
"            \ "sh":1,
"            \ }
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

" Set tagbar plugin
let g:tagbar_width = 80
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
let g:airline_theme='base16color'
" 打开tabline功能,方便查看Buffer和切换,省去了minibufexpl插件
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
" 关闭状态显示空白符号计数
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#whitespace#symbol = '!'
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set neosnippet plugin
" Plugin key-mappings.
imap <Leader>k     <Plug>(neosnippet_expand_or_jump)
smap <Leader>k     <Plug>(neosnippet_expand_or_jump)
xmap <Leader>k     <Plug>(neosnippet_expand_target)

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
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets,
      \ ~/.vim/bundle/my-plugin/neosnippets'


" Load my snippets
" autocmd BufEnter * :NeoSnippetSource ~/.vim/bundle/my-plugin/neosnippets/jd.snip
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set fugitive plugin
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set Grepper
let g:grepper = {}
let g:grepper.stop = 1000
let g:grepper.highlight = 1
let g:grepper.switch = 1
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set vimmake plugin
let g:vimmake_mode = {}
let g:vimmake_mode['make'] = 'async'
let g:vimmake_mode['run'] = 'async'
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set clang format plugin
let g:clang_format#style_options = {
            \ "AccessModifierOffset" : -4,
            \ "AllowShortIfStatementsOnASingleLine" : "true",
            \ "AlwaysBreakTemplateDeclarations" : "true",
            \ "Standard" : "C++11"}

" map to <Leader>cf in C++ code
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
" if you install vim-operator-user
autocmd FileType c,cpp,objc map <buffer><Leader>x <Plug>(operator-clang-format)
" Toggle auto formatting:
nmap <Leader>C :ClangFormatAutoToggle<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set Conque plugin
let g:ConqueGdb_SrcSplit = 'left'
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Neobundle
" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif

if &compatible
  set nocompatible               " Be iMproved
endif

if 0
  " Required:
  " Add the dein installation directory into runtimepath
  set runtimepath+=~/.vim/bundle/dein.vim/
  call dein#begin('~/.vim/bundle/')
  call dein#add('Shougo/dein.vim')
  call dein#add('Shougo/my-plugin')
  call dein#add('Shougo/blade')
  if (version > 704 || (version == 704 && has('patch143'))) && (has('python') || has('python3'))
    call dein#add('Shougo/YouCompleteMe')
    "call dein#add('Shougo/neocomplcache.vim')
  elseif has('lua')
    call dein#add('Shougo/neocomplete.vim')
  else
    call dein#add('Shougo/neocomplcache.vim')
  endif
  call dein#add('Shougo/deoplete.nvim')
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')
  if has('conceal') && has('python')
    call dein#add('Shougo/jedi-vim')
  else
    call dein#add('Shougo/python-mode')
  endif
  call dein#add('Shougo/auto-pairs')
  call dein#add('Shougo/nerdtree')
  call dein#add('Shougo/vim-pathogen')
  " call dein#add('Shougo/minibufexpl.vim')
  call dein#add('Shougo/tagbar')
  call dein#add('Shougo/vim-airline')
  call dein#add('Shougo/vim-airline-themes')
  call dein#add('Shougo/vim-startify')
  call dein#add('Shougo/asyncrun.vim')
  call dein#add('Shougo/vimmake')
  call dein#add('Shougo/errormarker.vim')
  call dein#add('Shougo/vim-fugitive')
  call dein#add('Shougo/vim-grepper')
  call dein#add('Shougo/Conque-GDB')
  call dein#add('Shougo/vim-operator-user')
  call dein#add('Shougo/vim-clang-format')

  call dein#end()
  call dein#save_state()

else

  " Let NeoBundle manage NeoBundle
  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
  call neobundle#begin(expand('~/.vim/bundle/'))
  NeoBundleFetch 'Shougo/neobundle.vim'

  " My Bundles here:
  " Refer to |:NeoBundle-examples|.
  " Note: You don't set neobundle setting in .gvimrc!
  NeoBundle 'Shougo/my-plugin'
  NeoBundle 'Shougo/blade'
  if (version > 704 || (version == 704 && has('patch143'))) && (has('python') || has('python3'))
    NeoBundle 'Shougo/YouCompleteMe'
    "NeoBundle 'Shougo/neocomplcache.vim'
  elseif has('lua')
    NeoBundle 'Shougo/neocomplete.vim'
  else
    NeoBundle 'Shougo/neocomplcache.vim'
  endif
  NeoBundle 'Shougo/deoplete.nvim'
  NeoBundle 'Shougo/neosnippet.vim'
  NeoBundle 'Shougo/neosnippet-snippets'
  if has('conceal') && has('python')
    NeoBundle 'Shougo/jedi-vim'
  else
    " NeoBundle 'Shougo/python-mode'
  endif
  NeoBundle 'Shougo/auto-pairs'
  NeoBundle 'Shougo/nerdtree'
  NeoBundle 'Shougo/vim-pathogen'
  " NeoBundle 'Shougo/minibufexpl.vim'
  NeoBundle 'Shougo/tagbar'
  NeoBundle 'Shougo/vim-airline'
  NeoBundle 'Shougo/vim-airline-themes'
  NeoBundle 'Shougo/vim-startify'
  NeoBundle 'Shougo/asyncrun.vim'
  NeoBundle 'Shougo/vimmake'
  NeoBundle 'Shougo/errormarker.vim'
  NeoBundle 'Shougo/vim-fugitive'
  NeoBundle 'Shougo/vim-grepper'
  NeoBundle 'Shougo/Conque-GDB'
  NeoBundle 'Shougo/vim-operator-user'
  NeoBundle 'Shougo/vim-clang-format'

  call neobundle#end()
  " If there are uninstalled bundles found on startup,
  " this will conveniently prompt you to install them.
  NeoBundleCheck
  """"""""""""""""""""""""""""""""""""""""""""""""""""""
endif

" Required:
filetype plugin indent on

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Auto open some plugins. TODO: May not take effect.
autocmd! BufWritePost '.vimrc' exec 'source '.$HOME.'/.vimrc'

""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Get file name
let f_n = expand("%:t")
if f_n == "BUILD"
  set tabstop=4
  set shiftwidth=4
endif
" Get file type
let f_t = expand("%:e")
" Auto load tags
if f_t == "cc" || f_t == "h" || f_t == "c" || f_t == "py" || f_t == "cpp"
  if !filereadable("./tags")
    autocmd VimEnter * call CreateAndLoadCtags("only load")
  endif
  autocmd VimEnter * call SetErrorFormat()
endif
" Auto open Tagbar and Colorcolumn
if f_t == "cc" || f_t == "h" || f_t == "c" || f_t == "py" || f_t == "vim"
    \ || f_t == "sh" || f_t == "txt" || f_t == "cpp"
  " Auto remove trailing space
  " autocmd BufReadPost * :%s/\s\+$//e
  autocmd BufWritePre * :%s/\s\+$//e
  " Auto remove trailing ^M
  " autocmd BufReadPost * :%s/\^M$//e
  " Open tag bar
  " autocmd VimEnter * TagbarOpen
  " Open colorcolumn
  autocmd VimEnter * CC
endif
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Map some specific keys for shortcuts
" Normal Mode
" Key for taglist plugin
nnoremap tt :TagbarToggle<CR>
nnoremap ff :w<CR>

" Key for NerdTree plugin
nnoremap <C-n> :NERDTreeToggle<CR>

" Quickfix
nmap <F6> :cn<cr>
nmap <F7> :cp<cr>
noremap <silent><F10> :call vimmake#toggle_quickfix(6)<cr>
noremap <Leader>q :call vimmake#toggle_quickfix(6)<cr>

" If you like control + vim direction key to navigate
" windows then perform the remapping
"
nnoremap <C-J>     <C-W>j
nnoremap <C-K>     <C-W>k
nnoremap <C-H>     <C-W>h
nnoremap <C-L>     <C-W>l

" If you like control + arrow key to navigate windows
" then perform the remapping
"
nnoremap <C-Down>  <C-W>j
nnoremap <C-Up>    <C-W>k

" If you like <C-Left> and <C-Right> to switch buffers
" in the current window then perform the remapping
"
nnoremap <C-Left>  :bp<CR>
nnoremap <C-Right> :bn<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Visual Mode


" Insert Mode
" inoremap <C-i> <Left>
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
inoremap <S-Tab> <BS>
inoremap <C-b> <BS>
inoremap <C-d> <Del>

" Choose colorscheme
colorscheme desert
" colorscheme default
" 设置高亮行和列
" set cursorcolumn
" set cursorline
" 设置高亮效果
" highlight CursorLine   cterm=NONE ctermbg=black ctermfg=green guibg=NONE guifg=NONE
" highlight CursorColumn cterm=NONE ctermbg=black ctermfg=green guibg=NONE guifg=NONE
" Modify some color of the scheme
" Set comment color
" highlight Comment term=bold ctermfg=lightGray guifg=gray guibg=black
set hlsearch
hi Search ctermbg=LightYellow
hi Search ctermfg=Red
""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup filetype
    autocmd! BufRead,BufNewFile BUILD set filetype=blade
augroup end
