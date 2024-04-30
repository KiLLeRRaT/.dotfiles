local p = "dap"; if (not require('killerrat.plugins._lazy-nvim').LazyHasPlugin(p)) then return end
local dap, dapui = require(p), require("dapui")

dap.adapters.coreclr = {
	type = 'executable',
	-- command = vim.fn.stdpath("data") .. '/netcoredbg/netcoredbg',
	command = '/usr/bin/netcoredbg',
	args = {'--interpreter=vscode'}
}

dap.configurations.cs = {
	{
		type = "coreclr",
		name = "launch - netcoredbg",
		request = "launch",
		console = "integratedTerminal",
		program = function()
			return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
			-- return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '', 'file')
		end,
	},
}


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

vim.keymap.set("n", "<leader>ur", ":lua require'dap'.repl.open()<CR>")
vim.keymap.set("n", "<leader>uR", ":lua require'dap'.run_last()<CR>")

-- -- vim.keymap.set("n", "<leader>ut", ":lua require'dap-go'.debug_test()<CR>")
