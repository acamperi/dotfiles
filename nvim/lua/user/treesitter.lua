local treesitter_configs_ok, treesitter_configs = pcall(require, 'nvim-treesitter.configs')
if not treesitter_configs_ok then
    return
end

treesitter_configs.setup({
    ensure_installed = {
        'c',
        'css',
        'fish',
        'git_config',
        'go',
        'gomod',
        'gosum',
        'lua',
        'proto',
        'python',
        'rust',
        'sql',
        'starlark',
        'terraform',
        'toml',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
    },
    sync_install = false,
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
        disable = { 'css', 'python' },
    },
})
