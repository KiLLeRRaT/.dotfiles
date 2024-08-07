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

vim.keymap.set("n", "s", require('substitute').operator, { noremap = true })
vim.keymap.set("n", "ss",require('substitute').line, { noremap = true })
vim.keymap.set("n", "S", require('substitute').eol, { noremap = true })
vim.keymap.set("x", "s", require('substitute').visual, { noremap = true })


-- vim.keymap.set("n", "<leader>s", "<cmd>lua require('substitute.range').operator()<cr>", { noremap = true })
-- vim.keymap.set("x", "<leader>s", "<cmd>lua require('substitute.range').visual()<cr>", { noremap = true })
-- vim.keymap.set("n", "<leader>ss", "<cmd>lua require('substitute.range').word()<cr>", { noremap = true })

-- FROM: https://github.com/gbprod/substitute.nvim#-substitute-over-range-motion
-- SUBSTITUTE IN RANGE
vim.keymap.set("n", "<leader>s", require('substitute.range').operator, { noremap = true })
vim.keymap.set("x", "<leader>s", require('substitute.range').visual, { noremap = true })
vim.keymap.set("n", "<leader>ss", require('substitute.range').word, { noremap = true })

-- EXCHANGE
vim.keymap.set("n", "sx", require('substitute.exchange').operator, { noremap = true })
vim.keymap.set("n", "sxx", require('substitute.exchange').line, { noremap = true })
vim.keymap.set("x", "X", require('substitute.exchange').visual, { noremap = true })
vim.keymap.set("n", "sxc", require('substitute.exchange').cancel, { noremap = true })
