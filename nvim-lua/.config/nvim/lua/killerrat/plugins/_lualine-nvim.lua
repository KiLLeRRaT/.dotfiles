if not _G.plugin_loaded("lualine.nvim") then
	do return end
end

-- LUA LINES, https://github.com/nvim-lualine/lualine.nvim#default-configuration
require'lualine'.setup {
	options = {
		-- theme = 'gruvbox'
		theme = 'palenight'
	}
}
