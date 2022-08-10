print"here"
if not _G.plugin_loaded("vim-commentary") then
	do return end
end
print"here2"

-- autocmd FileType cs setlocal commentstring=\/\/\ %s
-- autocmd FileType sql setlocal commentstring=--\ %s
local commentary = vim.api.nvim_create_augroup("commentary", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = "sql",
	callback = function()
		vim.schedule(function()
			print("yealo")
			vim.opt_local.commentstring = "-- %s"
		end)
	end,
	group = commentary
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "cs",
	callback = function()
		vim.schedule(function()
			print("yealo2")
			vim.opt_local.commentstring = "// %s"
		end)
	end,
	group = commentary
})
