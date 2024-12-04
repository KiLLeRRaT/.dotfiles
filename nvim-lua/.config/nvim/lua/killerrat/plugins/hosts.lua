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

local iphone = {
	["nvim-silicon"] = false,
	["nvim-dap-ui"] = false,
	["nvim-dap-virtual-text"] = false,
	["telescope-dap.nvim"] = false,
	["nvim-dap"] = false,
	["nvim-nio"] = false,
	["nvim-dbee"] = false,
	["neorg"] = false,
}

local plugins = {}
plugins = {
		-- if not set, defaults to enabled = true
	["arch-agouws"] = { },
	["pappa"] = servers,
	["sierraecho"] = servers,
	["sierradelta"] = servers,
	["proxmox5"] = servers,
	["proxmox-backup-server"] = servers,
	["kiosk-1"] = servers,
	["SALDOCPROD1"] = servers,
	["SALDOCDEV1"] = servers,
	["localhost"] = iphone,
}
return plugins
