-- Options --

vim.opt.backup = false
vim.opt.comments = 'b:#,:%,:\",fb:-,nb:>,n:),n:\"'  
vim.opt.completeopt = "menuone,noselect"
vim.opt.expandtab = true
vim.opt.fileformats = 'unix'                       -- force \n
vim.opt.foldenable = false
vim.opt.formatoptions = 'crq'                      -- http://www.vim.org/htmldoc/change.html#fo-table
vim.opt.guicursor = 'a:blinkon10'                  -- Blink the cursor.
vim.opt.ignorecase = true
vim.opt.shell = 'sh'                               -- plugins expect bash - not fish, zsh, etc
vim.opt.shiftwidth = 4
vim.opt.showbreak = '>'
vim.opt.showmatch = true                           -- Match brackets
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.softtabstop = 4
vim.opt.termguicolors = true
vim.opt.textwidth = 160
vim.opt.undofile = true

-- Mappings --

vim.g.mapleader = ','

-- Copy and paste with system clipboard
vim.api.nvim_set_keymap('v', '<C-c>', '"+y',    {noremap = true})
vim.api.nvim_set_keymap('i', '<C-v>', '<C-r>+', {noremap = true})

-- Plugins & plugin configs --

require('plugins')
require('configs.theme')
require('configs.lsp')
require('configs.tree-sitter')
require('configs.vim-compe')
