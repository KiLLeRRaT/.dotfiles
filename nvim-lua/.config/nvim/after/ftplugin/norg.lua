-- vim.opt.foldlevel = 99
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

vim.keymap.set("n", "<localleader>nc", "<cmd>Neorg toggle-concealer<cr>")

-- SURROUND CURRENT LINE IN CODE TAGS
vim.keymap.set("n", "<localleader>sc", "O@code bash<esc>jo@end<esc>")

-- SURROUND VISUAL SELECTION IN CODE TAGS
vim.keymap.set("v", "<localleader>sc", "<esc>'<O@code bash<esc>'>o@end<esc>")

vim.opt_local.spell = true


-- FOLDLEVEL 99 WHEN OPENING INDEX.NORG
local norgfiles_BufEnter_BufWinEnter= vim.api.nvim_create_augroup("norgfiles_BufEnter_BufWinEnter", { clear = true })
vim.api.nvim_create_autocmd({"BufEnter, BufWinEnter"}, {
	pattern = {
		"**/index.norg"
	},
	callback = function()
		vim.opt_local.foldlevel = 99
		-- print("Set foldlevel to 99 for index.jorg")
	end,
	group = norgfiles_BufEnter_BufWinEnter
})

