if not _G.plugin_loaded("nvim-treesitter-context") then
	print("treesitter-context not loaded")
	do return end
end

require'treesitter-context'.setup {}
