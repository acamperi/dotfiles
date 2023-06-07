-- general
vim.opt.number = true
vim.opt.ruler = true
vim.opt.showtabline = 2
vim.opt.laststatus = 2
vim.opt.termguicolors = true
vim.opt.showcmd = true
vim.opt.lazyredraw = true

-- color scheme
vim.g.background = 'dark'
vim.g.srcery_italic = true
local colorscheme = 'bamboo'
local colorscheme_ok, _ = pcall(vim.cmd, 'colorscheme ' .. colorscheme)
if not colorscheme_ok then
    vim.notify('colorscheme ' .. colorscheme .. ' not found!')
end

-- cursor
-- TODO: fix these
-- vim.api.nvim_set_var('&t_SI', '\<Esc>[6 q')
-- vim.api.nvim_set_var('&t_SR', '\<Esc>[4 q')
-- vim.api.nvim_set_var('&t_EI', '\<Esc>[2 q')
local cursor_line_augroup = vim.api.nvim_create_augroup('cursor_line', { clear = true })
vim.api.nvim_create_autocmd({ 'VimEnter', 'WinEnter', 'BufWinEnter' }, {
    group = cursor_line_augroup,
    pattern = '*',
    callback = function() vim.opt_local.cursorline = true end,
})
vim.api.nvim_create_autocmd('WinLeave', {
    group = cursor_line_augroup,
    pattern = '*',
    callback = function() vim.opt_local.cursorline = false end,
})

-- windows
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.keymap.set('n', '<leader>q', ':q<cr>')
for _, d in ipairs({ 'h', 'j', 'k', 'l' }) do
    vim.keymap.set('n', '<c-' .. d .. '>', '<c-w>' .. d, { silent = true })
    vim.keymap.set({ 'i', 't' }, '<c-' .. d .. '>', '<c-\\><c-n><c-w>' .. d, { silent = true })
end
local terminsert_augroup = vim.api.nvim_create_augroup('terminsert', { clear = true })
vim.api.nvim_create_autocmd('BufEnter', {
    group = terminsert_augroup,
    pattern = '*',
    callback = function() if vim.fn.getbufvar('%', '&buftype') == 'terminal' then vim.cmd('startinsert') end end,
})
vim.keymap.set('n', '<leader>st', ':split +terminal<cr>i')
vim.keymap.set('n', '<leader>vt', ':vsplit +terminal<cr>i')
vim.keymap.set('t', '<leader><esc>', '<c-\\><c-n>')
local autoresize_augroup = vim.api.nvim_create_augroup('autoresize', { clear = true })
vim.api.nvim_create_autocmd('VimResized', {
    group = autoresize_augroup,
    pattern = '*',
    command = 'tabdo wincmd ='
})

-- tabs
vim.keymap.set('n', '<leader>tn', ':tabnew<cr>', { desc = 'Open new tab' })
vim.keymap.set('n', '[t', ':tabprevious<cr>', { desc = 'Go to previous tab' })
vim.keymap.set('n', ']t', ':tabnext<cr>', { desc = 'Go to next tab' })

-- status line
local lualine_ok, lualine = pcall(require, 'lualine')
if not lualine_ok then
    return
end
lualine.setup({
    options = {
        theme = 'auto',
    },
    sections = {
        lualine_b = { 'diagnostics' },
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'filetype' },
    },
})
vim.opt.showmode = false
