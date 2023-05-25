vim.g.go_fmt_command = 'gofmt'
vim.g.go_imports_mode = 'goimports'
vim.g.go_fmt_autosave = false
vim.g.go_imports_autosave = false
vim.g.go_jump_to_error = false
vim.g.go_metalinter_autosave = false
vim.g.go_autodetect_gopath = true
vim.g.go_list_type = 'quickfix'
vim.g.go_auto_sameids = true
vim.g.go_auto_type_info = true
vim.g.go_fmt_options = { goimports = '-e -local gitlab.com/levelbenefits/level' }

vim.g.go_highlight_types = true
vim.g.go_highlight_fields = true
vim.g.go_highlight_functions = true
vim.g.go_highlight_function_calls = true
vim.g.go_highlight_operators = true
vim.g.go_highlight_extra_types = true
vim.g.go_highlight_build_constraints = true
vim.g.go_highlight_generate_tags = true

local golang_augroup = vim.api.nvim_create_augroup('golang', { clear = true })
local function golang_keymap(lhs, rhs)
    vim.api.nvim_create_autocmd('FileType', {
        group = golang_augroup,
        pattern = 'go',
        callback = function() vim.keymap.set('n', lhs, rhs, { buffer = true }) end,
    })
end

golang_keymap('<leader>b', function() vim.cmd.GoBuild() end)
golang_keymap('<leader>t', function() vim.cmd.GoTest('-timeout=120s') end)
golang_keymap('<leader>tf', function() vim.cmd.GoTestFunc('-timeout=120s') end)
golang_keymap('<leader>tc', function() vim.cmd.GoTestCompile() end)
golang_keymap('<leader>i', function() vim.cmd.GoImports() end)
golang_keymap('<leader>d', function() vim.cmd.GoDef() end)
golang_keymap('<leader>r', function() vim.cmd.GoReferrers() end)
