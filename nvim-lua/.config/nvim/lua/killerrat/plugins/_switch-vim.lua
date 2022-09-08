if not _G.plugin_loaded("switch.vim") then
	print("Switch not found, not loading")
	do return end
end

-- " FROM: https://github.com/AndrewRadev/switch.vim
-- " keybinding is gs

vim.cmd[[let g:switch_custom_definitions =
    \ [
    \   switch#NormalizedCase(['private', 'protected', 'internal', 'public']),
    \   switch#NormalizedCase(['true', 'false']),
    \   switch#NormalizedCase(['before', 'after']),
    \   switch#NormalizedCase(['to', 'from']),
    \   switch#NormalizedCase(['==', '!=']),
    \   switch#NormalizedCase(['min', 'max']),
    \   switch#NormalizedCase(['UAT', 'PROD']),
    \   switch#NormalizedCase(['left', 'right']),
    \ ]
]]

