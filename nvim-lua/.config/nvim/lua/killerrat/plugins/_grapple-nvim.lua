local p = require("grapple")

p.setup({
		popup_options = {
				width = 100,
		},
})


vim.keymap.set("n", "<leader>a", p.tag, {})
vim.keymap.set("n", "<leader>A", p.open_tags, {})

vim.keymap.set("n", "<leader>h", function() p.select({ index = 1 }) end, { silent = true })
vim.keymap.set("n", "<leader>j", function() p.select({ index = 2 }) end, { silent = true })
vim.keymap.set("n", "<leader>k", function() p.select({ index = 3 }) end, { silent = true })
vim.keymap.set("n", "<leader>l", function() p.select({ index = 4 }) end, { silent = true })

vim.keymap.set("n", "<leader>H", function() vim.cmd[[vsp]]; p.select({ index = 1 }) end, { silent = true })
vim.keymap.set("n", "<leader>J", function() vim.cmd[[vsp]]; p.select({ index = 2 }) end, { silent = true })
vim.keymap.set("n", "<leader>K", function() vim.cmd[[vsp]]; p.select({ index = 3 }) end, { silent = true })
vim.keymap.set("n", "<leader>L", function() vim.cmd[[vsp]]; p.select({ index = 4 }) end, { silent = true })

-- -- vim.keymap.set("n", "<leader>H", ":vsp<cr>:lua require('harpoon.ui').nav_file(1)<cr>", { silent = true })
-- -- vim.keymap.set("n", "<leader>J", ":vsp<cr>:lua require('harpoon.ui').nav_file(2)<cr>", { silent = true })
-- -- vim.keymap.set("n", "<leader>K", ":vsp<cr>:lua require('harpoon.ui').nav_file(3)<cr>", { silent = true })
-- -- vim.keymap.set("n", "<leader>L", ":vsp<cr>:lua require('harpoon.ui').nav_file(4)<cr>", { silent = true })

-- FROM: https://github.com/cbochs/grapple.nvim/issues/72#issuecomment-1822838338
-- clear the autocmd so that we keep the old line number instead of updating it as we move around
-- the file and leave the buffer
-- The problem with removing these is that we never get the cursor position set, it *ONLY* gets set
-- when these are run somehow
-- vim.api.nvim_clear_autocmds({group = "Grapple", event = 'BufLeave'})
-- vim.api.nvim_clear_autocmds({group = "Grapple", event = 'BufWinLeave'})
-- vim.api.nvim_clear_autocmds({group = "Grapple", event = 'QuitPre'})

-- Grapple  BufWinLeave
-- auto commands are created in /home/albert/.local/share/nvim/lazy/grapple.nvim/plugin/grapple.lua
-- want to disable these (the grapple.touch so that it doesn't update the cursor position...

-- https://github.com/cbochs/grapple.nvim/issues/118
