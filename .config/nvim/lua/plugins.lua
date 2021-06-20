-- Bootstrap Paq https://github.com/savq/paq-nvim

local install_path = vim.fn.stdpath('data')..'/site/pack/paqs/start/paq-nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.cmd('!git clone --depth 1 https://github.com/savq/paq-nvim.git '..install_path)
end

-- Load the plugin manager
vim.cmd [[packadd paq-nvim]]

local paq = require 'paq-nvim'

paq {
    -- Make paq manage it self
    'savq/paq-nvim';

    -- Plugin list
    'bash-lsp/bash-language-server';
    'shaunsingh/nord.nvim';
    'cespare/vim-toml';
    'dag/vim-fish';
    'famiu/nvim-reload';
    'glench/vim-jinja2-syntax';
    'hrsh7th/nvim-compe';
    'keith/swift.vim';
    'leafgarland/typescript-vim';
    {'lukas-reineke/indent-blankline.nvim', branch='lua'}; -- TODO use master branch when 0.5 is out
    'motus/pig.vim';
    {'nvim-treesitter/nvim-treesitter', run=':TSUpdate'};
    'nvim-treesitter/nvim-treesitter-textobjects';
    'nvim-treesitter/playground';
    'neovim/nvim-lspconfig';
    'nvim-treesitter/nvim-treesitter';
    'wsdjeg/vim-fetch';

    -- Dependencies for telescope.
    'nvim-lua/popup.nvim';
    'nvim-lua/plenary.nvim';
    'nvim-telescope/telescope.nvim';
}

-- Auto install and clean plugins
paq.install()
paq.clean()
