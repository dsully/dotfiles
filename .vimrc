" plugins expect bash - not fish, zsh, etc
set shell=/bin/bash

" Load Pathogen https://github.com/tpope/vim-pathogen
" execute pathogen#infect()

" https://github.com/hdima/python-syntax
let python_highlight_all = 1

set rtp+=/usr/local/opt/fzf

syntax on
set term=xterm-color
set bs=2                " allow backspacing over everything in insert mode
set tw=160              " always limit the width of text to 78
set nobackup            " keep a backup file
set viminfo='20,\"50    " read/write a .viminfo file, don't store more than 50 lines
set ttyfast             " fast terminal connection
set magic               " changes special characters in search patterns
set esckeys             " allow use of cursor keys in insert mode

set showmatch           " match brackets
set showmode            " show on status line
set showbreak=>         " use at the start of wrapped lines
set ruler
set shortmess+=I        " Don't show intro screen

set nocompatible        " Use Vim defaults (much better!)
set backupskip=/tmp/*,/private/tmp/*"

" http://www.vim.org/htmldoc/change.html#fo-table
set formatoptions=crq

set comments=b:#,:%,:\",fb:-,nb:>,n:),n:\"

set tags=tags;/
"helptags ~/.vim/doc
fixdel

set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8

" http://stevelosh.com/blog/2010/09/coming-home-to-vim/
"nnoremap / /\v
"vnoremap / /\v
set ignorecase
set smartcase
set gdefault
set incsearch
set hlsearch

" Load matchit (% to bounce from do to end, etc.)
runtime! macros/matchit.vim

" Denote tabs with a double chevron and trailing spaces with a funny char
"set list listchars=tab:»·,trail:·

hi Comment    ctermfg=Blue
hi Constant   ctermfg=DarkGreen
hi Identifier ctermfg=Brown
hi PreProc    ctermfg=Red
hi Search     ctermbg=White
hi Special    ctermfg=LightBlue
hi Statement  ctermfg=DarkCyan
hi Visual     cterm=reverse ctermbg=NONE

"##############################################
" Macros

let mapleader = ","

map <leader>d :execute 'NERDTreeToggle ' . getcwd()<CR>

" Clear previous search
nnoremap <leader><space> :noh<cr>

" Strip file of whitespace.
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" Allow files to be determined by their filetype
filetype plugin indent on

" force \n
set fileformats=unix

" Formatting for most things. Override with 'no' if not needed.
set softtabstop=4
set shiftwidth=4
set smarttab expandtab autoindent smartindent

if version > 700
  setlocal spell spelllang=en_us
endif

" NEVER use folding
if version > 600
  set nofoldenable
endif

"##############################################

" Makefile sanity
autocmd FileType make set noexpandtab tabstop=8 shiftwidth=8
autocmd BufEnter */debian/rules set noexpandtab tabstop=8 shiftwidth=8

" diff files
au BufNewFile,BufRead diff set syntax=diff

" mib files may be different
au BufNewFile,BufRead *.my,*mibs/* set syntax=mib

" My syntax additions.
au BufRead,BufNewFile *.scala set filetype=scala
au BufRead,BufNewFile *.pig set filetype=pig
au BufRead,BufNewFile *.xs set filetype=xs
au BufRead,BufNewFile *.json set filetype=json
au BufRead,BufNewFile *.pdsc set filetype=json
au BufRead,BufNewFile *.rst set filetype=rest

au BufRead,BufNewFile *.avdl set filetype=avro-idl
au BufRead,BufNewFile *.avsc set filetype=json
au BufRead,BufNewFile *.gradle set filetype=groovy softtabstop=2 shiftwidth=2

" Tab stops & other per-file type setup.
autocmd FileType java,vim,avro-idl,json,rest   set softtabstop=2 shiftwidth=2
autocmd FileType html,html5,xhtml,xml,yaml     set softtabstop=2 shiftwidth=2

augroup python
    autocmd!
    let python_space_errors = 1
    let python_highlight_all = 1
    setlocal nospell
    set cinwords=if,elif,else,for,while,try,except,finally,def,class
augroup END

augroup ruby
    autocmd!
    let ruby_space_errors = 1
    setlocal nospell
augroup END

augroup cprog
    autocmd!

    autocmd FileType c,cpp map ,q :!boxes -d c-cmt<CR>
    autocmd FileType c,cpp map ,Q :!boxes -d c-cmt -r<CR>

    let c_space_errors = 1
    setlocal nospell
augroup END

augroup poundcomments
    autocmd FileType sh,bash,python,perl,ruby map ,q :!boxes -d pound-cmt<CR>
    autocmd FileType sh,bash,python,perl,ruby map ,Q :!boxes -d pound-cmt -r<CR>
augroup END

augroup javacomments
    autocmd FileType javascript,java map ,q :!boxes -d java-cmt<CR>
    autocmd FileType javascript,java map ,Q :!boxes -d java-cmt -r<CR>
    setlocal nospell
augroup END

" Show trailing whitepace and spaces before a tab:
:highlight ExtraWhitespace ctermbg=red guibg=red
:autocmd Syntax * syn match ExtraWhitespace /\s\+\%#\@<!$/ containedin=ALL

" https://github.com/dag/vim-fish
autocmd FileType fish compiler fish
autocmd FileType fish set softtabstop=4 shiftwidth=4

" Strip trailing writespace automatically.
"autocmd BufWritePre * :%s/\s\+$//e
autocmd BufWritePre *.py normal m`:%s/\s\+$//e
