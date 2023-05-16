vim.filetype.add({
    extension = {
        zed = 'authzed',
    },
})

local treesitter_parser_ok, treesitter_parser = pcall(require, 'nvim-treesitter.parsers')
if not treesitter_parser_ok then
    return
end
treesitter_parser.get_parser_configs().authzed = {
    install_info = {
        url = "https://github.com/mleonidas/tree-sitter-authzed",
        files = { "src/parser.c" },
        generate_requires_npm = false,
        requires_generate_from_grammar = false,
        branch = "main",
    },
    filetype = "authzed",
}
