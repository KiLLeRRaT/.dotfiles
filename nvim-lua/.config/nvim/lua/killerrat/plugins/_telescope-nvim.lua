-- If plugin is not loaded (e.g. disabled), skip this file!
-- print ("Plugin: " .. _G.packer_plugins)
if not _G.plugin_loaded("telescope.nvim") then
	do return end
end

local telescope = require("telescope")

telescope.setup {
	extensions = {
		-- hop = {
		-- 	-- the shown `keys` are the defaults, no need to set `keys` if defaults work for you ;)
		-- 	keys = {"a", "s", "d", "f", "g", "h", "j", "k", "l", ";",
		-- 					"q", "w", "e", "r", "t", "y", "u", "i", "o", "p",
		-- 					"A", "S", "D", "F", "G", "H", "J", "K", "L", ":",
		-- 					"Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", },
	-- -- Highlight groups to link to signs and lines; the below configuration refers to demo
		-- 	-- sign_hl typically only defines foreground to possibly be combined with line_hl
		-- 	sign_hl = { "WarningMsg", "Title" },
		-- 	-- optional, typically a table of two highlight groups that are alternated between
		-- 	line_hl = { "CursorLine", "Normal" },
	-- -- options specific to `hop_loop`
		-- 	-- true temporarily disables Telescope selection highlighting
		-- 	clear_selection_hl = false,
		-- 	-- highlight hopped to entry with telescope selection highlight
		-- 	-- note: mutually exclusive with `clear_selection_hl`
		-- 	trace_entry = true,
		-- 	-- jump to entry where hoop loop was started from
		-- 	reset_selection = true,
		-- },
	},
	defaults = {
		layout_strategy = 'vertical',
		layout_config = {
			vertical = { width = 0.99, height = 0.99 },
			horizontal = { width = 0.99, height = 0.99 }
		},
		mappings = {
			i = {
				-- IMPORTANT
				-- either hot-reloaded or `function(prompt_bufnr) telescope.extensions.hop.hop end`
				-- ["<C-h>"] = R("telescope").extensions.hop.hop,  -- hop.hop_toggle_selection
				-- custom hop loop to multi selects and sending selected entries to quickfix list
				["<C-space>"] = function(prompt_bufnr)
					local opts = {
						callback = actions.toggle_selection,
						loop_callback = actions.send_selected_to_qflist,
					}
					-- require("telescope").extensions.hop._hop_loop(prompt_bufnr, opts)
				end,
			},
		},
	},
}

-- telescope.load_extension('hop')
telescope.load_extension('fzf')
-- telescope.load_extension('coc')
-- telescope.load_extension("ui-select")

--local M = {}
--M.search_scripts = function()
--	require("telescope.builtin").find_files({
--		prompt_title = "< Search Scripts >",
--		cwd = "C:/GBox/Applications/Tools/Scripts",--vim.env.DOTFILES,
--		--cwd = vim.env.DOTFILES,
--		hidden = false,
--	})
--end

--M.grep_scripts = function()
--	require("telescope.builtin").live_grep({
--		prompt_title = "< Grep Scripts >",
--		cwd = "C:/GBox/Applications/Tools/Scripts",--vim.env.DOTFILES,
--		--cwd = vim.env.DOTFILES,
--		hidden = false,
--	})
--end

--return M



--local M = {}
--M.search_scripts = function()
--	require("telescope.builtin").find_files({
--		prompt_title = "< Search Scripts >",
--		cwd = "C:/GBox/Applications/Tools/Scripts",--vim.env.DOTFILES,
--		--cwd = vim.env.DOTFILES,
--		hidden = false,
--	})
--end

--M.grep_scripts = function()
--	require("telescope.builtin").live_grep({
--		prompt_title = "< Grep Scripts >",
--		cwd = "C:/GBox/Applications/Tools/Scripts",--vim.env.DOTFILES,
--		--cwd = vim.env.DOTFILES,
--		hidden = false,
--	})
--end

--return M

-- " TELESCOPE
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- " nnoremap <leader>ff <cmd>Telescope find_files<cr>
-- nnoremap <leader>ff <cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files<cr>
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files<cr>")
-- nnoremap <leader>fF :execute 'Telescope find_files default_text=' . "'" . expand('<cword>')<cr>
vim.keymap.set("n", "<leader>fF", ":execute 'Telescope find_files default_text=' . '''' . expand('<cword>')<cr>")
-- nnoremap <leader>fg <cmd>Telescope live_grep<cr>
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
-- nnoremap <leader>fG :execute 'Telescope live_grep default_text=' . expand('<cword>')<cr>
vim.keymap.set("n", "<leader>fG", ":execute 'Telescope live_grep default_text=' . expand('<cword>')<cr>")

-- nnoremap <leader>fR <cmd>lua require("telescope").extensions.live_grep_args.live_grep_args()<cr>
vim.keymap.set("n", "<leader>fR", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>")

-- nnoremap <leader>fb <cmd>Telescope buffers<cr>
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
-- nnoremap <leader>fk <cmd>Telescope help_tags<cr>
vim.keymap.set("n", "<leader>fk", "<cmd>Telescope help_tags<cr>")
-- nnoremap <leader>fm <cmd>Telescope keymaps<cr>
vim.keymap.set("n", "<leader>fm", "<cmd>Telescope keymaps<cr>")
-- nnoremap <leader>fc <cmd>Telescope git_commits<cr>
vim.keymap.set("n", "<leader>fc", "<cmd>Telescope git_commits<cr>")
-- nnoremap <leader>fr <cmd>Telescope git_branches<cr>
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope git_branches<cr>")
-- " nnoremap <leader>fs <cmd>Telescope git_status<cr>
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope git_status<cr>")
-- nnoremap <leader>fs <cmd>Telescope colorscheme<cr>
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope colorscheme<cr>")
-- nnoremap <leader>fh <cmd>Telescope help_tags<cr>
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")

-- " OVERRIDES THE STANDARD z= shortcut!
-- nnoremap z= <cmd>Telescope spell_suggest<cr>
vim.keymap.set("n", "z=", "<cmd>Telescope spell_suggest<cr>")

-- " SEARCH MY OWN GBOX SCRIPTS
-- lua require("killerrat")
-- nnoremap <leader>sf :lua require('killerrat.telescope').search_scripts()<CR>
-- nnoremap <leader>sg :lua require('killerrat.telescope').grep_scripts()<CR>
