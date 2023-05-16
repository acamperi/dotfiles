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
        'make',
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

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.authzed = {
    install_info = {
        url = "https://github.com/mleonidas/tree-sitter-authzed",
        files = { "src/parser.c" },
        generate_requires_npm = false,
        requires_generate_from_grammar = false,
        branch = "main",
    },
    filetype = "authzed",
}
