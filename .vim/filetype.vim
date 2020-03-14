if exists("did_load_filetypes")
    finish
endif

" HTML (.shtml and .stm for server side)
au BufEnter,BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm  call s:FThtml()

" Distinguish between HTML, XHTML, HTML5, & Jinja
func! s:FThtml()
  let n = 1
  while n < 20 && n < line("$")
    if getline(n) =~ '{[%{]'
      setf jinja
      return
    endif
    let n = n + 1
  endwhile
  setf html
endfunc

augroup filetypedetect
    au!
    au BufEnter,BufRead,BufNewFile *bash* let b:is_bash = 1 | setfiletype sh

    " HTML (.shtml and .stm for server side)
    au BufEnter,BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm  call s:FThtml()

augroup END
