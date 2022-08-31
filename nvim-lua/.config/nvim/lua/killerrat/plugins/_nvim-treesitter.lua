if not _G.plugin_loaded("nvim-treesitter") then
	do return end
end

-- FROM: https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation
-- vim.opt.foldmethod			= 'expr'
-- vim.opt.foldexpr				= 'nvim_treesitter#foldexpr()'
---WORKAROUND
vim.api.nvim_create_autocmd({'BufEnter','BufAdd','BufNew','BufNewFile','BufWinEnter'}, {
	group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
	callback = function()
		vim.opt.foldmethod		 = 'expr'
		vim.opt.foldexpr			 = 'nvim_treesitter#foldexpr()'
	end
})
--ENDWORKAROUND

require'nvim-treesitter.configs'.setup {
	ensure_installed = {
		"c_sharp",
		"bash",
		"css",
		"html",
		"javascript",
		"json",
		"lua",
		"python",
		"regex",
		"scss",
		"tsx",
		"typescript",
		"vim",
		"yaml"
	},
	highlight = {
		enable = true,
	},
	textobjects = {
		select = {
			enable = true,

			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,

			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
	},
}

