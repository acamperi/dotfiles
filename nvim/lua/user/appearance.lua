-- general
vim.opt.number = true
vim.opt.ruler = true
vim.opt.showtabline = 2
vim.opt.laststatus = 2
vim.opt.termguicolors = true
vim.opt.showcmd = true
vim.opt.lazyredraw = true

-- color scheme
vim.g.background = dark
vim.g.srcery_italic = true
local colorscheme = 'srcery'
local colorscheme_ok, _ = pcall(vim.cmd, 'colorscheme ' .. colorscheme)
if not colorscheme_ok then
    vim.notify('colorscheme ' .. colorscheme .. ' not found!')
end

-- cursor
-- TODO: fix these
-- vim.api.nvim_set_var('&t_SI', '\<Esc>[6 q')
-- vim.api.nvim_set_var('&t_SR', '\<Esc>[4 q')
-- vim.api.nvim_set_var('&t_EI', '\<Esc>[2 q')
local cursor_line = vim.api.nvim_create_augroup('cursor_line', {clear = true})
vim.api.nvim_create_autocmd({'VimEnter', 'WinEnter', 'BufWinEnter'}, {
    pattern = '*',
    group = cursor_line,
    callback = function() vim.opt_local.cursorline = true end,
})
vim.api.nvim_create_autocmd('WinLeave', {
    pattern = '*',
    group = cursor_line,
    callback = function() vim.opt_local.cursorline = false end,
})

-- status line
vim.g.airline_theme = 'simple'
vim.g.airline_powerline_fonts = true
vim.g.airline_section_b = ''
vim.opt.showmode = false

-- windows
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.keymap.set('n', '<leader>q', ':q<cr>')
for _, d in ipairs({'h', 'j', 'k', 'l'}) do
    vim.keymap.set('n', '<c-'..d..'>', '<c-w>'..d, {silent = true})
    vim.keymap.set({'i', 't'}, '<c-'..d..'>', '<c-\\><c-n><c-w>'..d, {silent = true})
end
local terminsert = vim.api.nvim_create_augroup('terminsert', {clear = true})
vim.api.nvim_create_autocmd('BufEnter', {
    pattern = '*',
    group = terminsert,
    callback = function() if vim.fn.getbufvar('%', '&buftype') == 'terminal' then vim.cmd('startinsert') end end,
})
vim.keymap.set('n', '<leader>st', ':split +terminal<cr>i')
vim.keymap.set('n', '<leader>vt', ':vsplit +terminal<cr>i')
vim.keymap.set('t', '<leader><esc>', '<c-\\><c-n>')
