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
