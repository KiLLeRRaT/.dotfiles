if not _G.plugin_loaded("vimwiki") then
	do return end
end

vim.g.vimwiki_list = { {path = '~/GBox/Notes/wiki/', syntax = 'markdown', ext = '.md'} }
vim.g.vimwiki_map_prefix = '<leader>v'
vim.g.vimwiki_auto_chdir = 1

