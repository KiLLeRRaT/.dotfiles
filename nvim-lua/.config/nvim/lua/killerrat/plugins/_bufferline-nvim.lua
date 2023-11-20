require'bufferline'.setup {
	options = {
		diagnostics = "nvim_lsp",
		show_close_icon = false,
		show_buffer_close_icons = false,
		-- numbers = "buffer_id",
		-- number_style = "",
		numbers = function(opts)
			-- SEE: :h bufferline-numbers
			return string.format('%s:', opts.id)
		end,
		separator_style = "thick",
		middle_mouse_command = "b %d | bp | sp | bn | bd"
	}
}

vim.keymap.set("n", "gb", "<cmd>BufferLinePick<cr>")
vim.keymap.set("n", "gB", "<cmd>BufferLinePickClose<cr>")

