vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt_local.foldlevel = 99

-- IF THE FILENAME IS APPSETTINGS*.JSON, THEN SET FILETYPE TO JSONC
local appsettingsJsonFiles_BufEnter_BufWinEnter= vim.api.nvim_create_augroup("appsettingsJsonFiles_BufEnter_BufWinEnter", { clear = true })
vim.api.nvim_create_autocmd({"BufReadPre", "BufEnter", "BufWinEnter"}, {
	pattern = {
		"**/appsettings*.json"
	},
	callback = function()
		vim.bo.filetype = "jsonc"
		vim.opt.commentstring = "// %s"
	end,
	group = appsettingsJsonFiles_BufEnter_BufWinEnter
})
