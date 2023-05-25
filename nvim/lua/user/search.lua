-- options
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

-- keymaps for system list navigation (diagnostics, quickfix, localist)
vim.keymap.set('n', '[q', ':cprevious<cr>', { desc = 'Go to previous quickfix error' })
vim.keymap.set('n', ']q', ':cnext<cr>', { desc = 'Go to next quickfix error' })
vim.keymap.set('n', '[l', ':cprevious<cr>', { desc = 'Go to previous locationlist error' })
vim.keymap.set('n', ']l', ':cnext<cr>', { desc = 'Go to next locationlist error' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- import modules
local telescope_ok, telescope = pcall(require, 'telescope')
local trouble_ok, trouble = pcall(require, 'trouble.providers.telescope')
if not telescope_ok or not trouble_ok then
    return
end

-- telescope keymaps
local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>o', function() telescope_builtin.git_files({ show_untracked = true }) end,
    { desc = 'Search Git Files' })
vim.keymap.set('n', '<leader>O', function() telescope_builtin.find_files({ no_ignore = true }) end,
    { desc = 'Search Files' })
vim.keymap.set('n', '<leader>/', telescope_builtin.live_grep, { desc = 'Search by Grep' })
vim.keymap.set('n', '<leader>*', telescope_builtin.grep_string, { desc = 'Search Current Selection' })
vim.keymap.set('n', '<leader>l', function()
    telescope_builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
        winblend = 10,
        previewer = false,
    }))
end, { desc = 'Search Buffer Lines' })
vim.keymap.set('n', '<leader>sd', telescope_builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })

-- telescope actions
local telescope_actions = require('telescope.actions')
telescope.setup({
    defaults = {
        mappings = {
            i = {
                ['<c-x>'] = telescope_actions.select_horizontal,
                ['<c-t>'] = telescope_actions.select_tab,
                ['<c-j>'] = telescope_actions.move_selection_next,
                ['<c-k>'] = telescope_actions.move_selection_previous,
                ['<c-b>'] = telescope_actions.preview_scrolling_up,
                ['<c-f>'] = telescope_actions.preview_scrolling_down,
                ['<c-X>'] = trouble.open_with_trouble,
            },
            n = {
                ['<c-x>'] = telescope_actions.select_horizontal,
                ['<c-t>'] = telescope_actions.select_tab,
                ['<c-j>'] = telescope_actions.move_selection_next,
                ['<c-k>'] = telescope_actions.move_selection_previous,
                ['<c-b>'] = telescope_actions.preview_scrolling_up,
                ['<c-f>'] = telescope_actions.preview_scrolling_down,
                ['<c-X>'] = trouble.open_with_trouble,
            },
        },
    },
})

-- telescope x fzf
pcall(telescope.load_extension, 'fzf')

-- trouble keymaps
vim.keymap.set('n', '<leader>xx', '<cmd>TroubleToggle<cr>', { silent = true })
vim.keymap.set('n', '<leader>xw', '<cmd>TroubleToggle workspace_diagnostics<cr>', { silent = true })
vim.keymap.set('n', '<leader>xd', '<cmd>TroubleToggle document_diagnostics<cr>', { silent = true })
vim.keymap.set('n', '<leader>xq', '<cmd>TroubleToggle quickfix<cr>', { silent = true })
vim.keymap.set('n', '<leader>xl', '<cmd>TroubleToggle loclist<cr>', { silent = true })
