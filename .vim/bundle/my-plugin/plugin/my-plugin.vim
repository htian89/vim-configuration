" Function : AlternateColorColumn()
" Purpose  : Toggle of colorcolumn
" Args     : None
" Returns  : Nothing
" Author   : Hao Tian (herman.tian@outlook.com)
function! RunAndEchoCommand(cmd)
  execute ":!echo " . a:cmd . " && " . a:cmd
endfunction
function! AlternateColorColumn(...)
    if a:0 > 0
        let &colorcolumn = a:1 + 1
        set colorcolumn
    elseif &colorcolumn != 0
        set colorcolumn=0
    else
        set colorcolumn=81
    endif
endfunction

function! GrepWord(bang, ...)
  let cmd = "grep . -Irn --color --exclude=tags --exclude-dir=*.runfiles --exclude-dir=build64_* -e "
  if a:0 > 0
    let cmd = cmd . a:1
  else
    let cmd = cmd . expand("<cword>")
  endif
  call RunAndEchoCommand(cmd)
endfunction

function! GotoDefinition()
    let n = search("\\<".expand("<cword>")."\\>[^(]*([^)]*)\\s*\\n*\\s*{")
endfunction

function! CreateAndLoadCtags()
"  let cmd = "ctags -R --c++-kinds=+px --fields=+iaS --extra=+q"
  let cmd = "ctags -R --exclude=tags --exclude=*.js --exclude=build64_*"
  call RunAndEchoCommand(cmd)
  execute ":set tags=tags"
endfunction

comm! -nargs=? -bang CC call AlternateColorColumn(<f-args>)
nmap <Leader>cc :CC<CR>
comm! -nargs=? -bang Grep call GrepWord("<bang>", <f-args>)
comm! -nargs=? -bang Grepw call GrepWord("<bang>", <f-args>)
map <F8> :call GotoDefinition()<CR>
imap <F8> <c-o>:call GotoDefinition()<CR>
comm! -nargs=? -bang Ctags call CreateAndLoadCtags()
