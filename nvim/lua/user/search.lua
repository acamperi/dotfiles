-- options
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

-- telescope
local telescope_ok, telescope = pcall(require, 'telescope')
if not telescope_ok then
    return
end
local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>o', function()
    telescope_builtin.git_files({ show_untracked = true })
end, { desc = 'Search Git Files' })
vim.keymap.set('n', '<leader>O', function()
    telescope_builtin.find_files({ no_ignore = true })
end, { desc = 'Search Files' })
vim.keymap.set('n', '<leader>/', telescope_builtin.live_grep, { desc = 'Search by Grep' })
vim.keymap.set('n', '<leader>*', telescope_builtin.grep_string, { desc = 'Search Current Selection' })
vim.keymap.set('n', '<leader>l', function()
    telescope_builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
        winblend = 10,
        previewer = false,
    }))
end, { desc = 'Search Buffer Lines' })
vim.keymap.set('n', '<leader>sd', telescope_builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
local telescope_actions = require('telescope.actions')
telescope.setup({
    defaults = {
        mappings = {
            i = {
                ['<c-s>'] = telescope_actions.select_horizontal,
                ['<c-t>'] = telescope_actions.select_tab,
            },
            n = {
                ['<c-s>'] = telescope_actions.select_horizontal,
                ['<c-t>'] = telescope_actions.select_tab,
            },
        },
    },
})
pcall(telescope.load_extension, 'fzf')
