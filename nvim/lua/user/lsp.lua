local mason_ok, mason = pcall(require, 'mason')
if not mason_ok then
    return
end

local mason_lspconfig_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
if not mason_lspconfig_ok then
    return
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if cmp_nvim_lsp_ok then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

local telescope_builtin_ok, telescope_builtin = pcall(require, 'telescope.builtin')
if not telescope_builtin_ok then
    return
end

local on_attach = function(_, bufnr)
    local nmap = function(lhs, rhs, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end
        vim.keymap.set('n', lhs, rhs, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gr', telescope_builtin.lsp_references, '[G]oto [R]eferences')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('gtd', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>ds', telescope_builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', telescope_builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    -- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    local lsp_augroup = vim.api.nvim_create_augroup('lsp', { clear = false })
    vim.api.nvim_clear_autocmds({ group = lsp_augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd('BufWritePre', {
        group = lsp_augroup,
        buffer = bufnr,
        callback = function() vim.lsp.buf.format() end,
    })
end

local server_settings = {
    bufls = {},
    gopls = {},
    jsonls = {},
    lua_ls = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
    rust_analyzer = {},
    sqlls = {},
    taplo = {},
    terraformls = {},
    tsserver = {},
    vimls = {},
    yamlls = {},
}

mason.setup()
mason_lspconfig.setup({
    ensure_installed = vim.tbl_keys(server_settings),
})

mason_lspconfig.setup_handlers({
    function(server_name)
        require('lspconfig')[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = server_settings[server_name],
        })
    end,
})

vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
