vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt_local.foldlevel = 99

-- FROM: https://github.com/nickspoons/vim-cs/issues/68#issuecomment-1718489232
-- ALSO SEE: https://neovim.io/doc/user/indent.html
vim.cmd[[setlocal cinoptions=(1s,J1]]

-- vim.keymap.set("n", "gd", ":lua require('omnisharp_extended').telescope_lsp_definitions()<cr>")
