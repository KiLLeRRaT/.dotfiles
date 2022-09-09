vim.opt.termguicolors = true

	vim.opt.background = "dark"
vim.g.tokyonight_transparent = true
vim.g.tokyonight_transparent_sidebar = true
vim.g.gruvbox_guisp_fallback = "bg"
vim.g.gruvbox_transparent_bg = 1

if _G.plugin_loaded("vim-colors-solarized") then
	vim.g.solarized_termtrans = 1
	vim.cmd("colorscheme solarized")
end

if _G.plugin_loaded("gruvbox") then
	vim.cmd("colorscheme gruvbox")
end

if _G.plugin_loaded("tokyonight.nvim") then
	vim.cmd("colorscheme tokyonight")
end

-- autocmd VimEnter * hi Normal ctermbg=none

