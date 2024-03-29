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
            { 'j-hui/fidget.nvim', config = true },
            {
                'folke/neodev.nvim',
                opts = {
                    library = { plugins = { 'neotest' }, types = true },
                },
                dependencies = {
                    'nvim-neotest/neotest',
                },
            },
        },
    },

    -- testing
    -- {
    --     'nvim-neotest/neotest',
    --     dependencies = {
    --         'nvim-lua/plenary.nvim',
    --         'nvim-treesitter/nvim-treesitter',
    --         'antoinemadec/FixCursorHold.nvim',
    --         'nvim-neotest/neotest-go',
    --     },
    --     config = function()
    --         local neotest_ns = vim.api.nvim_create_namespace('neotest')
    --         vim.diagnostic.config({
    --             virtual_text = {
    --                 format = function(diagnostic)
    --                     return diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
    --                 end,
    --             },
    --         }, neotest_ns)
    --         require('neotest').setup({
    --             adapters = {
    --                 require('neotest-go')({
    --                     args = { '-timeout=120s' },
    --                 }),
    --             },
    --         })
    --     end,
    -- },

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
    {
        'folke/trouble.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {},
    },

    -- file browser
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
    },

    -- appearance
    'airblade/vim-gitgutter',
    'nvim-lualine/lualine.nvim',
    'onsails/lspkind.nvim',
    {
        'rcarriga/nvim-notify',
        config = function() vim.notify = require('notify') end,
    },
    'ribru17/bamboo.nvim',
    -- 'srcery-colors/srcery-vim',

    -- treesitter
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

    -- Git
    'tpope/vim-fugitive',

    -- legacy
    -- { 'fatih/vim-go',                    build = ':GoUpdateBinaries' },
    -- 'dag/vim-fish',
    -- 'hashivim/vim-terraform',
    -- 'uarun/vim-protobuf',
    -- 'rust-lang/rust.vim',
})
