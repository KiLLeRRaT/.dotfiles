vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

vim.keymap.set("n", "<localleader>nc", "<cmd>Neorg toggle-concealer<cr>")

-- SURROUND CURRENT LINE IN CODE TAGS
vim.keymap.set("n", "<localleader>sc", "O@code<esc>jo@end<esc>")

-- SURROUND VISUAL SELECTION IN CODE TAGS
vim.keymap.set("v", "<localleader>sc", "<esc>'<O@code<esc>'>o@end<esc>")
