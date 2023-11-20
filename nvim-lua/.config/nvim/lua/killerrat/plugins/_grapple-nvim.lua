vim.keymap.set("n", "<leader>a", require("grapple").tag, {})
vim.keymap.set("n", "<leader>A", require("grapple").popup_tags, {})

vim.keymap.set("n", "<leader>h", function() require('grapple').select({ key = 1 }) end, { silent = true })
vim.keymap.set("n", "<leader>j", function() require('grapple').select({ key = 2 }) end, { silent = true })
vim.keymap.set("n", "<leader>k", function() require('grapple').select({ key = 3 }) end, { silent = true })
vim.keymap.set("n", "<leader>l", function() require('grapple').select({ key = 4 }) end, { silent = true })

vim.keymap.set("n", "<leader>H", function() vim.cmd[[vsp]]; require('grapple').select({ key = 1 }) end, { silent = true })
vim.keymap.set("n", "<leader>J", function() vim.cmd[[vsp]]; require('grapple').select({ key = 2 }) end, { silent = true })
vim.keymap.set("n", "<leader>K", function() vim.cmd[[vsp]]; require('grapple').select({ key = 3 }) end, { silent = true })
vim.keymap.set("n", "<leader>L", function() vim.cmd[[vsp]]; require('grapple').select({ key = 4 }) end, { silent = true })

-- vim.keymap.set("n", "<leader>H", ":vsp<cr>:lua require('harpoon.ui').nav_file(1)<cr>", { silent = true })
-- vim.keymap.set("n", "<leader>J", ":vsp<cr>:lua require('harpoon.ui').nav_file(2)<cr>", { silent = true })
-- vim.keymap.set("n", "<leader>K", ":vsp<cr>:lua require('harpoon.ui').nav_file(3)<cr>", { silent = true })
-- vim.keymap.set("n", "<leader>L", ":vsp<cr>:lua require('harpoon.ui').nav_file(4)<cr>", { silent = true })



