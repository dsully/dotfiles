augroup cprog
    autocmd!

    autocmd FileType c,cpp map ,q :!boxes -d c-cmt<CR>
    autocmd FileType c,cpp map ,Q :!boxes -d c-cmt -r<CR>

    let c_space_errors = 1
augroup END
