" Show trailing whitepace and spaces before a tab:
:highlight ExtraWhitespace ctermbg=red guibg=red
:autocmd Syntax * syn match ExtraWhitespace /\s\+\%#\@<!$/ containedin=ALL

" Strip trailing writespace automatically.
"autocmd BufWritePre * :%s/\s\+$//e
autocmd BufWritePre *.py normal m`:%s/\s\+$//e
