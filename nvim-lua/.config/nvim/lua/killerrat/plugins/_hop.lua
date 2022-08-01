print("lets hop around!")
if not _G.plugin_loaded("hop.nvim") then
	print("plugin not loaded, bail1")
	do return end
end

local p = require("hop")

p.setup {
	 keys = 'asdfghjkl;qwertyuiopzxcvbnm', jump_on_sole_occurrence = false
}

vim.keymap.set("n", "<leader>w", "<cmd>HopWord<cr>")
vim.keymap.set("n", "<leader>W", "<cmd>HopWordMW<cr>")
