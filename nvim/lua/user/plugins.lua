local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

local lazy_ok, lazy = pcall(require, 'lazy')
if not lazy_ok then
    return
end

return lazy.setup({
    'wbthomason/packer.nvim',

    -- editing
    'FooSoft/vim-argwrap',
    'jiangmiao/auto-pairs',
    { 'numToStr/Comment.nvim',                    opts = {} },
    'tpope/vim-repeat',
    'tpope/vim-sleuth',
    'tpope/vim-surround',

    -- LSP
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            { 'j-hui/fidget.nvim', opts = {} },
            { 'folke/neodev.nvim', opts = {} },
        },
    },

    -- autocomplete
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-nvim-lsp',
            {
                'L3MON4D3/LuaSnip',
                opts = {},
                dependencies = { 'rafamadriz/friendly-snippets' },
            },
            'saadparwaiz1/cmp_luasnip',
        },
    },

    -- search
    {
        'nvim-telescope/telescope.nvim',
        version = '*',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },

    -- file browser
    {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons',
        },
    },

    -- appearance
    'airblade/vim-gitgutter',
    'srcery-colors/srcery-vim',
    'vim-airline/vim-airline',
    'vim-airline/vim-airline-themes',

    -- treesitter
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

    -- Git
    'tpope/vim-fugitive',

    -- language-specific plugins
    { 'fatih/vim-go',                    build = ':GoUpdateBinaries' },
    -- 'dag/vim-fish',
    -- 'hashivim/vim-terraform',
    -- 'uarun/vim-protobuf',
    -- 'rust-lang/rust.vim',
})
