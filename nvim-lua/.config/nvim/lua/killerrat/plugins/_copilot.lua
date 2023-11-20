vim.g.copilot_no_tab_map = true

vim.g.copilot_filetypes = {
	['TelescopePrompt'] = false,
	-- ['html'] = false,
}
-- vim.keymap.set("i", "<C-J>", "copilot#Accept('<CR>')", {expr = true, silent = true})
-- FROM: https://github.com/community/community/discussions/29817#discussioncomment-3583667
vim.keymap.set(
    "i",
    "<Plug>(vimrc:copilot-dummy-map)",
    'copilot#Accept("")',
    { silent = true, expr = true, desc = "Copilot dummy accept" }
)

-- local cmp = require("cmp")
-- cmp.setup {
--   mapping = {
--     ['<C-J>'] = cmp.mapping(function(fallback)
--       vim.api.nvim_feedkeys(vim.fn['copilot#Accept'](vim.api.nvim_replace_termcodes('<Tab>', true, true, true)), 'n', true)
--     end)
--   },
-- }
