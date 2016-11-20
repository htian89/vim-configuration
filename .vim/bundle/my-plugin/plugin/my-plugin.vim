" Function : AlternateColorColumn()
" Purpose  : Toggle of colorcolumn
" Args     : None
" Returns  : Nothing
" Author   : Hao Tian (herman.tian@outlook.com)
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

function! GrepWord(...)
    if a:0 > 0
        execute ":!grep * -Irn --color --exclude=tags -e "a:1""
    else
        let searchWord = expand("<cword>")
        execute ":!grep * -Irn --color --exclude=tags -e "searchWord""
    endif
endfunction

function! GotoDefinition()
  let n = search("\\<".expand("<cword>")."\\>[^(]*([^)]*)\\s*\\n*\\s*{")
endfunction

comm! -nargs=? -bang CC call AlternateColorColumn(<f-args>)
nmap <Leader>cc :CC<CR>
comm! -nargs=? -bang Grep call GrepWord(<f-args>)
map <F8> :call GotoDefinition()<CR>
imap <F8> <c-o>:call GotoDefinition()<CR>
