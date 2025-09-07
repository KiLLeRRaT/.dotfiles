local p = require("conform")
-- print("Loading conform-nvim")

-- -- NEED TO DO THIS FIRST:
-- dotnet tool install csharpier -g

p.setup {
	formatters_by_ft = {
		cs = { "csharpier" },
	},
	format_on_save = false,
	-- init = function()
	-- 	-- If you want the formatexpr, here is the place to set it
	-- 	print("Setting formatexpr for conform-nvim")
	-- 	vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	-- end
}








