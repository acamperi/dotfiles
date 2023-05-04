-- general
vim.opt.encoding = 'utf-8'
vim.opt.showmatch = true
vim.opt.virtualedit = 'onemore'
vim.opt.backspace = 'indent,eol,start'
vim.opt.completeopt = 'menuone,noselect'
vim.opt.pumheight = 10
vim.opt.clipboard = 'unnamedplus'
vim.opt.undolevels = 1000
vim.opt.undofile = true
vim.opt.undodir = os.getenv('HOME')..'/.config/vim/tmp/undo/'

-- folding
vim.opt.foldmethod = 'syntax'
vim.opt.foldnestmax = 1

-- wrapping
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.textwidth = 0
local wrapping = vim.api.nvim_create_augroup('wrapping', {clear = true})
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'proto',
    group = wrapping,
    callback = function() vim.opt_local.textwidth = 100 end,
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'go',
    group = wrapping,
    callback = function() vim.opt_local.textwidth = 120 end,
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = {'c', 'go', 'javascript', 'lua', 'rust', 'terraform', 'typescript', 'typescriptreact'},
    group = wrapping,
    callback = function() vim.b.argwrap_tail_comma = true end,
})
vim.keymap.set('n', '<leader>aw', function() vim.cmd.ArgWrap() end)

-- whitespace
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 0
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.autoindent = true
local whitespace = vim.api.nvim_create_augroup('whitespace', {clear = true})
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*',
    group = whitespace,
    command = [[%s/\s\+$//e]],
})

-- move lines up and down
vim.keymap.set('n', '<a-j>', ':move .+1<cr>==')
vim.keymap.set('n', '<a-k>', ':move .-2<cr>==')
vim.keymap.set('i', '<a-j>', '<esc>:move .+1<cr>==gi')
vim.keymap.set('i', '<a-k>', '<esc>:move .-2<cr>==gi')
vim.keymap.set('v', '<a-j>', [[:move '>+1<cr>gv=gv]])
vim.keymap.set('v', '<a-k>', [[:move '<-2<cr>gv=gv]])

-- indent
vim.keymap.set('v', '>', '>gv')
vim.keymap.set('v', '<', '<gv')

-- comments
local comments = vim.api.nvim_create_augroup('comments', {clear = true})
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'proto',
    group = comments,
    callback = function() vim.opt_local.commentstring = '//%s' end,
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'sql',
    group = comments,
    callback = function() vim.opt_local.commentstring = '--%s' end,
})

-- yank
local highlight_yank = vim.api.nvim_create_augroup('hightlight_yank', {clear = true})
vim.api.nvim_create_autocmd('TextYankPost', {
    pattern = '*',
    group = highlight_yank,
    callback = function() vim.highlight.on_yank() end,
})

-- buffer
vim.opt.autoread = true
vim.opt.autowrite = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.hidden = true
vim.keymap.set('n', '<leader>w', ':write<cr>')
function delete_hidden_buffers()
    local open_bufs = {}
    local num_closed = 0
    for tab=1,vim.fn.tabpagenr('$') do
        for _, buf in ipairs(vim.fn.tabpagebuflist(tab)) do
            open_bufs[buf] = true
        end
    end
    for buf=1,vim.fn.bufnr('$') do
        if vim.fn.bufexists(buf) and open_bufs[buf] == nil and vim.fn.getbufvar(buf, '&mod') == 0 and vim.fn.getbufvar(buf, '&buftype') ~= 'terminal' then
            vim.cmd.bwipeout(buf)
            num_closed = num_closed + 1
        end
    end
    print('Closed '..num_closed..' hidden buffers.')
end
vim.keymap.set('n', '<leader>dhb', delete_hidden_buffers)

-- muscle memory
vim.keymap.set({'n', 'i', 'v'}, '<left>', '<nop>')
vim.keymap.set({'n', 'i', 'v'}, '<down>', '<nop>')
vim.keymap.set({'n', 'i', 'v'}, '<up>', '<nop>')
vim.keymap.set({'n', 'i', 'v'}, '<right>', '<nop>')
