local nvimtree_ok, nvimtree = pcall(require, 'nvim-tree')
if not nvimtree_ok then
    return {}
end

local api = require('nvim-tree.api')

local on_attach = function(bufnr)
    api.config.mappings.default_on_attach(bufnr)
    vim.keymap.set('n', '<c-s>', api.node.open.horizontal, {
        desc = 'nvim-tree: Open: Horizontal Split',
        buffer = bufnr,
        silent = true,
    })
end

nvimtree.setup({
    on_attach = on_attach,
    view = {
        float = {
            enable = true,
            open_win_config = {
                border = 'rounded',
                width = 80,
                height = vim.opt.lines:get() - vim.opt.cmdheight:get() - 3,
            },
        },
    },
    renderer = {
        indent_markers = {
            enable = true,
        },
    },
    filters = {
        custom = { '^\\.git', '^\\.idea' },
    },
    git = {
        timeout = 5000,
    },
})

vim.keymap.set('n', '<leader>n', api.tree.open)
vim.keymap.set('n', '<leader>nt', api.tree.toggle)
vim.keymap.set('n', '<leader>nf', function() api.tree.find_file({ open = true, focus = true }) end)

local nvim_tree_augroup = vim.api.nvim_create_augroup('nvim_tree', { clear = true })

-- open nvim-tree on start-up without focus
-- TODO: don't open for commit messages, maybe don't open at all on start-up?
vim.api.nvim_create_autocmd('VimEnter', {
    group = nvim_tree_augroup,
    pattern = '*',
    callback = function() api.tree.toggle() end,
})

-- close neovim if nvim-tree is the last open window
vim.api.nvim_create_autocmd('BufEnter', {
    group = nvim_tree_augroup,
    pattern = '*',
    callback = function()
        if vim.fn.winnr('$') == 1 and require('nvim-tree.utils').is_nvim_tree_buf() then
            vim.cmd.quit()
        end
    end,
    nested = true,
})

-- if another buffer tries to replace nvim-tree, put it in the other window and bring back nvim-tree
-- vim.api.nvim_create_autocmd('BufEnter', {
--     group = nvim_tree_augroup,
--     pattern = '*',
--     callback = function()
--         if string.find(vim.fn.bufname('#'), 'NvimTree_%d+') ~= nil and string.find(vim.fn.bufname('%'), 'NvimTree_%d+') == nil and vim.fn.winnr('$') > 1 then
--             local bufnr = vim.fn.bufnr()
--             vim.cmd('buffer#')
--             vim.cmd.wincmd('w')
--             vim.cmd('buffer' .. bufnr)
--         end
--     end,
-- })
