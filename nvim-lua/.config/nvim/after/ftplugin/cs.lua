vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt_local.foldlevel = 99

-- FROM: https://github.com/nickspoons/vim-cs/issues/68#issuecomment-1718489232
-- ALSO SEE: https://neovim.io/doc/user/indent.html
-- -- Wed 19 Feb 2025 11:12 Taken it out just to test since changing to roslyn lsp instead of
-- omnisharp, not sure if it will make a diff, then we can just put it back in.
-- vim.cmd[[setlocal cinoptions=(1s,J1]]

-- vim.keymap.set("n", "gd", ":lua require('omnisharp_extended').telescope_lsp_definitions()<cr>")

vim.opt_local.cinoptions = "(1s,J0"
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = true })
vim.keymap.set("n", "<localleader>g", vim.diagnostic.setqflist, { buffer = true })
