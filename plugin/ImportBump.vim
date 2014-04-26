scriptencoding utf-8

" check if script is already loaded
if exists("g:loaded_ImportBump")
  finish "stop loading the script"
endif
let g:loaded_ImportBump = 1

if !exists('g:move_map_keys')
  let g:move_map_keys = 1
endif

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
  if getline(".") =~ "import"
    let currentLine = line(".")
    
    " Remove leading white space
    let clean = substitute(getline('.'), '^\s*\(.\{-}\)\s*$', '\1', '')
    call setline('.', clean)
    
    let lineOfLastImport = s:FindLastImport()
    
    " Move to line after lineOfLastImport
    execute "silent m " . lineOfLastImport
    call cursor(currentLine, 0) 
  else
    echo "You can only push import statements"
  endif
endfunction


nnoremap <silent> <Plug>BumpImport   :call <SID>BumpImport()<CR>

if g:move_map_keys
  execute 'nmap <Leader>oo <Plug>BumpImport'
endif
