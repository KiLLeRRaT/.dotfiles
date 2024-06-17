-- " FROM: https://github.com/AndrewRadev/switch.vim
-- " keybinding is gs

    -- \   switch#NormalizedCaseWords(['true', 'false']),

vim.cmd[[let g:switch_custom_definitions =
    \ [
    \   switch#NormalizedCaseWords(['private', 'protected', 'internal', 'public']),
    \   switch#NormalizedCaseWords(['GRANT', 'REVOKE']),
    \   switch#NormalizedCaseWords(['before', 'after']),
    \   switch#NormalizedCaseWords(['primary', 'secondary']),
    \   switch#NormalizedCaseWords(['outlined', 'contained']),
    \   switch#NormalizedCaseWords(['to', 'from']),
    \   switch#NormalizedCaseWords(['yes', 'no']),
    \   switch#NormalizedCaseWords(['on', 'off']),
    \   switch#NormalizedCaseWords(['==', '!=']),
    \   switch#NormalizedCaseWords(['===', '!==']),
    \   switch#NormalizedCaseWords(['&&', '||']),
    \   switch#NormalizedCaseWords(['AND', 'OR']),
    \   switch#NormalizedCaseWords(['min', 'max']),
    \   switch#NormalizedCaseWords(['UAT', 'PROD']),
		\   switch#NormalizedCaseWords(['starting', 'stopping']),
    \   switch#NormalizedCaseWords(['start', 'stop']),
    \   switch#NormalizedCase(['left', 'right']),
    \   switch#NormalizedCaseWords(['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday']),
    \   switch#NormalizedCaseWords(['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun']),
    \   switch#NormalizedCaseWords(['january', 'february', 'march', 'april', 'may', 'june', 'july', 'august', 'september', 'october', 'november', 'december']),
    \   switch#NormalizedCaseWords(['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec']),
    \ ]
]]

