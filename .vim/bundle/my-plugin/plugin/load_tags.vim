function! s:CheckAndAddTagFile(path)
  if s:StrEndWith(a:path, '/')
    let l:tags = a:path . 'tags'
  else
    let l:tags = a:path . '/tags'
  endif

  if stridx(&tags, l:tags) != -1
    return 0
  endif

  if !filereadable(l:tags)
    return 0
  endif

  let &tags =  len(&tags) == 0 ? l:tags : &tags . ',' . l:tags

  unlet! l:tags
  return 1
endfunction

function! s:StrEndWith(str, pattern)
  if strridx(a:str, a:pattern) == strlen(a:str) - strlen(a:pattern)
    return 1
  else
    return 0
  endif
endfunction

function! SplitPathReverse(path)
  let l:start = strlen(a:path)
  let l:list = []
  if !s:StrEndWith(a:path, '/')
    call add(l:list, a:path)
  endif

  while 1 == 1
    let l:idx = strridx(a:path, '/', l:start)
    let l:start = l:idx - 1

    if l:idx == -1
      break
    endif

    let l:part = a:path[0:(l:idx > 0 ? l:idx - 1 : l:idx)]
    call add(l:list, l:part)
  endwhile

  return l:list
endfunction

function! SplitPath(path)
  let l:start = 0
  let l:list = []

  while 1 == 1
    let l:idx = stridx(a:path, '/', l:start)
    let l:start = l:idx + 1

    if l:idx == -1
      break
    endif

    let l:part = a:path[0:(l:idx > 0 ? l:idx - 1 : l:idx)]
    call add(l:list, l:part)
  endwhile

  if !s:StrEndWith(a:path, '/')
    call add(l:list, a:path)
  endif

  return l:list
endfunction

function! AddTagsInCwdPath()
  let l:cwd = tr(expand('%:p:h'), '\', '/')

  let l:pathes = SplitPathReverse(l:cwd)

  for p in l:pathes
    if s:CheckAndAddTagFile(p)
      break
    endif
  endfor

endfunction

function! CreateAndLoadCtagsUnused(option)
  let l:tags_dir = expand("~/.vim/.ctags/")
  let l:cwd = getcwd()
  " Create ctags
  if a:option != "only load"
    if !isdirectory(l:tags_dir)
      call RunAndEchoCommand("mkdir -p " . l:tags_dir)
    endif
    let l:tags_path = l:tags_dir . substitute(l:cwd, "/", "_", "g")
    let cmd = "ctags -R --exclude=tags --exclude=*.js --exclude=build64_* -f "
      \. l:tags_path
    call RunAndEchoCommand(cmd)
  endif
  " Load ctags
  let l:tags_name = substitute(l:cwd, "/", "_", "g")
  let l:tags_path = l:tags_dir . l:tags_name
  if filereadable(l:tags_path)
    let &tags = l:tags_path
    return
  endif
  let l:pathes = SplitPath(l:cwd)
  for p in l:pathes
    let l:tags_name = substitute(p, "/", "_", "g")
    let l:tags_path = l:tags_dir . l:tags_name
    if filereadable(l:tags_path)
      let &tags = l:tags_path
      return
    endif
  endfor
  call AddTagsInCwdPath()
endfunction

function! FindFileInPathAndUpperPath(path, file)
  let l:pathes = SplitPathReverse(a:path)

  for p in l:pathes
    let l:file = ''
    if s:StrEndWith(a:path, '/')
      let l:file = p . a:file
    else
      let l:file = p . '/' . a:file
    endif
    if filereadable(l:file)
      return p
    endif
  endfor
  return -1
endfunction
