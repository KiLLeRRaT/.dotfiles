if not _G.plugin_loaded("copilot.vim") then
	do return end
end

vim.keymap.set("i", "<C-J>", "copilot#Accept('<CR>')", {expr = true, silent = true}) -- FROM: https://github.com/nanotee/nvim-lua-guide

vim.g.copilot_no_tab_map = 1

vim.g.copilot_filetypes = {
	['TelescopePrompt'] = false,
	-- ['html'] = false,
}
