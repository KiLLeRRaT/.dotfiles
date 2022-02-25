local M = {}
M.search_scripts = function()
	require("telescope.builtin").find_files({
		prompt_title = "< Search Scripts >",
		cwd = "C:/GBox/Applications/Tools/Scripts",--vim.env.DOTFILES,
		--cwd = vim.env.DOTFILES,
		hidden = false,
	})
end

M.grep_scripts = function()
	require("telescope.builtin").live_grep({
		prompt_title = "< Grep Scripts >",
		cwd = "C:/GBox/Applications/Tools/Scripts",--vim.env.DOTFILES,
		--cwd = vim.env.DOTFILES,
		hidden = false,
	})
end

return M
