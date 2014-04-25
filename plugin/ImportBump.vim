scriptencoding utf-8

" check if script is already loaded
if exists("g:loaded_ImportBump")
  finish "stop loading the script"
endif
let g:loaded_ImportBump = 1

if !exists('g:move_map_keys')
  let g:move_map_keys = 1
endif



function! s:MoveLineUp(count) range
  let distance = a:count + 1

  if v:count > 0
    let distance = distance + v:count - 1
  endif

  if (line('.') - distance) < 0
    execute 'silent m 0'
    if (g:move_auto_indent == 1)
      normal! ==
    endif
    return
  endif

  execute 'silent m-' . distance

  if (g:move_auto_indent == 1)
    normal! ==
  endif
endfunction

" Find the last import at the top of the file
function! s:FindLastImport()
  let curr = 1
  let lastLineFound = 0
  let done = 0

  while curr <= line('$') && !done
    let line = getline(curr)
    if line =~ "^import"
      "echo line
      let lastLineFound = curr
    endif
    if line =~ "^class" || line =~ "^object"
      let done = 1
    endif
    let curr = curr + 1
  endwhile

  return lastLineFound
endfunction

function! s:BumpImport() 
  let lineOfLastImport = s:FindLastImport()
  echo lineOfLastImport
endfunction



nnoremap <silent> <Plug>BumpImport   :call <SID>BumpImport()<CR>

if g:move_map_keys
  execute 'nmap <Leader>oo <Plug>BumpImport'
endif
