local p = require("telescope")
local actions = require "telescope.actions"

-- DUMP LUA TABLE TO STRING
-- local action_state = require "telescope.actions.state"
-- local state = require "telescope.state"
-- https://stackoverflow.com/a/27028488/182888
-- local function dump(o)
--    if type(o) == 'table' then
--       local s = '{ '
--       for k,v in pairs(o) do
--          if type(k) ~= 'number' then k = '"'..k..'"' end
--          s = s .. '['..k..'] = ' .. dump(v) .. ','
--       end
--       return s .. '} '
--    else
--       return tostring(o)
--    end
-- end

-- FROM: https://github.com/nvim-telescope/telescope.nvim/issues/2160#issuecomment-2452730363
local current_prompt_text = function()
	for _, bufnr in ipairs(vim.fn.tabpagebuflist()) do
		if vim.bo[bufnr].filetype == 'TelescopePrompt' then
			local action_state = require('telescope.actions.state')
			return action_state.get_current_picker(bufnr):_get_prompt()
		end
	end
	return ''
end

local currentPicker = nil
local findFiles = function()
	currentPicker = "findFiles"
	require("telescope.builtin").find_files({ default_text = current_prompt_text(), find_command = {"rg", "--files", "--hidden", "--glob", "!**/.git/*"}, })
end
local findGrep = function()
	currentPicker = "findGrep"
	-- require('telescope').extensions.live_grep_args.live_grep_args({ wrap_results = true, default_text = current_prompt_text() })
	require('telescope').extensions.live_grep_args.live_grep_args({ default_text = current_prompt_text() })
end

local nextPicker = function()
	if currentPicker == "findFiles" then
		findGrep()
	else
		findFiles()
	end
end

