augroup poundcomments
    autocmd FileType sh,bash,python,perl,ruby map ,q :!boxes -d pound-cmt<CR>
    autocmd FileType sh,bash,python,perl,ruby map ,Q :!boxes -d pound-cmt -r<CR>
augroup END

augroup htmlcomments
    autocmd FileType html map ,q :!boxes -d java-cmt<CR>
    autocmd FileType html map ,Q :!boxes -d java-cmt -r<CR>
augroup END

augroup luacomments
    autocmd FileType lua map ,q :!boxes -d ada-cmt<CR>
    autocmd FileType lua map ,Q :!boxes -d ada-cmt -r<CR>
augroup END

augroup javacomments
    autocmd FileType javascript,java map ,q :!boxes -d java-cmt<CR>
    autocmd FileType javascript,java map ,Q :!boxes -d java-cmt -r<CR>
augroup END
