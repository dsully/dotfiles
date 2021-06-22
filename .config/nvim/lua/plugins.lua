-- Bootstrap Packer: https://github.com/wbthomason/packer.nvim

local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.api.nvim_command 'packadd packer.nvim'
end

return require('packer').startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use 'bash-lsp/bash-language-server'
    use 'cespare/vim-toml'
    use 'dag/vim-fish'
    use 'famiu/nvim-reload'
    use 'folke/lua-dev.nvim'
    use 'glench/vim-jinja2-syntax'
    use 'hrsh7th/nvim-compe';
    use 'keith/swift.vim'
    use 'kosayoda/nvim-lightbulb'
    use 'leafgarland/typescript-vim'
    use 'lukas-reineke/format.nvim'
    use 'motus/pig.vim'
    use 'neovim/nvim-lspconfig'
    use 'nvim-treesitter/nvim-treesitter-textobjects'
    use 'nvim-treesitter/playground'
    use 'shaunsingh/nord.nvim'
    use 'wsdjeg/vim-fetch'

    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use {'lukas-reineke/indent-blankline.nvim', branch='lua'} -- TODO use master branch when 0.5 is out

    -- Floating windows are awesome :)
    use 'rhysd/git-messenger.vim'

    use {
        'hoob3rt/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons', opt = true}
    }

    use {
        'nvim-telescope/telescope.nvim', requires={
            'nvim-lua/popup.nvim',
            'nvim-lua/plenary.nvim',
        }
    }

    use {
        'williamboman/nvim-lsp-installer'
    }

    -- Use dependency and run lua function after load
    use {
        'lewis6991/gitsigns.nvim', requires={
            'nvim-lua/plenary.nvim'
        },
        config=function() require('gitsigns').setup() end
    }
end)
