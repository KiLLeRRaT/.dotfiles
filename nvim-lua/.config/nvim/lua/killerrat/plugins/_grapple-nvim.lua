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

