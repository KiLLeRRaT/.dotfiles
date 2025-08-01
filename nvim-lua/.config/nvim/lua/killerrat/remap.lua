-- " REMAPS / REMAPPINGS / KEYS
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- " SWITCH TO PREV BUFFER AND CLOSE THE ONE YOU SWITCHED AWAY FROM, CLOSES A
-- " BUFFER WITHOUT MESSING UP THE SPLIT
-- nnoremap <leader>bd :bp \| :sp \| :bn \| :bd<cr>
-- vim.cmd[[nnoremap <leader>bd :bp \| :sp \| :bn \| :bd<cr>]]
vim.keymap.set('n', "<leader>bd", ":bp<cr>:sp<cr>:bn<cr>:bd<cr>")

-- vim.keymap.set('n', { ['<leader>bd'] = { {'bp', 'sp', 'bn', 'bd'}, {'<cr>'} } })

-- CLOSE ALL BUFFERS
vim.keymap.set('n', "<leader>ba", ":bufdo bd<cr>")
vim.keymap.set('n', "<leader>bA", ":%bd <cr>:e#<cr>")

-- CLOSE ALL OTHER BUFFERS EXCEPT CURRENT ONE
-- vim.cmd[[nnoremap <leader>bA :%bd \| :e#<cr>]]

-- SET ' TO ALSO BE POSITIONAL JUMP TO MARK, 
-- vim.keymap.set('n', "'", "`") DISABLED 2024-05-1: MAYBE LETS TRY TO USE BOTH ` and '

-- " KEEP CURSOR IN THE CENTRE OF THE SCREEN WHEN SEARCHING NEXT
-- (zv at the end opens folds if there are any)
vim.keymap.set('n', "n", "nzzzv")
vim.keymap.set('n', "N", "Nzzzv")

-- " KEEP CURSOR IN THE CENTRE OF THE SCREEN WHEN CTRL-D, CTRL-U
vim.keymap.set('n', "<c-d>", "<c-d>zzzv")
vim.keymap.set('n', "<c-u>", "<c-u>zzzv")

-- " KEEP CURSOR IN A SANE PLACE WHEN USING J TO JOIN LINES
vim.keymap.set('n', "J", "mzJ`z")

-- vim.keymap.set("n", "<leader>y", "\"+y")
-- vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>y", ":%y<cr>") -- DOESNT MESS WITH YOUR CURSOR!

-- vim.keymap.set("n", "<leader>Y", "gg\"+yG") -- MESSES WITH YOUR CURSOR
vim.keymap.set("n", "<leader>Y", ":%y+<cr>") -- DOESNT MESS WITH YOUR CURSOR!


-- " DELETE INTO BLACK HOLE REGISTER
vim.keymap.set({"n", "v"}, "<leader>d", "\"_d")

-- SELECT TEXT YOU JUST PASTED
-- FROM: https://vim.fandom.com/wiki/Selecting_your_pasted_text#:~:text=For%20example%2C%20you%20may%20press,the%20pasted%20text%20character%2Dwise.
vim.keymap.set("n", "gp", "`[v`]")


-- " [count] yanks, comments out, and pastes a copy below, and restores the default register with
-- what we yanked previously
vim.cmd[[nmap <expr> <leader>T '<esc>' . v:count1 . '"zyy' . v:count1 . 'gcc`]"z]p' . '\| :let @"=@0<cr>' ]]
vim.cmd[[nnoremap <expr> <leader>t '<esc>' . v:count1 . '"zyy' . v:count1 . '`]"z]p' . '\| :let @"=@0<cr>' ]]

vim.keymap.set("x", "<leader>p", "\"_dP")

-- REPLACE SELECTION WITH YANKED TEXT
local text_objects = {"w", "t", "\"", "'", "(", ")", "b", "{", "}", "[", "]", "<", ">", "`"}
for i, v in ipairs(text_objects) do
	-- REPLACE INNER SELECTION WITH YANKED TEXT
	-- vim.keymap.set("n", "<leader>ri" .. v, "ci" .. v .. "<C-R><C-0><esc>")
	-- REPLACE INNER SELECTION WITH YANKED TEXT FROM CLIPBOARD
	-- vim.keymap.set("n", "<leader>Ri" .. v, "ci" .. v .. "<C-R><C-*><esc>")
	-- REPLACE AROUND SELECTION WITH YANKED TEXT
	-- vim.keymap.set("n", "<leader>ra" .. v, "ca" .. v .. "<C-R><C-0><esc>")
	-- REPLACE AROUND SELECTION WITH YANKED TEXT FROM CLIPBOARD
	-- vim.keymap.set("n", "<leader>Ra" .. v, "ca" .. v .. "<C-R><C-*><esc>")
	-- APPEND INSIDE
	vim.keymap.set("n", "<leader>ci" .. v, "ci" .. v .. "<C-R>\"")
end
-- /REPLACE SELECTION WITH YANKED TEXT

-- " DISABLE CTRL-Z IN WINDOWS SINCE IT FREEZES VIM!: https://github.com/neovim/neovim/issues/6660
if vim.fn.has('win32') == 1 then
	local all_modes = {"n", "i", "v", "s", "x", "c", "o"}
	for i, v in ipairs(all_modes) do
		vim.keymap.set(v, "<C-z>", "<nop>")
	end
end

-- SET + REGISTER TO JUST YANKED ITEM, THIS HELPS WHEN FORGETTING TO YANK TO SYSTEM CLIPBOARD
vim.keymap.set("n", "\"++", ":let @+ = @0<cr>")

-- " COPY CURRENT FILENAME OR FULL FILE PATH TO SYSTEM CLIPBOARD
vim.cmd[[nnoremap <leader>cf :echo fnameescape(expand("%:p:h")) \| :let @+ = fnameescape(expand("%:p:h"))<cr>]]
vim.cmd[[nnoremap <leader>cF :echo fnameescape(expand("%:p")) \| :let @+ = fnameescape(expand("%:p"))<cr>]]

-- " REFRESH FILE FROM DISK
vim.keymap.set("n", "<F5>", ":e %<cr>")

-- " REFRESH FILE FROM DISK AND GO TO BOTTOM
vim.keymap.set("n", "<S-F5>", ":e %<cr>G")

-- " RELOAD CONFIG
vim.keymap.set("n", "<C-F5>", ":execute 'source ' . stdpath('config') . '/init.lua'<cr>")

-- " " EDIT CONFIG
-- " nnoremap <A-f5> :e ~/.dotfiles/nvim/.config/nvim/init.vim<cr>
-- nnoremap <A-F5> :execute 'edit ' . stdpath('config') . '/init.vim'<cr>:cd %:h<cr>

-- " EDIT NOTES FOLDER - REPLACED BY VIMWIKI!
-- nnoremap <A-n> :e C:\GBox\Notes<cr>:cd C:\GBox\Notes<cr>

-- " EDIT SCRIPTS FOLDER
-- local scripts_path = "C:\\GBox\\Applications\\Tools\\Scripts"
local scripts_path = "~/GBox/Applications/Tools/Scripts"
vim.keymap.set("n", "<leader><leader>s", ":e " .. scripts_path .. "<cr>:cd " .. scripts_path .. "<cr>")

-- " BUILD SOLUTION
-- nnoremap <leader>rb :!dotnet build *.sln

-- " DIFF WITH SAVED, FROM: https://stackoverflow.com/a/749320/182888
-- function! s:DiffWithSaved()
--	let filetype=&ft
--	diffthis
--	vnew | r # | normal! 1Gdd
--	diffthis
--	exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
-- endfunction
-- com! DiffSaved call s:DiffWithSaved()


-- " SPELL CHECKING ]s and [s for next/prev, z= for spelling suggestion, zg to
-- " add to dictionary
vim.keymap.set("n", "<F6>", ":setlocal spell!<CR>:setlocal spell?<CR>")
-- vim.keymap.set("n", "Z=", "1z=]s<cmd>call repeat#set(\"Z=\", v:count)<cr>")
vim.keymap.set("n", "Z=", "]sz=")


vim.keymap.set("n", "<F11>", ":ZenMode<cr>")


-- " RUN jq and use tab indents, then remove the ^M chars because vim is doing stupid things.
-- " vnoremap <leader>=j :'<,'>!jq --tab .<cr>:%s/\r/e<cr>
-- " nnoremap <leader>=j :%!jq --tab .<cr>:%s/\r/e<cr>
-- vnoremap <leader>=j :'<,'>!jq "--tab ."<cr>:%s/\r<cr>
-- nnoremap <leader>=j :%!jq "--tab ."<cr>:%s/\r<cr>
-- " PASTE JSON FROM CLIPBOARD, AND FORMAT IT
-- nnoremap <leader>=J ggdG"+P:%!jq "--tab ."<cr>:%s/\r<cr>

if vim.fn.has('unix') == 1 then
	vim.keymap.set("n", "<leader>=j", ":%!jq --tab<cr>")
	vim.keymap.set("v", "<leader>=j", ":'<,'>!jq --tab<cr>")
-- " PASTE JSON FROM CLIPBOARD, AND FORMAT IT
	vim.keymap.set("n", "<leader>=J", "ggdG\"+P:%!jq --tab<cr>:set ft=json<cr>")

	vim.keymap.set("n", "<leader>=h", ":%!tidy -mi --show-body-only yes 2> /dev/null<cr>")
	vim.keymap.set("v", "<leader>=h", ":'<,'>!tidy -mi --show-body-only yes 2> /dev/null<cr>")
	vim.keymap.set("n", "<leader>=H", "ggdG\"+P:%!tidy -mi --show-body-only yes 2> /dev/null<cr>:set ft=html<cr>")
end


-- " RETAB FILE, mnemonic: tab
vim.keymap.set("n", "<leader>=t", ":%retab!<cr>")

-- " REMOVE TRAILING WHITESPACE FROM ALL LINES, MOVED TO _whitespace-nvim.lua FOR NOW
-- nnoremap <leader>=w :%s/\s\+$//<cr>
-- vim.keymap.set("n", "<leader>=w", ":%s/\\s\\+$//<cr>")

-- FORMAT STACK TRACE, mnemonic: stack
vim.keymap.set("n", "<leader>=s", ":%s/\\s\\+at\\s\\+/\\r\\tat /g<cr>")
-- THE BELOW DOESNT WORK, JUST LEAVE IT FOR NOW
-- vim.keymap.set("v", "<leader>=s", ":'<,'>s/\\s\\+at\\s\\+/\\r\\tat /g<cr>")

-- REMOVE ALL ^M FROM FILE (CONVERT FROM CRLF TO LF ONLY)
vim.keymap.set("n", "<leader>=m", ":%s/\\r//g<cr>")


-- SUM LINES, mnemonic: Add, or Hours
if vim.fn.has('unix') == 1 then
	-- vim.keymap.set("n", "<leader>=a", ":%!awk '{print; total+=$1}END{print total}'<cr>")
	-- BELOW DOESNT WORK WELL WITH DECIMAL POINTS! ONLY WITH INTEGERS
	-- vim.keymap.set("n", "<leader>=a", ":%!awk '{gsub(/[^0-9\\.]/, \"\"); print; total+=$1}END{print total}'<cr>")
	-- vim.keymap.set("n", "<leader>=a", ":%!awk '{gsub(/[^0-9\\.\\-]/, \"\"); print; total+=$1}END{print total}'<cr>")
	-- vim.keymap.set("n", "<leader>=a", ":%!sed -E 's/.*(-?[0-9\\.\\,]+) ?-? ?(day|hour|hr)s?$/\\1/;t;s/.*/ /'<cr>")
	-- vim.keymap.set("n", "<leader>=a", ":%!sed -E 's/.* (-?[0-9\\.\\,]+) ?-? ?(day|hour|hr)s?$/\\1/;t;s/.*/ /' | awk \'{print; total+=$1}END{print total}\'<cr>")
	-- vim.keymap.set("n", "<leader>=a", ":%!sed -E 's/.* (-?[0-9\\.\\,]+) ?-? ?(day|hour|hr)s?$/\\1/;t;s/.*/ /' | awk \'{print; total+=$1}END{print total}\'<cr>")

	local sum_command_hours = "%!sed -E 's/.* \\(?(-?[0-9\\.\\,]+) ?-? ?(day|hour|hr)s?\\)?.*/\\1/;t;s/.*/ /' | awk \'{print; total+=$1}END{print total}\'"
	local sum_command = "%!awk '{gsub(/[^0-9\\.\\-]/, \"\"); print; total+=$1}END{print total}'"

	function CopyAndCreateVerticalSplit(is_hours)
		vim.cmd('setlocal cursorbind')
		vim.cmd('%y')
		vim.cmd('vnew')
		local new_buffer = vim.api.nvim_get_current_buf()
		local new_window = vim.api.nvim_get_current_win()

		vim.cmd('buffer ' .. new_buffer)
		vim.api.nvim_win_set_width(new_window, 10)
		vim.cmd('normal! P')
		vim.cmd('buffer ' .. new_buffer .. ' | setlocal cursorbind')
		-- vim.cmd([[ silent! %s/\.\([a-zA-Z\-]\)/\1/g ]]) -- REMOVE .'s that are followed by a letter
		-- vim.cmd([[ silent! %s/\-\([a-zA-Z\-]\)/\1/g ]]) -- REMOVE -'s that are followed by a letter
		-- vim.cmd("%!sed -E 's/.* (-?[0-9\\.\\,]+) ?-? ?(day|hour|hr)s?$/\\1/;t;s/.*/ /' | awk \'{print; total+=$1}END{print total}\'")
		print("is_hours: ", is_hours)
		if is_hours then
			vim.cmd(sum_command_hours)
		else
			print("sum_command: ", sum_command)
			vim.cmd(sum_command)
		end
	end
	vim.api.nvim_set_keymap('n', '<leader>=SH', ':lua CopyAndCreateVerticalSplit(true)<CR>', { noremap = true, silent = true })
	vim.api.nvim_set_keymap('n', '<leader>=SS', ':lua CopyAndCreateVerticalSplit(false)<CR>', { noremap = true, silent = true })
	vim.keymap.set("n", "<leader>=sh", ":" .. sum_command_hours .. "<cr>")
	vim.keymap.set("n", "<leader>=ss", ":" .. sum_command .. "<cr>")

else
	-- vim.keymap.set("n", "<leader>=s", ":%!wsl awk '{print; total+=\\$1}END{print total}'<cr>")
	vim.keymap.set("n", "<leader>=sh", ":lua vim.notify('Summing not supported in Windows, it uses awk', vim.log.levels.ERROR)<cr>")
end

-- " cm.Parameters.Add, and cm.Parameters.Value lines can be combined into single line using this
-- " function! MergeParametersAndValue()
-- "	exec "normal ^f@ya\"$x/\<c-r>0\<cr>f.y$NNA\<c-r>0\<esc>0"
-- "	silent! call repeat#set("\<space>=v", v:count)
-- " endfunction

-- function! MergeParametersAndValue()
--	exec "normal ^f@ya\"$x/\<c-r>0\<cr>f.y$ddNA\<c-r>0\<esc>0"
--	silent! call repeat#set("\<space>=v", v:count)
-- endfunction
-- autocmd FileType cs nnoremap <buffer> <leader>=v :call MergeParametersAndValue()<cr>

vim.cmd([[
	function! MergeParametersAndValue()
		exec "normal ^f@ya\"$x/\<c-r>0\<cr>f.y$ddNA\<c-r>0\<esc>0"
		silent! call repeat#set("\<space>=v", v:count)
	endfunction
	autocmd FileType cs nnoremap <buffer> <leader>=v :call MergeParametersAndValue()<cr>
]])

-- LSP MAPPINGS
-- for gd, gr, see _telescope-nvim.lua
vim.keymap.set("n", "<F2>", ":LspInfo<cr>")
vim.keymap.set("n", "gD", ":lua vim.lsp.buf.type_definition()<cr>")
-- <leader>gi instead of jsut gi, because gi takes you to last edit and puts you in insert mode
vim.keymap.set("n", "<leader>gi", ":lua vim.lsp.buf.implementation()<cr>")
vim.keymap.set("n", "]G", ":lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<cr>")
vim.keymap.set("n", "[G", ":lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<cr>")
vim.keymap.set("n", "]g", ":lua vim.diagnostic.goto_next()<cr>")
vim.keymap.set("n", "[g", ":lua vim.diagnostic.goto_prev()<cr>")
vim.keymap.set("n", "<leader>rn", ":lua vim.lsp.buf.rename()<cr>")
vim.keymap.set({"n", "v"}, "<leader>ca", ":lua vim.lsp.buf.code_action()<cr>")

-- autocmd FileType cs nnoremap <buffer> K :lua vim.lsp.buf.hover()<CR>
vim.api.nvim_create_autocmd("FileType", {
	pattern = "cs",
	callback = function()
		vim.schedule(function()
			vim.keymap.set("n", "K", ":lua vim.lsp.buf.hover()<cr>")
		end)
	end,
	group = vim.api.nvim_create_augroup("remap.lua.hover", { clear = true })
})
-- for gd, gr, see _telescope-nvim.lua


vim.g.diagnostics_visible = true
function _G.toggle_diagnostics()
	if vim.g.diagnostics_visible then
		vim.g.diagnostics_visible = false
		vim.diagnostic.enable(false)
	else
		vim.g.diagnostics_visible = true
		vim.diagnostic.enable()
	end
end
vim.keymap.set("n", "<leader>G", ":call v:lua.toggle_diagnostics()<CR>")



-- QUICK FIX LIST
-- RATHER USE unimpaired's shortcuts, ]q and [q
-- vim.keymap.set("n", "<c-q>", ":copen<cr>")
-- vim.keymap.set("n", "<c-j>", ":cn<cr>")
-- vim.keymap.set("n", "<c-k>", ":cp<cr>")

-- LOCATION LIST
-- " nnoremap <leader>eq :lopen<cr>
-- " nnoremap <leader>ej :lnext<cr>
-- " nnoremap <leader>ek :lprev<cr>

-- LEAP LIKE, BUT SEARCH CURRENT SCREEN ONLY
-- FROM: https://www.reddit.com/r/vim/comments/91g97i/search_in_the_current_screen_only/
-- nnoremap <silent> \ :set scrolloff=0<CR>VHoL<Esc>:set scrolloff=1<CR>``<C-y>/\%V
-- vim.keymap.set("n", "<leader>/", ":set scrolloff=0<cr>VHoL<esc>:set scrolloff=1<cr>``<c-y>/\\%V")

-- JUMP TO A WINDOW BY NUMBER
-- FROM: https://youtube.com/watch?v=XyCRvk-VcXU&feature=shares
for i = 1, 6 do
	local lhs = "<leader>" .. i
	local rhs = i .. "<C-W>w"
	vim.keymap.set("n", lhs, rhs, { desc = "Switch to window " .. i })
end

-- MAPPINGS TO EASILY NAVIGATE SPLITS
-- USE <C-h> <C-j> <C-k> <C-l> TO NAVIGATE SPLITS
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
-- The C-S-L is not working, so we use <esc> instead
-- vim.keymap.set("n", "<C-S-L>", "<Cmd>nohlsearch|diffupdate|normal! <C-L><CR>") -- remap the built in to ctrl + shift + l
vim.keymap.set("n", "<esc>", "<Cmd>nohlsearch|diffupdate|normal! <C-L><CR>") -- remap the built in to ctrl + shift + l
vim.keymap.set("n", "<C-l>", "<C-w>l")


-- FROM TJ: https://github.com/tjdevries/config.nvim/blob/master/plugin/keymaps.lua#L15-L24-- -- Toggle hlsearch if it's on, otherwise just do "enter"
-- vim.keymap.set("n", "<CR>", function()
--   ---@diagnostic disable-next-line: undefined-field
--   if vim.v.hlsearch == 1 then
--     vim.cmd.nohl()
--     return ""
--   else
--     return vim.keycode "<CR>"
--   end
-- end, { expr = true })

-- CLOSE CURRENT WINDOW
vim.keymap.set("n", "<leader>;", ":clo<cr>")

-- HIGHLIGHT WORD UNDER THE CURSOR WITHOUT SEARCHING NEXT OCCURANCE
vim.keymap.set("n", "<leader>*", "yiw0/0<cr>")

-- SEARCH/HIGHLIGHT CURRENT LINE
-- https://vi.stackexchange.com/a/6210
vim.keymap.set("n", "<leader>/", "mq_y$/\\V<c-r>\"<cr>`q")

-- HIGHLIGHT CURRENT LINE TO SHOW PEOPLE ON SCREEN
-- FROM: https://vimtricks.com/p/highlight-specific-lines/
vim.cmd[[highlight LineHighlight ctermbg=lightgray guibg=#914c54]]
vim.keymap.set("n", "<leader>v", ":call matchadd('LineHighlight', '\\%'.line('.').'l')<cr>")
vim.keymap.set("n", "<leader>V", ":call clearmatches()<cr>")

-- treesitter-scratchpad
-- vim.keymap.set("n", "<localleader>ts", ":luafile ~/.config/nvim/lua/killerrat/treesitter-scratchpad/cs-public-methods.lua<cr>")
vim.keymap.set("n", "<localleader>ts", ":luafile ~/.config/nvim/lua/killerrat/treesitter-scratchpad/tsx-nztr.lua<cr>")

-- RUN LUA CODE
-- FROM TJ DEVRIES: https://youtu.be/F1CQVXA5gf0?si=VXTLi4Mo9wB8dCD7&t=84
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<leader>x", ":.lua<CR>")
vim.keymap.set("v", "<leader>x", ":lua<CR>")

-- vim.keymap.set("n", "<leader>~", function() end)

local function randomlySwitchCase(str)
	local newStr = ""
	for i = 1, #str do
		local c = str:sub(i, i)
		if math.random(0, 1) == 0 then
			newStr = newStr .. c:lower()
		else
			newStr = newStr .. c:upper()
		end
	end
	return newStr
end

function format_range_operator()
	local old_func = vim.go.operatorfunc -- backup previous reference
	-- set a globally callable object/function
	_G.op_func_formatting = function(type)
		-- the content covered by the motion is between the [ and ] marks, so get those
		local start = vim.api.nvim_buf_get_mark(0, '[')
		local finish = vim.api.nvim_buf_get_mark(0, ']')

		-- print ("start: ", vim.inspect(start))
		-- print ("finish: ", vim.inspect(finish))

		-- print ("type: ", type)
		if type == 'line' then
			finish = {finish[1]+1, -1}
		end
		-- print ("f: ", frow)

		local text = vim.api.nvim_buf_get_text(0, start[1]-1, start[2], finish[1]-1, finish[2]+1, {})
		-- print ("text: ", vim.inspect(text))

		local newText = {}
		for _, line in ipairs(text) do
			table.insert(newText, randomlySwitchCase(line))
		end
		-- print ("newText: ", vim.inspect(newText))

		-- now update the buffer with the new text
		vim.api.nvim_buf_set_text(0, start[1]-1, start[2], finish[1]-1, finish[2]+1, newText)
		vim.go.operatorfunc = old_func -- restore previous opfunc
		_G.op_func_formatting = nil -- deletes itself from global namespace
	end
	vim.go.operatorfunc = 'v:lua.op_func_formatting'
	vim.api.nvim_feedkeys('g@', 'n', false)
end
vim.api.nvim_set_keymap("n", "<leader>~", "<cmd>lua format_range_operator()<CR>", {noremap = true})

vim.api.nvim_create_user_command("WQ", "wq", { nargs = 0, desc = "Write and Quit" })
vim.api.nvim_create_user_command("Q", "q", { nargs = 0, desc = "Quit" })
vim.api.nvim_create_user_command("Qa", "qa", { nargs = 0, desc = "Quit all" })
vim.api.nvim_create_user_command("W", "w", { nargs = 0, desc = "Write" })
vim.api.nvim_create_user_command("Wq", "wq", { nargs = 0, desc = "Write and Quit" })
