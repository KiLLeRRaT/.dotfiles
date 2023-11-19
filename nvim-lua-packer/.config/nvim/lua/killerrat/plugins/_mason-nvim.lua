if not _G.plugin_loaded("mason.nvim") then
	do return end
end

require("mason").setup()