p.setup {
	extensions = {
	},
	pickers = {
		-- lsp_references = { fname_width = 30 },
		buffers = {
			mappings = {
				i = {
					["<c-d>"] = actions.delete_buffer + actions.move_to_top,
				}
			}
		}
	},
	defaults = {
		layout_strategy = 'flex',
		layout_config = {
			vertical = { width = 0.99, height = 0.99, preview_height = 0.5 },
			horizontal = { width = 0.99, height = 0.99, preview_width = 120 },
			flex = { width = 0.9, flip_columns = 220 }
		},
		-- path_display = { "filename_first" },
		path_display = {
			filename_first = {
			  reverse_directories = true
			}
		},
		mappings = {
			i = {
				["<C-space>"] = function(prompt_bufnr)
					local opts = {
						callback = actions.toggle_selection,
						loop_callback = actions.send_selected_to_qflist,
					}
				end,
				["<C-n>"] = actions.move_selection_next,
				["<C-p>"] = actions.move_selection_previous,

				["<C-c>"] = actions.close,

				["<Down>"] = actions.move_selection_next,
				["<Up>"] = actions.move_selection_previous,

				["<CR>"] = actions.select_default,
				["<C-i>"] = actions.select_horizontal,
				["<C-s>"] = actions.select_vertical,
				-- ["<C-x>"] = actions.select_horizontal,
				-- ["<C-v>"] = actions.select_vertical,
				["<C-t>"] = actions.select_tab,

				["<C-u>"] = actions.preview_scrolling_up,
				["<C-d>"] = actions.preview_scrolling_down,
				["<C-h>"] = actions.preview_scrolling_left,
				["<C-l>"] = actions.preview_scrolling_right,

				["<PageUp>"] = actions.results_scrolling_up,
				["<PageDown>"] = actions.results_scrolling_down,
				["<M-f>"] = actions.results_scrolling_left,
				["<M-k>"] = actions.results_scrolling_right,

				["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
				["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
				["<C-f>"] = nextPicker,
				["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
				["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
				-- NOT USING THE BELOW, MAYBE ONE DAY FIGURE IT OUT, FOR NOW STEALING THE KEY
				-- BINDING.
				-- ["<C-l>"] = actions.complete_tag,
				["<C-/>"] = actions.which_key,
				["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
				["<C-w>"] = { "<c-s-w>", type = "command" },
			},
		},
	},
}




p.load_extension('fzf')


-- " TELESCOPE
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
vim.keymap.set("n", "<leader>f.", "<cmd>Telescope resume<cr>")

-- vim.keymap.set('n', '<leader>ff', function() require("telescope.builtin").find_files({ default_text = current_prompt_text(), find_command = {"rg", "--files", "--hidden", "--glob", "!**/.git/*"}, }) end)
vim.keymap.set('n', '<leader>ff', findFiles)
-- vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files<cr>")

-- vim.keymap.set("n", "<leader>FF", "<cmd>Telescope find_files find_command=rg,--no-ignore,--hidden,--files<cr>")
vim.keymap.set("n", "<leader>fF", ":execute 'Telescope find_files default_text=' . '''' . expand('<cword>')<cr>")

-- vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
-- vim.keymap.set("n", "<leader>fg", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args({ default_text = '' })<cr>")
-- vim.keymap.set("n", "<leader>fg", function() require('telescope').extensions.live_grep_args.live_grep_args({ default_text = current_prompt_text() }) end)
vim.keymap.set("n", "<leader>fg", findGrep)

-- vim.keymap.set("n", "<leader>fG", ":execute 'Telescope live_grep default_text=' . expand('<cword>')<cr>")
-- vim.keymap.set("n", "<leader>fG", ":execute 'Telescope live_grep default_text=' . expand('<cword>')<cr>")
local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")
vim.keymap.set("n", "<leader>fG", live_grep_args_shortcuts.grep_word_under_cursor)

-- vim.keymap.set("n", "<leader>fr", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args({ default_text = '--hidden ' })<cr>")
-- vim.keymap.set("n", "<leader>fr", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args({ default_text = '' })<cr>")

vim.keymap.set("n", "<leader>ft", ":execute 'Telescope live_grep default_text=TODO-?.*:'<cr>")

-- Search open files only
vim.keymap.set("n", "<leader>fo", ":execute 'Telescope live_grep grep_open_files=true'<cr>")
vim.keymap.set("n", "<leader>fO", ":execute 'Telescope live_grep grep_open_files=true default_text=' . expand('<cword>')<cr>")


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

vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
vim.keymap.set("n", "<leader>fk", "<cmd>Telescope help_tags<cr>")
vim.keymap.set("n", "<leader>fm", "<cmd>Telescope marks<cr>")
vim.keymap.set("n", "<leader>fM", "<cmd>Telescope keymaps<cr>")
vim.keymap.set("n", "<leader>fc", "<cmd>Telescope git_commits<cr>")
vim.keymap.set("n", "<leader>fB", "<cmd>Telescope git_branches<cr>")
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope colorscheme<cr>")
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")

-- " OVERRIDES THE STANDARD z= shortcut!
-- nnoremap z= <cmd>Telescope spell_suggest<cr>
vim.keymap.set("n", "z=", "<cmd>Telescope spell_suggest<cr>")

-- " SEARCH MY OWN GBOX SCRIPTS
-- lua require("killerrat")
vim.keymap.set("n", "<leader>sf", ":lua require('killerrat.plugins._telescope-nvim').search_scripts()<CR>")
vim.keymap.set("n", "<leader>sg", ":lua require('killerrat.plugins._telescope-nvim').grep_scripts()<CR>")


-- FOR NON TELESCOPE LSP MAPPINGS, SEE: nvim-lua/.config/nvim/lua/killerrat/remap.lua
vim.keymap.set("n", "gd", ":Telescope lsp_definitions<CR>") -- ALSO SEE ../../../after/ftplugin/cs.lua
vim.keymap.set("n", "gr", ":Telescope lsp_references<CR>")

-- vim.keymap.set("n", "gr", ":lua require('telescope.builtin').lsp_references({fname_width = " .. get_fname_width() .. "})<CR>")
vim.keymap.set("n", "gr", ":lua require('killerrat.plugins._telescope-nvim').lsp_references()<CR>")
vim.keymap.set("n", "<leader>fd", ":Telescope diagnostics<CR>")
-- FOR NON TELESCOPE LSP MAPPINGS, SEE: nvim-lua/.config/nvim/lua/killerrat/remap.lua



-- CUSTOM TELESCOPE SEARCHES
local M = {}
M.search_scripts = function()
	require("telescope.builtin").find_files({
		prompt_title = "< Search Scripts >",
		cwd = "~/scripts",
		hidden = false,
	})
end

M.grep_scripts = function()
	require("telescope.builtin").live_grep({
		prompt_title = "< Grep Scripts >",
		cwd = "~/scripts",
		hidden = false,
	})
end

M.lsp_references = function()
	-- get pane width from tmux and use half the width for the fname_width
	local fname_width = math.floor(vim.fn.system("tmux display -p '#{pane_width}'") / 3)
	-- Maybe running outside of tmux
	if fname_width == 0 then
		fname_width = 30
	end
	require('telescope.builtin').lsp_references({fname_width = fname_width })
end

return M
-- /CUSTOM TELESCOPE SEARCHES




