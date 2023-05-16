-- input
vim.keymap.set({ 'n', 'v' }, '<space>', '<nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
vim.opt.timeoutlen = 500
vim.keymap.set({ 'n', 'i', 'v' }, '˙', '<a-h>', { remap = true })
vim.keymap.set({ 'n', 'i', 'v' }, '∆', '<a-j>', { remap = true })
vim.keymap.set({ 'n', 'i', 'v' }, '˚', '<a-k>', { remap = true })
vim.keymap.set({ 'n', 'i', 'v' }, '¬', '<a-l>', { remap = true })

-- imports
require('user.plugins')
require('user.text_editing')
require('user.lsp')
require('user.autocomplete')
require('user.search')
require('user.file_browser')
require('user.appearance')
require('user.treesitter')
require('user.go')
require('user.authzed')
