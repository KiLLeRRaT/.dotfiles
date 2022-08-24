if not _G.plugin_loaded("gitsigns.nvim") then
	do return end
end


-- " GIT SIGNS: https://github.com/lewis6991/gitsigns.nvim
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- lua require('gitsigns').setup()
-- " Navigation
-- " nnoremap ]c :Gitsigns next_hunk<cr>
-- " nnoremap [c :Gitsigns prev_hunk<cr>
-- nnoremap ]h :Gitsigns next_hunk<cr>
-- nnoremap [h :Gitsigns prev_hunk<cr>

--     " -- Actions
-- nnoremap <leader>ds :Gitsigns stage_hunk<cr>

-- " REPLACE ^M AFTER RESET HUNK
-- nnoremap <leader>dr :Gitsigns reset_hunk<cr>:%s/\r<cr>

--     " map('n', '<leader>hS', gs.stage_buffer)
-- nnoremap <leader>du :Gitsigns undo_stage_hunk<cr>
--     " map('n', '<leader>hR', gs.reset_buffer)
-- nnoremap <leader>dp :Gitsigns preview_hunk<cr>
-- " nnoremap <leader>hb :Gitsigns blame_line{full=true}<cr>
-- nnoremap <leader>db :Gitsigns toggle_current_line_blame<cr>

--     " map('n', '<leader>hb', function() gs.blame_line{full=true} end)
--     " map('n', '<leader>tb', gs.toggle_current_line_blame)
--     " map('n', '<leader>hd', gs.diffthis)
--     " map('n', '<leader>hD', function() gs.diffthis('~') end)
--     " map('n', '<leader>td', gs.toggle_deleted)

-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- " /GIT SIGNS

-- -- " TELESCOPE
-- -- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- -- nnoremap <leader>ff <cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files<cr>
-- vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files<cr>")
-- -- nnoremap <leader>fF :execute 'Telescope find_files default_text=' . "'" . expand('<cword>')<cr>
-- vim.keymap.set("n", "<leader>fF", ":execute 'Telescope find_files default_text=' . '''' . expand('<cword>')<cr>")
-- -- nnoremap <leader>fg <cmd>Telescope live_grep<cr>
-- vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
-- -- nnoremap <leader>fG :execute 'Telescope live_grep default_text=' . expand('<cword>')<cr>
-- vim.keymap.set("n", "<leader>fG", ":execute 'Telescope live_grep default_text=' . expand('<cword>')<cr>")

-- -- nnoremap <leader>fR <cmd>lua require("telescope").extensions.live_grep_args.live_grep_args()<cr>
-- vim.keymap.set("n", "<leader>fR", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>")

-- -- nnoremap <leader>fb <cmd>Telescope buffers<cr>
-- vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
-- -- nnoremap <leader>fk <cmd>Telescope help_tags<cr>
-- vim.keymap.set("n", "<leader>fk", "<cmd>Telescope help_tags<cr>")
-- -- nnoremap <leader>fm <cmd>Telescope keymaps<cr>
-- vim.keymap.set("n", "<leader>fm", "<cmd>Telescope keymaps<cr>")
-- -- nnoremap <leader>fc <cmd>Telescope git_commits<cr>
-- vim.keymap.set("n", "<leader>fc", "<cmd>Telescope git_commits<cr>")
-- -- nnoremap <leader>fr <cmd>Telescope git_branches<cr>
-- vim.keymap.set("n", "<leader>fr", "<cmd>Telescope git_branches<cr>")
-- -- nnoremap <leader>fs <cmd>Telescope colorscheme<cr>
-- vim.keymap.set("n", "<leader>fs", "<cmd>Telescope colorscheme<cr>")
-- -- nnoremap <leader>fh <cmd>Telescope help_tags<cr>
-- vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")

-- -- " OVERRIDES THE STANDARD z= shortcut!
-- -- nnoremap z= <cmd>Telescope spell_suggest<cr>
-- vim.keymap.set("n", "z=", "<cmd>Telescope spell_suggest<cr>")

-- -- " SEARCH MY OWN GBOX SCRIPTS
-- -- lua require("killerrat")
-- -- nnoremap <leader>sf :lua require('killerrat.telescope').search_scripts()<CR>
-- vim.keymap.set("n", "<leader>sf", ":lua require('killerrat.plugins._telescope-nvim').search_scripts()<CR>")
-- -- nnoremap <leader>sg :lua require('killerrat.telescope').grep_scripts()<CR>
-- vim.keymap.set("n", "<leader>sg", ":lua require('killerrat.plugins._telescope-nvim').grep_scripts()<CR>")

-- -- CUSTOM TELESCOPE SEARCHES
-- local M = {}
-- M.search_scripts = function()
-- 	require("telescope.builtin").find_files({
-- 		prompt_title = "< Search Scripts >",
-- 		cwd = "C:/GBox/Applications/Tools/Scripts",
-- 		hidden = false,
-- 	})
-- end

-- M.grep_scripts = function()
-- 	require("telescope.builtin").live_grep({
-- 		prompt_title = "< Grep Scripts >",
-- 		cwd = "C:/GBox/Applications/Tools/Scripts",
-- 		hidden = false,
-- 	})
-- end

-- return M
-- -- /CUSTOM TELESCOPE SEARCHES




