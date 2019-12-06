" Function : AlternateColorColumn()
" Purpose  : Toggle of colorcolumn
" Args     : None
" Returns  : Nothing
" Author   : Hao Tian (herman.tian@outlook.com)

" local defines
let g:huichuan_excludes = [
      \'"wolong"',
      \'"trigger_server"',
      \'"ad_server"',
      \'"app_ad_server*"',
      \'"brand_server"',
      \'"trigger_server"',
      \'"pub/src/huichuan"',
      \'"pub/src/i18n_huichuan"',
      \]

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

function! s:ConstructSearchCommand(tool)
  if a:tool == "grep"
    let l:cmd = "grep . -Irn --color --exclude=tags "
          \ . "--exclude-dir=*.runfiles --exclude-dir=build64_* "
          \ . "--exclude-dir=blade-bin -e "
  elseif a:tool == "ag"
    let l:cmd = "ag --vimgrep -s --noaffinity --ignore-dir=tags "
          \ . "--ignore-dir=build64_* --ignore-dir=*.runfiles "
          \ . "--ignore-dir=blade-bin "
    for l:exclude in g:huichuan_excludes
      let l:cmd = l:cmd . ' --ignore-dir=' . l:exclude
    endfor
  endif
  return l:cmd
endfunction

" Global search word
function! GrepWord(bang, ...)
  let cmd = "Grepper -tool ag -grepprg " . s:ConstructSearchCommand("ag") . " "
        \ . join(a:000, ' ')
  call RunAndEchoVimCommand(cmd)
endfunction
comm! -nargs=? -bang Grep call GrepWord("<bang>", "--cpp", "--hh", <f-args>)
comm! -nargs=? -bang Greph call GrepWord("<bang>", "--hh", <f-args>)
comm! -nargs=? -bang Grepp call GrepWord("<bang>", "--proto", <f-args>)
comm! -nargs=? -bang Grepw call GrepWord("<bang>", <f-args>)
let t_ignore_path = "--ignore-dir=ad_server_v2 --ignore-dir=media_server --ignore-dir=exchange_server"
comm! -nargs=? -bang TGrep call GrepWord("<bang>", t_ignore_path, "--cpp", <f-args>)
let a_ignore_path = "--ignore-dir=trigger_server_v2 --ignore-dir=media_server --ignore-dir=exchange_server"
comm! -nargs=? -bang AGrep call GrepWord("<bang>", a_ignore_path, "--cpp", <f-args>)
let e_ignore_path = "--ignore-dir=trigger_server_v2 --ignore-dir=media_server --ignore-dir=ad_server_v2"
comm! -nargs=? -bang EGrep call GrepWord("<bang>", e_ignore_path, "--cpp", <f-args>)
let m_ignore_path = "--ignore-dir=trigger_server_v2 --ignore-dir=exchange_server --ignore-dir=ad_server_v2"
comm! -nargs=? -bang MGrep call GrepWord("<bang>", m_ignore_path, "--cpp", <f-args>)

function! AsyncGrepWord(bang, ...)
  let cmd = "AsyncRun " . s:ConstructSearchCommand("ag")
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
  let l:common_excludes = [
    \'"*.js"',
    \'"*.o"',
    \'"lib*.so*"',
    \'"*.sh"',
    \'"*.py"',
    \'"Makefile"',
    \]
  let l:retrieval_excludes = [
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
    \'output',
    \]
  let l:exclude_opt = ""
  for l:exclude in l:common_excludes
    let l:exclude_opt = l:exclude_opt . ' --exclude=' . l:exclude
  endfor
  for l:exclude in l:retrieval_excludes
    let l:exclude_opt = l:exclude_opt . ' --exclude=' . l:exclude
  endfor
  for l:exclude in g:huichuan_excludes
    let l:exclude_opt = l:exclude_opt . ' --exclude=' . l:exclude
  endfor
  " Create ctags
  if a:option != "only load"
    let cmd = "AsyncRun ctags -R --exclude=tags" . l:cpp_opt . l:exclude_opt
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
  let l:cmd = ""
  let l:args = split(a:1)
  for l:i in l:args
    let l:colon1 = stridx(l:i, ':')
    if l:colon1 == -1
      if filereadable(l:i)
        let l:cmd = "e " . l:i
        break
      endif
    else
      let l:colon2 = stridx(l:i, ':', l:colon1 + 1)
      let l:file = l:i[0:(l:colon1 > 0 ? l:colon1 - 1 : 0)]
      if !filereadable(l:file)
        continue
      endif
      let l:line = l:i[(l:colon1 + 1):(l:colon2 > 0 ? l:colon2 - 1 : -1)]
      let l:cmd = "e +" . l:line . " " . l:file
    endif
  endfor
  call RunAndEchoVimCommand(l:cmd)
endfunction

function! SetErrorFormat()
  let l:pwd = system('pwd')[:-2]
  let l:path = FindFileInPathAndUpperPath(l:pwd, 'BLADE_ROOT')
  if l:path == -1
    let l:part = ""
  else
    let l:part = l:pwd[strlen(l:path) + 1 : -1]
    if strlen(l:part)
      let l:part = l:part . '/'
    endif
  endif
  let &errorformat =
        \ l:part . '%f:%l:%c:\ error:\ %m' .
        \ ',' . l:part . '%f:%l:\ error:\ %m' .
        \ ',./' . l:part . '%f:%l:%c\ error:\ %m' .
        \ ',./' . l:part . '%f:%l:\ error:\ %m' .
        \ ',' . l:part . '%f:%l:\ Failure' .
        \ ',%f:%l:\ undefined\ reference\ to\ %m'
endfunction

function! GotoJump()
  jumps
  let j = input("Please select your jump: ")
  if j != ''
    let pattern = '\v\c^\+'
    if j =~ pattern
      let j = substitute(j, pattern, '', 'g')
      execute "normal " . j . "\<c-i>"
    else
      execute "normal " . j . "\<c-o>"
    endif
  endif
endfunction
nmap <Leader>jp :call GotoJump()<CR>

" Use to test vim script
comm! -nargs=? -bang Test call TestVimScript()
" Colorcolumn toggle
comm! -nargs=? -bang CC call AlternateColorColumn(<f-args>)
" nmap <Leader>cc :CC<CR>
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

" Set fugitive plugin
"command! -bang -nargs=* -complete=file Make "AsyncRun -program=make @ <args>"
function! MakeCommand(...)
  execute ":copen"
  execute ":AsyncRun -program=make " . join(a:000)
endfunction
comm! -nargs=? -bang Make call MakeCommand(<f-args>)
""""""""""""""""""""""""""""""""""""""""""""""""""""""
