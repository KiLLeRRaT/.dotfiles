if not _G.plugin_loaded("leap.nvim") then
	print("leap.nvim not loaded")
	do return end
end

vim.keymap.set("n", "<leader>e", "<Plug>(leap-forward)")
vim.keymap.set("n", "<leader>E", "<Plug>(leap-backward)")
