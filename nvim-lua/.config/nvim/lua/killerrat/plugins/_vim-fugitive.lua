-- if not _G.plugin_loaded("vim-fugitive") then
-- 	print("vim-fugitive not installed")
-- 	do return end
-- end

vim.keymap.set("n", "<leader>gs", ":Git<cr>")
vim.keymap.set("n", "<leader>gS", ":Git pull<cr>:Git push<cr>")
vim.keymap.set("n", "<leader>gp", ":Git push<cr>")
vim.keymap.set("n", "<leader>gpp", ":Git push<cr>")
vim.keymap.set("n", "<leader>gpt", ":Git push --tags<cr>")
vim.keymap.set("n", "<leader>gpT", ":Git push<cr>:Git push --tags<cr>")
vim.keymap.set("n", "<leader>gP", ":Git push --force-with-lease<cr>")
vim.keymap.set("n", "<leader>gf", ":Git fetch<cr>")
vim.keymap.set("n", "<leader>gl", ":Git pull<cr>")
vim.keymap.set("n", "<leader>gbb", ":Git branch<cr>")
vim.keymap.set("n", "<leader>gba", ":Git branch --all<cr>")
vim.keymap.set("n", "<leader>gbr", ":Git branch --remote<cr>")
vim.keymap.set("n", "<leader>gbd", ":Git branch -d")
vim.keymap.set("n", "<leader>gbD", ":Git branch -D")
vim.keymap.set("n", "<leader>gco", ":Git checkout<space>")
vim.keymap.set("n", "<leader>gT", ":Git tag<cr>")
vim.keymap.set("n", "<leader>gt", ":Git tag<space>")
