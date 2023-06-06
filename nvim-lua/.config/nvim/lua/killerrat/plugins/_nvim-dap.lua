if not _G.plugin_loaded("nvim-dap") then
	do return end
end



local dap = require('dap')

dap.adapters.coreclr = {
	type = 'executable',
	-- command = '/path/to/dotnet/netcoredbg/netcoredbg',
	command = '/usr/local/bin/netcoredbg/netcoredbg',
	args = {'--interpreter=vscode'}
}

dap.configurations.cs = {
	{
		type = "coreclr",
		name = "launch - netcoredbg",
		request = "launch",
		program = function()
				return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
		end,
	},
}
