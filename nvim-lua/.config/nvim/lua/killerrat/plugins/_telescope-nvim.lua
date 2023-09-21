if not _G.plugin_loaded("telescope.nvim") then
	do return end
end

local p = require("telescope")
local actions = require "telescope.actions"

p.setup {
	extensions = {
	},
	pickers = {
		buffers = {
			mappings = {
				i = {
					["<c-d>"] = actions.delete_buffer + actions.move_to_top,
				}
			}
		}
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
				-- ["<C-x>"] = actions.select_horizontal,
				-- ["<C-v>"] = actions.select_vertical,
				["<C-i>"] = actions.select_horizontal,
				["<C-s>"] = actions.select_vertical,
			},
		},
	},
}





p.load_extension('fzf')


-- " TELESCOPE
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
vim.keymap.set("n", "<leader>f.", "<cmd>Telescope resume<cr>")

-- nnoremap <leader>ff <cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files<cr>
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files<cr>")
vim.keymap.set("n", "<leader>FF", "<cmd>Telescope find_files find_command=rg,--no-ignore,--hidden,--files<cr>")
-- nnoremap <leader>fF :execute 'Telescope find_files default_text=' . "'" . expand('<cword>')<cr>
vim.keymap.set("n", "<leader>fF", ":execute 'Telescope find_files default_text=' . '''' . expand('<cword>')<cr>")
-- nnoremap <leader>fg <cmd>Telescope live_grep<cr>
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
-- nnoremap <leader>fG :execute 'Telescope live_grep default_text=' . expand('<cword>')<cr>
vim.keymap.set("n", "<leader>fG", ":execute 'Telescope live_grep default_text=' . expand('<cword>')<cr>")

-- nnoremap <leader>fR <cmd>lua require("telescope").extensions.live_grep_args.live_grep_args()<cr>
-- vim.keymap.set("n", "<leader>fr", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>")
vim.keymap.set("n", "<leader>fr", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args({ default_text = '--hidden ' })<cr>")

-- FROM: https://github.com/nvim-telescope/telescope-live-grep-args.nvim/issues/9
--vim.keymap.set("n", "<leader>fr", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args({ default_text = '--hidden', prompt_title = 'Live Grep (Args)', vimgrep_arguments = { " ..
--	"'rg', " ..
--	--"'--hidden', " ..
--	"'--color=never', " ..
--	"'--no-heading', " ..
--	"'--with-filename', " ..
--	"'--line-number', " ..
--	"'--column', " ..
--	"'--smart-case', " ..
--"} })<cr>")

-- nnoremap <leader>fb <cmd>Telescope buffers<cr>
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
-- nnoremap <leader>fk <cmd>Telescope help_tags<cr>
vim.keymap.set("n", "<leader>fk", "<cmd>Telescope help_tags<cr>")
-- nnoremap <leader>fm <cmd>Telescope keymaps<cr>
vim.keymap.set("n", "<leader>fm", "<cmd>Telescope keymaps<cr>")
-- nnoremap <leader>fc <cmd>Telescope git_commits<cr>
vim.keymap.set("n", "<leader>fc", "<cmd>Telescope git_commits<cr>")
-- nnoremap <leader>fr <cmd>Telescope git_branches<cr>
vim.keymap.set("n", "<leader>fB", "<cmd>Telescope git_branches<cr>")
-- nnoremap <leader>fs <cmd>Telescope colorscheme<cr>
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope colorscheme<cr>")
-- nnoremap <leader>fh <cmd>Telescope help_tags<cr>
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")

-- " OVERRIDES THE STANDARD z= shortcut!
-- nnoremap z= <cmd>Telescope spell_suggest<cr>
vim.keymap.set("n", "z=", "<cmd>Telescope spell_suggest<cr>")

-- " SEARCH MY OWN GBOX SCRIPTS
-- lua require("killerrat")
vim.keymap.set("n", "<leader>sf", ":lua require('killerrat.plugins._telescope-nvim').search_scripts()<CR>")
vim.keymap.set("n", "<leader>sg", ":lua require('killerrat.plugins._telescope-nvim').grep_scripts()<CR>")


-- FOR NON TELESCOPE LSP MAPPINGS, SEE: nvim-lua/.config/nvim/lua/killerrat/remap.lua
vim.keymap.set("n", "gd", ":Telescope lsp_definitions<CR>")
vim.keymap.set("n", "gr", ":Telescope lsp_references<CR>")
vim.keymap.set("n", "<leader>fd", ":Telescope diagnostics<CR>")
-- FOR NON TELESCOPE LSP MAPPINGS, SEE: nvim-lua/.config/nvim/lua/killerrat/remap.lua



-- CUSTOM TELESCOPE SEARCHES
local M = {}
M.search_scripts = function()
	require("telescope.builtin").find_files({
		prompt_title = "< Search Scripts >",
		cwd = "~/GBox/Applications/Tools/Scripts",
		hidden = false,
	})
end

M.grep_scripts = function()
	require("telescope.builtin").live_grep({
		prompt_title = "< Grep Scripts >",
		cwd = "~/GBox/Applications/Tools/Scripts",
		hidden = false,
	})
end

return M
-- /CUSTOM TELESCOPE SEARCHES




