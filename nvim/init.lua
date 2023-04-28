-----------
-- Shell --
-----------

vim.opt.shell = "/bin/bash"


-------------
-- Leaders --
-------------

vim.keymap.set('n', '<space>', '<nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'


-------------
-- Plugins --
-------------

require('packer_init')


------------------
-- MacOS Remaps --
------------------

vim.keymap.set({'n', 'i', 'v'}, '˙', '<a-h>', {remap = true})
vim.keymap.set({'n', 'i', 'v'}, '∆', '<a-j>', {remap = true})
vim.keymap.set({'n', 'i', 'v'}, '˚', '<a-k>', {remap = true})
vim.keymap.set({'n', 'i', 'v'}, '¬', '<a-l>', {remap = true})


----------------------
-- General Settings --
----------------------

vim.opt.compatible = false
vim.opt.number = true
vim.opt.belloff = 'all'
vim.opt.ruler = true
vim.opt.showtabline = 2
vim.opt.laststatus = 2
vim.opt.termguicolors = true
vim.opt.showcmd = true
vim.opt.lazyredraw = true
vim.opt.updatetime = 100
vim.opt.timeoutlen = 500


---------------------
-- Window Settings --
---------------------

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


-----------------------
-- Terminal Settings --
-----------------------

vim.keymap.set('n', '<leader>st', ':split +terminal<cr>ifish<cr>')
vim.keymap.set('n', '<leader>vt', ':vsplit +terminal<cr>ifish<cr>')
vim.keymap.set('t', '<leader><esc>', '<c-\\><c-n>')


-------------------
-- File Settings --
-------------------

vim.cmd('filetype off')
vim.cmd('filetype plugin indent on')
vim.opt.encoding = 'utf-8'
vim.opt.autoread = true
vim.opt.autowrite = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.hidden = true
vim.keymap.set('n', '<leader>w', ':write<cr>')
vim.opt.undolevels = 1000
vim.opt.undofile = true
vim.opt.undodir = os.getenv('HOME')..'/.config/vim/tmp/undo/'
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


------------------
-- Text Editing --
------------------

-- general
vim.opt.showmatch = true
vim.opt.virtualedit = 'onemore'
vim.opt.backspace = 'indent,eol,start'
vim.opt.completeopt = 'menu,menuone'
vim.opt.pumheight = 10
vim.opt.clipboard = 'unnamed'

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

-- whitespace
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 0
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.autoindent = true

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

-- typos and snippets
vim.cmd([[iabbrev adn and]])
vim.cmd([[iabbrev hte the]])
local snippets = vim.api.nvim_create_augroup('snippets', {clear = true})
vim.api.nvim_create_autocmd('FileType', {
    pattern = {'c', 'go', 'javacsript', 'lua', 'rust', 'typescript', 'typescriptreact'},
    group = snippets,
    command = ':iabbrev <buffer> ret return',
})

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


------------
-- Search --
------------

vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')


-----------------
-- Status Line --
-----------------

vim.g.airline_theme = 'simple'
vim.g.airline_powerline_fonts = true
vim.g.airline_section_b = ''
vim.opt.showmode = false


---------------
-- nvim-tree --
---------------

require('nvim-tree').setup({
    view = {
        width = 40,
        mappings = {
            list = {
                { key = "<c-s>", action = "split" },
            },
        },
    },
    filters = {
        custom = {'^\\.git', '^\\.idea'},
    },
})
vim.keymap.set('n', '<leader>n', function() vim.cmd.NvimTreeFocus() end)
vim.keymap.set('n', '<leader>nt', function() vim.cmd.NvimTreeToggle() end)
vim.keymap.set('n', '<leader>nf', function() vim.cmd.NvimTreeFindFile() end)
local nvim_tree = vim.api.nvim_create_augroup('nvim_tree', {clear = true})
-- open nvim-tree on start-up and switch focus back to other window
vim.api.nvim_create_autocmd('VimEnter', {
    pattern = '*',
    group = nvim_tree,
    callback = function()
        vim.cmd.NvimTreeOpen()
        vim.cmd.wincmd('p')
    end,
})
-- close neovim if nvim-tree is the last open window
vim.api.nvim_create_autocmd('BufEnter', {
    pattern = '*',
    group = nvim_tree,
    callback = function()
        if vim.fn.winnr('$') == 1 and string.find(vim.fn.bufname('%'), 'NvimTree_%d+') ~= nil then
            vim.cmd.quit()
        end
    end,
})
-- if another buffer tries to replace nvim-tree, put it in the other window and bring back nvim-tree
vim.api.nvim_create_autocmd('BufEnter', {
    pattern = '*',
    group = nvim_tree,
    callback = function()
        if string.find(vim.fn.bufname('#'), 'NvimTree_%d+') ~= nil and string.find(vim.fn.bufname('%'), 'NvimTree_%d+') == nil and vim.fn.winnr('$') > 1 then
            local bufnr = vim.fn.bufnr()
            vim.cmd('buffer#')
            vim.cmd.wincmd('w')
            vim.cmd('buffer'..bufnr)
        end
    end,
})


---------
-- FZF --
---------

vim.opt.runtimepath:append('/usr/local/opt/fzf')
vim.keymap.set('n', '<leader>o', function() vim.cmd([[:GFiles --exclude-standard --cached --others]]) end)
vim.keymap.set('n', '<leader>O', function() vim.cmd.Files() end)
vim.keymap.set('n', '<leader>/', function() vim.cmd.Rg() end)
vim.api.nvim_set_var('fzf_action', {
    ['ctrl-t'] = 'tab split',
    ['ctrl-s'] = 'split',
    ['ctrl-v'] = 'vsplit',
})


-------------------
-- Muscle Memory --
-------------------

vim.keymap.set({'n', 'i', 'v'}, '<left>', '<nop>')
vim.keymap.set({'n', 'i', 'v'}, '<down>', '<nop>')
vim.keymap.set({'n', 'i', 'v'}, '<up>', '<nop>')
vim.keymap.set({'n', 'i', 'v'}, '<right>', '<nop>')


---------------------
-- Syntax Settings --
---------------------

vim.g.background = 'dark'
vim.g.srcery_italic = true
vim.cmd('silent! colorscheme srcery')


------------
-- vim-go --
------------

vim.g.go_fmt_command = 'gofmt'
vim.g.go_imports_mode = 'goimports'
vim.g.go_fmt_autosave = true
vim.g.go_imports_autosave = false
vim.g.go_jump_to_error = false
vim.g.go_metalinter_autosave = false
vim.g.go_autodetect_gopath = true
vim.g.go_list_type = 'quickfix'
vim.g.go_auto_sameids = true
vim.g.go_auto_type_info = true
vim.g.go_fmt_options = {goimports = '-e -local gitlab.com/levelbenefits/level'}

vim.g.go_highlight_types = true
vim.g.go_highlight_fields = true
vim.g.go_highlight_functions = true
vim.g.go_highlight_function_calls = true
vim.g.go_highlight_operators = true
vim.g.go_highlight_extra_types = true
vim.g.go_highlight_build_constraints = true
vim.g.go_highlight_generate_tags = true

local golang = vim.api.nvim_create_augroup('golang', {clear = true})
function golang_keymap(lhs, rhs)
    vim.api.nvim_create_autocmd('FileType', {
        pattern = 'go',
        group = golang,
        callback = function() vim.keymap.set('n', lhs, rhs, { buffer = true }) end,
    })
end
golang_keymap('<leader>b', function() vim.cmd.GoBuild() end)
golang_keymap('<leader>t', function() vim.cmd.GoTest('-timeout=120s') end)
golang_keymap('<leader>tf', function() vim.cmd.GoTestFunc('-timeout=120s') end)
golang_keymap('<leader>i', function() vim.cmd.GoImports() end)
golang_keymap('<leader>d', function() vim.cmd.GoDef() end)
golang_keymap('<leader>r', function() vim.cmd.GoReferrers() end)


---------------
-- terraform --
---------------

require('lspconfig').terraformls.setup{}
local terraform = vim.api.nvim_create_augroup('terraform', {clear = true})
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = {'*.tf', '*.tfvars'},
    group = terraform,
    callback = function() vim.lsp.buf.format() end,
})


---------
-- lua --
---------

-- TODO: figure this out
-- require('lspconfig').lua.setup{}
-- local lua = vim.api.nvim_create_augroup('lua', {clear = true})
-- vim.api.nvim_create_autocmd('BufWritePre', {
--     pattern = '*.lua',
--     group = lua,
--     callback = function() vim.lsp.buf.format() end,
-- })
