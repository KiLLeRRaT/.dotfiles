require('mini.comment').setup {
	options = {
		custom_commentstring = function()
			return require('ts_context_commentstring').calculate_commentstring() or vim.bo.commentstring
		end,
	},
}
