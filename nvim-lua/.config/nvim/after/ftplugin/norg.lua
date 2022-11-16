vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

vim.keymap.set("n", "<localleader>nc", "<cmd>Neorg toggle-concealer<cr>")

-- SURROUND VISUAL SELECTION IN CODE TAGS
vim.keymap.set("v", "<localleader>sc", "<esc>'<O@code<esc>'>o@end<esc>")
