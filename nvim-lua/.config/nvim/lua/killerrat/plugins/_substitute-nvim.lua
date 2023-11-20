require("substitute").setup {
	on_substitute = nil,
	yank_substituted_text = false,
	range = {
		prefix = "s",
		prompt_current_text = false,
		confirm = false,
		complete_word = false,
		motion1 = false,
		motion2 = false,
		suffix = "",
	},
	exchange = {
		motion = false,
	},
}

vim.keymap.set("n", "s", "<cmd>lua require('substitute').operator()<cr>", { noremap = true })
vim.keymap.set("n", "ss", "<cmd>lua require('substitute').line()<cr>", { noremap = true })
vim.keymap.set("n", "S", "<cmd>lua require('substitute').eol()<cr>", { noremap = true })
vim.keymap.set("x", "s", "<cmd>lua require('substitute').visual()<cr>", { noremap = true })


-- vim.keymap.set("n", "<leader>s", "<cmd>lua require('substitute.range').operator()<cr>", { noremap = true })
-- vim.keymap.set("x", "<leader>s", "<cmd>lua require('substitute.range').visual()<cr>", { noremap = true })
-- vim.keymap.set("n", "<leader>ss", "<cmd>lua require('substitute.range').word()<cr>", { noremap = true })

