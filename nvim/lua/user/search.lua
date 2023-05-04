-- options
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

-- fzf
vim.opt.runtimepath:append('/usr/local/opt/fzf')
vim.keymap.set('n', '<leader>o', function() vim.cmd([[:GFiles --exclude-standard --cached --others]]) end)
vim.keymap.set('n', '<leader>O', function() vim.cmd.Files() end)
vim.keymap.set('n', '<leader>/', function() vim.cmd.Rg() end)
vim.keymap.set('n', '<leader>l', function() vim.cmd.BLines() end)
vim.api.nvim_set_var('fzf_action', {
    ['ctrl-t'] = 'tab split',
    ['ctrl-s'] = 'split',
    ['ctrl-v'] = 'vsplit',
})
