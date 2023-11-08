if not _G.plugin_loaded("undotree") then
	print("undotree not loaded")
	do return end
end

vim.g.undotree_WindowLayout = 2
vim.g.undotree_DiffpanelHeight = 10
vim.keymap.set("n", "<leader>U", vim.cmd.UndotreeToggle)
