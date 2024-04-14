local function window()
  return vim.api.nvim_win_get_number(0)
end

-- LUA LINES, https://github.com/nvim-lualine/lualine.nvim#default-configuration
local winbar = {
	{
		'%m%4n:%t',
		-- show_modified_status = true,
		-- symbols = {
		-- 	modified = '[+]',      -- Text to show when the file is modified.
		-- 	readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
		-- 	unnamed = '[No Name]', -- Text to show for unnamed buffers.
		-- 	newfile = '[New]',     -- Text to show for newly created file before first write
		-- }
	}
}

require'lualine'.setup {
	sections = {
		lualine_a = {
			{ window },
			{ 'mode', upper = true }
		}
	},
	winbar = {
		-- lualine_x = {'%-10.3n'},
		-- lualine_z = { 'filename', '%-10.3n' }
		lualine_z = winbar
	},
	inactive_winbar = {
		-- lualine_x = {'%-10.3n'},
		lualine_z = winbar
	},
	inactive_sections = {
		lualine_a = {
			{ window }
		}
	},
	options = {
		-- theme = 'gruvbox'
		-- theme = 'palenight'
		theme = 'tokyonight',
		globalstatus = true
	}
}

-- require'lualine'.setup {
--   lualine_a = {
--     {'mode', fmt=trunc(80, 4, nil, true)},
--     {'filename', fmt=trunc(90, 30, 50)},
--     {function() return require'lsp-status'.status() end, fmt=trunc(120, 20, 60)}
--   }
-- }
