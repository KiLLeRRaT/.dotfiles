local p = "nvim-dap"; if (not require('killerrat.plugins._lazy-nvim').LazyHasPlugin(p)) then return end
local dap, dapui = require("dap"), require("dapui")

dap.adapters.coreclr = {
	type = 'executable',
	-- command = vim.fn.stdpath("data") .. '/netcoredbg/netcoredbg',
	command = '/usr/bin/netcoredbg',
	args = {'--interpreter=vscode'}
}

-- FROM: https://github.com/mfussenegger/nvim-dap/wiki/Cookbook#making-debugging-net-easier
-- vim.g.dotnet_build_project = function()
--     local default_path = vim.fn.getcwd() .. '/'
--     if vim.g['dotnet_last_proj_path'] ~= nil then
--         default_path = vim.g['dotnet_last_proj_path']
--     end
--     local path = vim.fn.input('Path to your *proj file', default_path, 'file')
--     vim.g['dotnet_last_proj_path'] = path
--     local cmd = 'dotnet build -c Debug ' .. path .. ' > /dev/null'
--     print('')
--     print('Cmd to execute: ' .. cmd)
--     local f = os.execute(cmd)
--     if f == 0 then
--         print('\nBuild: ✔️ ')
--     else
--         print('\nBuild: ❌ (code: ' .. f .. ')')
--     end
-- end

vim.g.dotnet_get_dll_path = function()
    local request = function()
        return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/**/bin/**/*.dll', 'file')
    end

    if vim.g['dotnet_last_dll_path'] == nil then
        vim.g['dotnet_last_dll_path'] = request()
    else
        if vim.fn.confirm('Do you want to change the path to dll?\n' .. vim.g['dotnet_last_dll_path'], '&yes\n&no', 2) == 1 then
            vim.g['dotnet_last_dll_path'] = request()
        end
    end

    return vim.g['dotnet_last_dll_path']
end

local config = {
	{
		type = "coreclr",
		name = "launch - netcoredbg",
		request = "launch",
		program = function()
				-- if vim.fn.confirm('Should I recompile first?', '&yes\n&no', 2) == 1 then
				-- 		vim.g.dotnet_build_project()
				-- end
				return vim.g.dotnet_get_dll_path()
		end,
	},
	{
			type = "coreclr",
			name = "attach - netcoredbg",
			request = "attach",
			processId = function()
				return require('dap.utils').pick_process({
					filter = function(proc)
						return vim.startswith(proc.name, vim.fn.getcwd())
					end
				})
			end,
		}
}

dap.configurations.cs = config
dap.configurations.fsharp = config

require("nvim-dap-virtual-text").setup()
-- require('dap-go').setup()
require("dapui").setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

-- vim.keymap.set("n", "<F1>", ":lua require'dap'.continue()<CR>")
vim.keymap.set("n", "<leader>uc", ":lua require'dap'.continue()<CR>")

-- vim.keymap.set("n", "<F2>", ":lua require'dap'.step_into()<CR>")
vim.keymap.set("n", "<leader>ui", ":lua require'dap'.step_into()<CR>")

-- vim.keymap.set("n", "<F3>", ":lua require'dap'.step_over()<CR>")
vim.keymap.set("n", "<leader>uo", ":lua require'dap'.step_over()<CR>")

-- vim.keymap.set("n", "<F4>", ":lua require'dap'.step_out()<CR>")
vim.keymap.set("n", "<leader>uO", ":lua require'dap'.step_out()<CR>")

vim.keymap.set("n", "<leader>ub", ":lua require'dap'.toggle_breakpoint()<CR>")
-- vim.keymap.set("n", "<F9>", ":lua require'dap'.toggle_breakpoint()<CR>")

-- vim.keymap.set("n", "<A-F9>", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
vim.keymap.set("n", "<leader>uB", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")

-- -- vim.keymap.set("n", "<leader>lp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")

vim.keymap.set("n", "<leader>ut", ":lua require'dap'.terminate()<CR>")
vim.keymap.set("n", "<leader>ud", ":lua require'dap'.disconnect()<CR>")
vim.keymap.set("n", "<leader>ur", ":lua require'dap'.repl.open()<CR>")
vim.keymap.set("n", "<leader>uR", ":lua require'dap'.run_last()<CR>")

-- -- vim.keymap.set("n", "<leader>ut", ":lua require'dap-go'.debug_test()<CR>")
