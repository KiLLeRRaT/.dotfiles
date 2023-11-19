if not _G.plugin_loaded("lualine.nvim") then
	do return end
end

local function window()
  return vim.api.nvim_win_get_number(0)
end

-- LUA LINES, https://github.com/nvim-lualine/lualine.nvim#default-configuration
require'lualine'.setup {
	sections = {
		lualine_a = {
			{ window },
			{ 'mode', upper = true }
		}
	},
	inactive_sections = {
		lualine_a = {
			{ window }
		}
	},
	options = {
		-- theme = 'gruvbox'
		-- theme = 'palenight'
		theme = 'tokyonight'
	}
}

-- require'lualine'.setup {
--   lualine_a = {
--     {'mode', fmt=trunc(80, 4, nil, true)},
--     {'filename', fmt=trunc(90, 30, 50)},
--     {function() return require'lsp-status'.status() end, fmt=trunc(120, 20, 60)}
--   }
-- }
