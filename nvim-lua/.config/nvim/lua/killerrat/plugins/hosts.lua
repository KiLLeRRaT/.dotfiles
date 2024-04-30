-- REMEMBER TO SET THE cond ON THE LOADING OF THE PLUGIN OTHERWISE THIS DOESNT HAVE ANY EFFECT

local servers = {
	["neorg"] = false,
	["luarocks.nvim"] = false,
	["nvim-silicon"] = false,
	["nvim-dap-ui"] = false,
	["nvim-dap-virtual-text"] = false,
	["telescope-dap.nvim"] = false,
	["nvim-dap"] = false,
	["nvim-nio"] = false,
	["nvim-dbee"] = false,
}

local plugins = {}
plugins = {
		["arch-agouws"] = {
			["neorg"] = true,
		},
		["pappa"] = servers,
		["sierraecho"] = servers
}
return plugins
