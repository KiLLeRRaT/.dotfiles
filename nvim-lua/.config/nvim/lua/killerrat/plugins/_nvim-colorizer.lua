if not _G.plugin_loaded("nvim-colorizer.lua") then
	print("nvim-colorizer.lua not loaded")
	do return end
end
	print("nvim-colorizer.lua loaded")

require 'colorizer'.setup()
