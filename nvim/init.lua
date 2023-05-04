-- input
vim.keymap.set({'n', 'v'}, '<space>', '<nop>', {silent = true})
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
vim.opt.timeoutlen = 500
vim.keymap.set({'n', 'i', 'v'}, '˙', '<a-h>', {remap = true})
vim.keymap.set({'n', 'i', 'v'}, '∆', '<a-j>', {remap = true})
vim.keymap.set({'n', 'i', 'v'}, '˚', '<a-k>', {remap = true})
vim.keymap.set({'n', 'i', 'v'}, '¬', '<a-l>', {remap = true})

-- imports
require('user.plugins')
require('user.text_editing')
require('user.search')
require('user.file_browser')
require('user.appearance')
require('user.go')


-- legacy: terraform
require('lspconfig').terraformls.setup{}
local terraform = vim.api.nvim_create_augroup('terraform', {clear = true})
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = {'*.tf', '*.tfvars'},
    group = terraform,
    callback = function() vim.lsp.buf.format() end,
})
