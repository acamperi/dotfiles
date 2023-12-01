local mason_ok, mason = pcall(require, 'mason')
if not mason_ok then
    return
end

local mason_lspconfig_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
if not mason_lspconfig_ok then
    return
end

-- augment LSP capabilities with completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if cmp_nvim_lsp_ok then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

local telescope_builtin_ok, telescope_builtin = pcall(require, 'telescope.builtin')
if not telescope_builtin_ok then
    return
end

-- prepare keymaps and autocommands
local on_attach = function(client, bufnr)
    local nmap = function(lhs, rhs, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end
        vim.keymap.set('n', lhs, rhs, { buffer = bufnr, desc = desc, silent = false })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    nmap('gd', '<cmd>TroubleToggle lsp_definitions<cr>', '[G]oto [D]efinitions')
    nmap('gsd', ':split | lua vim.lsp.buf.definition()<cr>', '[G]oto [D]efinition in [S]plit')
    nmap('gvd', ':vsplit | lua vim.lsp.buf.definition()<cr>', '[G]oto [D]efinition in [V]ertical split')
    nmap('gr', '<cmd>TroubleToggle lsp_references<cr>', '[G]oto [R]eferences')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('gtd', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('gf', vim.lsp.buf.format, '[F]ormat')
    nmap('<leader>ds', telescope_builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', telescope_builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    local lsp_augroup = vim.api.nvim_create_augroup('lsp', { clear = false })
    vim.api.nvim_clear_autocmds({ group = lsp_augroup, buffer = bufnr })
    if vim.fn.getbufvar(bufnr, '&filetype') == 'terraform' then
        vim.api.nvim_create_autocmd('BufWritePre', {
            group = lsp_augroup,
            buffer = bufnr,
            callback = function() vim.lsp.buf.format({ timeout_ms = 10000 }) end,
        })
    elseif client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd('BufWritePre', {
            group = lsp_augroup,
            buffer = bufnr,
            callback = function() vim.lsp.buf.format() end,
        })
    end
end

-- project-specific LSP settings
local gopls_local = ''
if vim.fn.system({ 'git', 'remote', 'get-url', 'origin' }):gsub('\n', '') == 'git@gitlab.com:levelbenefits/level.git' then
    gopls_local = 'gitlab.com/levelbenefits/level'
end

-- LSP settings
local server_settings = {
    bufls = {},
    gopls = {
        ['local'] = gopls_local,
        analyses = {
            nilness = true,
            unusedparams = true,
            unusedwrite = true,
            unusedvariable = true,
        },
    },
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
    yamlls = {
        yaml = {
            format = { enable = true },
            keyOrdering = false,
            customTags = { '!reference sequence' }
        },
    },
}

-- set up mason and ensure all desired LSP servers are installed
mason.setup()
mason_lspconfig.setup({
    ensure_installed = vim.tbl_keys(server_settings),
})

-- set up LSP handlers
mason_lspconfig.setup_handlers({
    function(server_name)
        require('lspconfig')[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = server_settings[server_name],
        })
    end,
})

-- disable LSP logging, otherwise it grows indefinitely
vim.lsp.set_log_level("off")
