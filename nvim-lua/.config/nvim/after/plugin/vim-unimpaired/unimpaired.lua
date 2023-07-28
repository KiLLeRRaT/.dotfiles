if vim.fn.maparg("]o<Esc>", "n") == "<Nop>" then
	vim.api.nvim_del_keymap("n", "]o<Esc>")
end

if vim.fn.maparg("[o<Esc>", "n") == "<Nop>" then
	vim.api.nvim_del_keymap("n", "[o<Esc>")
end
