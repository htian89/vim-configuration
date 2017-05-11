" Function : AlternateColorColumn()
" Purpose  : Toggle of colorcolumn
" Args     : None
" Returns  : Nothing
" Author   : Hao Tian (herman.tian@outlook.com)
function! RunAndEchoCommand(cmd)
  execute ":!echo " . a:cmd . " && " . a:cmd
endfunction

function! RunAndEchoVimCommand(cmd)
  echo a:cmd
  execute ":" . a:cmd
endfunction

function! TestVimScript()
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

function! GrepWordOld(bang, ...)
  let cmd = "silent vimgrep /"
  if a:0 > 0
    let cmd = cmd . a:1
  else
    let cmd = cmd . expand("<cword>")
  endif
  let cmd = cmd . "/ **/*.cc **/*.h **/*.proto"
  call RunAndEchoVimCommand(cmd)
  call RunAndEchoVimCommand("botright cw")
endfunction

function! GrepWord(bang, ...)
  if a:0 > 0
    "let cmd = "Grepper " . join(a:000, ' ')
    call GrepWordOld(a:bang, a:1)
    return
  else
    let cmd = "Grepper -grepprg grep . -Irn --color --exclude=tags --exclude-dir=*.runfiles --exclude-dir=build64_* -e "
  endif
  call RunAndEchoVimCommand(cmd)
endfunction

function! AsyncGrepWord(bang, ...)
  let cmd = "AsyncRun grep . -Irn --color --exclude=tags --exclude-dir=*.runfiles --exclude-dir=build64_* -e "
  if a:0 > 0
    let cmd = cmd . a:1
  else
    let cmd = cmd . expand("<cword>")
  endif
  call RunAndEchoVimCommand(cmd)
endfunction

function! SearchGflag(bang, ...)
  if a:0 > 0
    let word = a:1
  else
    let word = expand("<cword>")
  endif
  if word[0:5] == 'FLAGS_'
    let cmd = '('. word[6:-1]
  else
    let cmd = 'FLAGS_' . word
  endif
  let n = search(cmd)
endfunction

function! GotoDefinition()
    let n = search("\\<".expand("<cword>")."\\>[^(]*([^)]*)\\s*\\n*\\s*{")
endfunction

function! CreateAndLoadCtags(option)
  let l:cwd = getcwd()
  let l:cpp_opt = '
    \ --languages=c++
    \ --c++-kinds=+px
    \ --fields=+aiKSz
    \ --extra=+q
    \'
  let l:retrieval_excludes = [
    \'*.js',
    \'*.o',
    \'lib*.so*',
    \'addsubmodule.sh',
    \'BLADE_ROOT',
    \'build64_release',
    \'build64_debug',
    \'external_interface',
    \'http_frame',
    \'mixer',
    \'OWNER',
    \'query_builder',
    \'servers',
    \'sh',
    \'sirius',
    \'sofa',
    \'text_analysis',
    \'thirdparty',
    \'word_vector_sim',
    \]
  let l:exclude_opt = ""
  for l:exclude in l:retrieval_excludes
    let l:exclude_opt = l:exclude_opt . ' --exclude=' . l:exclude
  endfor
  " Create ctags
  if a:option != "only load"
    let cmd = "AsyncRun ctags -R --exclude=*tags" . l:cpp_opt . l:exclude_opt
    call RunAndEchoVimCommand(cmd)
  endif
  " Load ctags
  call AddTagsInCwdPath()
endfunction

function! ClearVimWindow()
  if &number != 0
    execute ":set nonumber"
    execute ":TagbarClose"
  else
    execut ":set number"
    execute ":TagbarOpen"
  endif
endfunction

function! AlternateOpenFileUnderCursorWithIndex(splitWindow,...)
  let l:cursorFile = expand("<cfile>")
  if (a:0 > 0)
    let l:file = a:1 . "/". l:cursorFile
    let result = AlternateOpenFileUnderCursor(a:splitWindow, l:file)
    if result == "false"
      echo "Can't find file: " . l:file
    endif
  else
    let l:path_list = [
        \'..',
        \'build64_release',
        \'../build64_release',
        \'build64_debug',
        \'../build64_debug'
        \]
    let l:cwd = tr(expand('%:p:h'), '\', '/')
    let l:pathes = SplitPath(l:cwd)
    let l:pathes = l:path_list + l:pathes
    for p in l:pathes
      let l:file = p . "/" . l:cursorFile
      let result = AlternateOpenFileUnderCursor(a:splitWindow, l:file)
      if result == "true"
        return
      endif
    endfor
    echo "Can't find file"
  endif
endfunction

function! OpenFileWithGrepResult(...)
  if a:0 > 0
    let l:colon1 = stridx(a:1, ':')
    if l:colon1 == -1
      return
    endif
    let l:colon2 = stridx(a:1, ':', l:colon1 + 1)
    let l:file = a:1[0:(l:colon1 > 0 ? l:colon1 - 1 : 0)]
    let l:line = a:1[(l:colon1 + 1):(l:colon2 > 0 ? l:colon2 - 1 : -1)]
    let l:cmd = "e +" . l:line . " " . l:file
    call RunAndEchoVimCommand(l:cmd)
  endif
endfunction

function! SetErrorFormat()
  let l:pwd = system('pwd')[:-2]
  let l:path = FindFileInPathAndUpperPath(l:pwd, 'BLADE_ROOT')
  let l:part = l:pwd[strlen(l:path) + 1 : -1]
  if strlen(l:part)
    let l:part = l:part . '/'
  endif
  let &errorformat = l:part . '%f:%l:\ error:\ %m'
  set errorformat
  set errorformat+=%f:%l:\ undefined\ reference\ to\ %m
endfunction

" Use to test vim script
comm! -nargs=? -bang Test call TestVimScript()
" Colorcolumn toggle
comm! -nargs=? -bang CC call AlternateColorColumn(<f-args>)
" nmap <Leader>cc :CC<CR>
" Global search word
comm! -nargs=? -bang Grep call GrepWord("<bang>", <f-args>)
comm! -nargs=? -bang Grepw call GrepWord("<bang>", <f-args>)
comm! -nargs=? -bang Agrep call AsyncGrepWord("<bang>", <f-args>)
" Search Gflag
comm! -nargs=? -bang SF call SearchGflag("<bang>", <f-args>)
" Unused command, copy from internet
map <F8> :call GotoDefinition()<CR>
imap <F8> <c-o>:call GotoDefinition()<CR>
" Create and load ctags
comm! -nargs=? -bang Ctags call CreateAndLoadCtags("")
" Clear and recover vim window
comm! -nargs=? -bang Clear call ClearVimWindow()
" Open the file which under cursor
comm! -nargs=? -bang UH call AlternateOpenFileUnderCursorWithIndex("n<bang>", <f-args>)
comm! -nargs=? -bang UHS call AlternateOpenFileUnderCursorWithIndex("h<bang>", <f-args>)
comm! -nargs=? -bang UHV call AlternateOpenFileUnderCursorWithIndex("v<bang>", <f-args>)
comm! -nargs=? -bang UHT call AlternateOpenFileUnderCursorWithIndex("t<bang>", <f-args>)
comm! -nargs=1 -bang E call OpenFileWithGrepResult(<f-args>)
