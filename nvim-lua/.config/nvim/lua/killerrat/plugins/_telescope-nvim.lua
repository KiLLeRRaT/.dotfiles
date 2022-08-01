if not _G.plugin_loaded("telescope.nvim") then
	do return end
end

local p = require("telescope")

p.setup {
	extensions = {
	},
	defaults = {
		layout_strategy = 'vertical',
		layout_config = {
			vertical = { width = 0.99, height = 0.99 },
			horizontal = { width = 0.99, height = 0.99 }
		},
		mappings = {
			i = {
				["<C-space>"] = function(prompt_bufnr)
					local opts = {
						callback = actions.toggle_selection,
						loop_callback = actions.send_selected_to_qflist,
					}
				end,
			},
		},
	},
}

p.load_extension('fzf')

-- " TELESCOPE
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
