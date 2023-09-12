-- vim.g.go_fmt_command = 'gofmt'
-- vim.g.go_imports_mode = 'goimports'
-- vim.g.go_fmt_autosave = false
-- vim.g.go_imports_autosave = false
-- vim.g.go_jump_to_error = false
-- vim.g.go_metalinter_autosave = false
-- vim.g.go_autodetect_gopath = true
-- vim.g.go_list_type = 'quickfix'
-- vim.g.go_auto_sameids = true
-- vim.g.go_auto_type_info = true
-- vim.g.go_fmt_options = { goimports = '-e -local gitlab.com/levelbenefits/level' }
--
-- vim.g.go_highlight_types = true
-- vim.g.go_highlight_fields = true
-- vim.g.go_highlight_functions = true
-- vim.g.go_highlight_function_calls = true
-- vim.g.go_highlight_operators = true
-- vim.g.go_highlight_extra_types = true
-- vim.g.go_highlight_build_constraints = true
-- vim.g.go_highlight_generate_tags = true

local golang_augroup = vim.api.nvim_create_augroup('golang', { clear = true })
local function golang_keymap(lhs, rhs)
    vim.api.nvim_create_autocmd('FileType', {
        group = golang_augroup,
        pattern = 'go',
        callback = function() vim.keymap.set('n', lhs, rhs, { buffer = true }) end,
    })
end

-- golang_keymap('<leader>b', function() vim.cmd.GoBuild() end)
-- golang_keymap('<leader>t', function() vim.cmd.GoTest('-timeout=120s') end)
-- golang_keymap('<leader>tf', function() vim.cmd.GoTestFunc('-timeout=120s') end)
-- golang_keymap('<leader>tc', function() vim.cmd.GoTestCompile() end)
-- golang_keymap('<leader>i', function() vim.cmd.GoImports() end)

local job_ok, Job = pcall(require, 'plenary.job')
if not job_ok then
    return
end

local compile_efm = [[%-G#\ %.%#]]
compile_efm = compile_efm .. [[,%-G%.%#panic:\ %m]]
compile_efm = compile_efm .. [[,%Ecan\'t\ load\ package:\ %m]]
compile_efm = compile_efm .. [[,%A%\\%%\(%[%^:]%\\+:\ %\\)%\\?%f:%l:%c:\ %m]]
compile_efm = compile_efm .. [[,%A%\\%%\(%[%^:]%\\+:\ %\\)%\\?%f:%l:\ %m]]
compile_efm = compile_efm .. [[,%C%*\\s%m]]
compile_efm = compile_efm .. [[,%-G%.%#]]

local function go_build()
    local execdir = vim.fn.expand('%:h')
    Job:new({
        command = 'go',
        args = { 'build', '.', 'errors' },
        cwd = execdir,
        on_exit = function(job, code)
            vim.schedule(function()
                local output = job:stderr_result()
                if #output > 0 then
                    local prevdir = vim.fn.chdir(execdir)
                    vim.fn.setqflist({}, ' ', {
                        title = 'go build - ' .. execdir,
                        lines = output,
                        efm = compile_efm,
                    })
                    vim.fn.chdir(prevdir)
                end
                if code == 0 then
                    vim.notify('[go build] SUCCESS', vim.log.levels.INFO)
                else
                    vim.notify('[go build] FAILURE', vim.log.levels.ERROR)
                    vim.cmd('TroubleToggle quickfix')
                end
            end)
        end,
    }):start()
end
golang_keymap('<leader>b', go_build)

-- local test_efm_indent = [[%\\%(    %\\)]]
-- local test_efm = [[%-G=== RUN   %.%#]]
-- test_efm = test_efm .. [[,%-G]] .. test_efm_indent .. [[%#--- PASS: %.%#]]
-- test_efm = test_efm .. [[,%G--- FAIL: %\\%(Example%\\)%\\@=%m (%.%#)]]
-- test_efm = test_efm .. [[,%G]] .. test_efm_indent .. [[%#--- FAIL: %m (%.%#)]]
-- test_efm = test_efm .. [[,%A]] .. test_efm_indent .. [[%\\+%[%^:]%\\+: %f:%l: %m]]
-- test_efm = test_efm .. [[,%+Gpanic: test timed out after %.%\\+]]
-- test_efm = test_efm .. ',%+Afatal error: %.%# [recovered]'
-- test_efm = test_efm .. [[,%+Afatal error: %.%#]]
-- test_efm = test_efm .. [[,%+Apanic: %.%#]]
-- test_efm = test_efm .. ',%-Cexit status %[0-9]%\\+'
-- test_efm = test_efm .. ',exit status %[0-9]%\\+'
-- test_efm = test_efm .. ',%-CFAIL%\\t%.%#'
-- test_efm = test_efm .. ',FAIL%\\t%.%#'
-- test_efm = test_efm .. ',%A%f:%l:%c: %m'
-- test_efm = test_efm .. ',%A%f:%l: %m'
-- test_efm = test_efm .. ',%f:%l +0x%[0-9A-Fa-f]%\\+'
-- test_efm = test_efm .. ',%-G%\\t%\\f%\\+:%\\d%\\+ +0x%[0-9A-Fa-f]%\\+'
-- test_efm = test_efm .. ',%+G%\\t%m'
-- test_efm = test_efm .. ',%-C%.%#'
-- test_efm = test_efm .. ',%-G%.%#'
-- test_efm = string.gsub(test_efm, ' ', [[\ ]])
--
-- local function go_test()
--     local execdir = vim.fn.expand('%:h')
--     Job:new({
--         command = 'go',
--         args = { 'test', '-timeout=120s' },
--         cwd = execdir,
--         on_exit = function(job, code)
--             vim.schedule(function()
--                 local output = job:result()
--                 if #output > 0 then
--                     local prevdir = vim.fn.chdir(execdir)
--                     vim.fn.setqflist({}, ' ', {
--                         title = 'go test - ' .. execdir,
--                         lines = output,
--                         efm = test_efm,
--                     })
--                     vim.fn.chdir(prevdir)
--                 end
--                 if code == 0 then
--                     vim.notify('[go test] SUCCESS', vim.log.levels.INFO)
--                 else
--                     vim.notify('[go test] FAILURE', vim.log.levels.ERROR)
--                     -- vim.cmd('TroubleToggle quickfix')
--                 end
--             end)
--         end,
--     }):start()
-- end
-- golang_keymap('<leader>t', go_test)

-- local neotest = require('neotest')
-- golang_keymap('<leader>t', function() neotest.run.run(vim.fn.expand('%')) end)
-- golang_keymap('<leader>tf', neotest.run.run)
-- golang_keymap('<leader>td', function() neotest.run.run(vim.fn.expand('%:h')) end)
-- golang_keymap('<leader>ts', neotest.run.stop)

-- TODO: generate
