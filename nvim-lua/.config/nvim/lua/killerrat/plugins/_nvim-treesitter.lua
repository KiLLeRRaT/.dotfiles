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
-- -- " let cs_fold=
-- -- " let xml_syntax_folding=1
-- -- let xml_folding=1
-- -- let yaml_fold=1
-- -- let vb_fold=1
-- 	end

-- })
--ENDWORKAROUND

-- :verbose set indentexpr?
-- Guy on the internets output: indentexpr=nvim_treesitter#indent()
-- My output: indentexpr=
-- :checkhealth nvim-treesitter
-- Stock Standard:
-- indentexpr=GetCSIndent(v:lnum)
        -- Last set from /usr/share/nvim/runtime/indent/cs.vim line 19

-- TEMP INDENT SETTINGS TO TEST THINGS
-- vim.opt.autoindent = false
-- vim.opt.smartindent = false
-- vim.opt.expandtab = false
-- vim.opt.tabstop = 2
-- vim.opt.shiftwidth = 2
-- SEE: ftplugin/cs.lua for more lang specifics

-- vim.cmd[[filetype plugin on]]
-- vim.cmd[[filetype indent off]]
-- vim.cmd[[set indentexpr=nvim_treesitter#indent()]]



require'nvim-treesitter.configs'.setup {
	sync_install = #vim.api.nvim_list_uis() == 0,
	ensure_installed = {
		"bash",
		"c",
		"c_sharp",
		"cmake",
		"cpp",
		"css",
		"diff",
		"dockerfile",
		"editorconfig",
		"git_config",
		"go",
		"html",
		"javascript",
		"json",
		"lua",
		"markdown",
		"norg",
		"powershell",
		"python",
		"query",
		"razor",
		"regex",
		"scss",
		"sql",
		"tsx",
		"typescript",
		"vim",
		"yaml",
	},
	indent = {
		enable = true,
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
			-- ["]o"] = "@loop.*",
			["]o"] = { query = { "@loop.inner", "@loop.outer" } },
			--
			-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
			-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
			["]S"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
			["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
		 },
		 goto_next_end = {
			["]M"] = "@function.outer",
			["]["] = "@class.outer",
			-- ["]O"] = "@loop.*",
			["]O"] = { query = { "@loop.inner", "@loop.outer" } },
		 },
		 goto_previous_start = {
			["[m"] = "@function.outer",
			["[["] = "@class.outer",
			-- ["[o"] = "@loop.*",
			["[o"] = { query = { "@loop.inner", "@loop.outer" } },
			["[S"] = { query = "@scope", query_group = "locals", desc = "Prev scope" },
			["[z"] = { query = "@fold", query_group = "folds", desc = "Prev fold" },
		 },
		 goto_previous_end = {
			["[M"] = "@function.outer",
			["[]"] = "@class.outer",
			-- ["[O"] = "@loop.*",
			["[O"] = { query = { "@loop.inner", "@loop.outer" } },
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
	 playground = {
		enable = true,
		disable = {},
		updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
		persist_queries = false, -- Whether the query persists across vim sessions
		keybindings = {
		 toggle_query_editor = 'o',
		 toggle_hl_groups = 'i',
		 toggle_injected_languages = 't',
		 toggle_anonymous_nodes = 'a',
		 toggle_language_display = 'I',
		 focus_language = 'f',
		 unfocus_language = 'F',
		 update = 'R',
		 goto_node = '<cr>',
		 show_help = '?',
		},
	 }
	}


 -- THE BELOW IS NOT WORKING, IT BREAKS THE DOT COMMAND WHEN YOURE TRYING TO DOT REPEAT SOMETHING
 -- DONE WITH T OR F
	-- local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
	-- Repeat movement with ; and ,
	-- ensure ; goes forward and , goes backward regardless of the last direction

	-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
	-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

	-- vim way: ; goes to the direction you were moving.
	-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
	-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

	-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
	-- vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
	-- vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
	-- vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
	-- vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
 -- THE BELOW IS NOT WORKING, IT BREAKS THE DOT COMMAND WHEN YOURE TRYING TO DOT REPEAT SOMETHING
 -- DONE WITH T OR F

