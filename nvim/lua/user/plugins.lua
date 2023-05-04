local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if not vim.loop.fs_stat(install_path) then
    PACKER_BOOTSTRAP = vim.fn.system({
        'git',
        'clone',
        '--depth',
        '1',
        'https://github.com/wbthomason/packer.nvim',
        install_path,
    })
    print("Bootstrapping packer, close and reopen Neovim.")
    vim.cmd.packadd('packer.nvim')
end

local packer_user_config = vim.api.nvim_create_augroup('packer_user_config', {clear = true})
vim.api.nvim_create_autocmd('BufWritePost', {
    pattern = 'packer_init.lua',
    group = packer_user_config,
    callback = function() vim.cmd([[source <afile> | PackerSync]]) end,
})

local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

return packer.startup(function(use)
    use 'wbthomason/packer.nvim'

    -- editing
    use 'FooSoft/vim-argwrap'
    use 'jiangmiao/auto-pairs'
    use {
        'numToStr/Comment.nvim',
        config = function() require('Comment').setup() end,
    }
    use 'tpope/vim-repeat'
    use 'tpope/vim-sleuth'
    use 'tpope/vim-surround'

    -- appearance
    use 'airblade/vim-gitgutter'
    use 'srcery-colors/srcery-vim'
    use 'vim-airline/vim-airline'
    use 'vim-airline/vim-airline-themes'

    -- LSP
    use {
        'neovim/nvim-lspconfig',
        requires = {
            {'williamboman/mason.nvim', run = ':MasonUpdate'},
            'williamboman/mason-lspconfig.nvim',
            {
                'j-hui/fidget.nvim',
                config = function() require('fidget').setup() end,
            },
            {
                'folke/neodev.nvim',
                config = function() require('neodev').setup() end,
            },
        },
    }

    -- autocomplete
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
        },
    }

    -- search
    use '/usr/local/opt/fzf'
    use 'junegunn/fzf.vim'

    -- file browser
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons',
        },
    }

    -- Git
    use 'tpope/vim-fugitive'

    -- language-specific plugins
    use { 'fatih/vim-go', run = ':GoUpdateBinaries' }
    -- use 'dag/vim-fish'
    -- use 'hashivim/vim-terraform'
    -- use 'uarun/vim-protobuf'
    -- use 'rust-lang/rust.vim'

    if PACKER_BOOTSTRAP then
        require('packer').sync()
    end
end)
