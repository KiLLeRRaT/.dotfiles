if not _G.plugin_loaded("goto-preview") then
	do return end
end

require('goto-preview').setup {
 -- SEE: https://github.com/rmagatti/goto-preview#%EF%B8%8F-configuration
	width = 120; -- Width of the floating window
	height = 30; -- Height of the floating window
	border = {"↖", "─" ,"┐", "│", "┘", "─", "└", "│"}; -- Border characters of the floating window
	default_mappings = true; -- Bind default mappings
	debug = false; -- Print debug information
	opacity = nil; -- 0-100 opacity level of the floating window where 100 is fully transparent.
	-- resizing_mappings = true; -- Binds arrow keys to resizing the floating window.
	post_open_hook = nil; -- A function taking two arguments, a buffer and a window to be ran as a hook.
	references = { -- Configure the telescope UI for slowing the references cycling window.
		-- telescope = telescope.themes.get_dropdown({ hide_preview = false })
		-- telescope = require("telescope.themes").get_dropdown({ hide_preview = false, width = 0.75 })
	};
	-- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
	focus_on_open = true; -- Focus the floating window when opening it.
	dismiss_on_move = false; -- Dismiss the floating window when moving the cursor.
	force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
	bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
}


-- DEFAULT KEYMAPPINGS:
-- nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>
-- nnoremap gpt <cmd>lua require('goto-preview').goto_preview_type_definition()<CR>
-- nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>
-- nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>
-- nnoremap gpr <cmd>lua require('goto-preview').goto_preview_references()<CR>
