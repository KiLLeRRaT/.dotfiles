if not _G.plugin_loaded("nvim-treesitter") then
	do return end
end

-- FROM: https://github.com/nvim-treesitter/nvim-treesitter/wiki/Installation
-- vim.opt.foldmethod			= 'expr'
-- vim.opt.foldexpr				= 'nvim_treesitter#foldexpr()'
---WORKAROUND
-- vim.api.nvim_create_autocmd({'BufEnter','BufAdd','BufNew','BufNewFile','BufWinEnter'}, {
-- 	group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
-- 	callback = function()
-- 		vim.opt.foldmethod = 'expr'
-- 		vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
-- 		vim.opt.foldcolumn = "1" -- DEFINES 1 COL AT WINDW LEFT TO INDICATE FOLDING
-- 		vim.opt.foldlevelstart = 99 -- START FILE WITH ALL FOLDS OPENED

-- -- let javaScript_fold=1 "activate folding by JS syntax
-- -- " let cs_fold=1
-- -- " let xml_syntax_folding=1
-- -- let xml_folding=1
-- -- let yaml_fold=1
-- -- let vb_fold=1
-- 	end

-- })
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

