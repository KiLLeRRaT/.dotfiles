-- " GIT SIGNS: https://github.com/lewis6991/gitsigns.nvim
require('gitsigns').setup{
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		-- Navigation
		vim.keymap.set('n', ']h', function()
			if vim.wo.diff then return ']h' end
			vim.schedule(function() gs.next_hunk() end)
			return '<Ignore>'
		end, {expr=true})

		vim.keymap.set('n', '[h', function()
			if vim.wo.diff then return '[h' end
			vim.schedule(function() gs.prev_hunk() end)
			return '<Ignore>'
		end, {expr=true})

		-- Actions
		vim.keymap.set('n', '<leader>ds', gs.stage_hunk)
		vim.keymap.set('n', '<leader>dr', gs.reset_hunk)
		vim.keymap.set('v', '<leader>ds', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
		vim.keymap.set('v', '<leader>dr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)

		vim.keymap.set('n', '<leader>dS', gs.stage_buffer)
		vim.keymap.set('n', '<leader>du', gs.undo_stage_hunk)
		vim.keymap.set('n', '<leader>dR', gs.reset_buffer)
		vim.keymap.set('n', '<leader>dp', gs.preview_hunk)
		vim.keymap.set('n', '<leader>dB', function() gs.blame_line{full=true} end)
		vim.keymap.set("n", "<leader>db", gs.toggle_current_line_blame)
		vim.keymap.set('n', '<leader>dd', gs.diffthis)
		vim.keymap.set('n', '<leader>dD', function() gs.diffthis('~') end)
		-- vim.keymap.set('n', '<leader>td', gs.toggle_deleted)

		-- Text object
		vim.keymap.set({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
	end
}
