if not _G.plugin_loaded("undotree") then
	print("undotree not loaded")
	do return end
end

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
