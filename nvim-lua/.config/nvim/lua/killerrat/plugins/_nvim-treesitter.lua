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
				["am"] = "@function.outer",
				["im"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		swap = {
		 enable = true,
		 swap_next = {
			["<leader>pn"] = "@parameter.inner",
		 },
		 swap_previous = {
			["<leader>pp"] = "@parameter.inner",
		 },
		},
		move = {
		 enable = true,
		 set_jumps = true, -- whether to set jumps in the jumplist
		 goto_next_start = {
			["]m"] = "@function.outer",
			["]]"] = { query = "@class.outer", desc = "Next class start" },
			--
			-- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
			["]o"] = "@loop.*",
			-- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
			--
			-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
			-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
			["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
			["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
		 },
		 goto_next_end = {
			["]M"] = "@function.outer",
			["]["] = "@class.outer",
		 },
		 goto_previous_start = {
			["[m"] = "@function.outer",
			["[["] = "@class.outer",
		 },
		 goto_previous_end = {
			["[M"] = "@function.outer",
			["[]"] = "@class.outer",
		 },
		 -- Below will go to either the start or the end, whichever is closer.
		 -- Use if you want more granular movements
		 -- Make it even more gradual by adding multiple queries and regex.
		 goto_next = {
			["]d"] = "@conditional.outer",
		 },
		 goto_previous = {
			["[d"] = "@conditional.outer",
		 }
		},
	 },
	}

local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"

-- Repeat movement with ; and ,
-- ensure ; goes forward and , goes backward regardless of the last direction
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

-- vim way: ; goes to the direction you were moving.
-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)

