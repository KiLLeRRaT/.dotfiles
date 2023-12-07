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

-- SET ' TO ALSO BE POSITIONAL JUMP TO MARK
vim.keymap.set('n', "'", "`")

-- " KEEP CURSOR IN THE CENTRE OF THE SCREEN WHEN SEARCHING NEXT
-- (zv at the end opens folds if there are any)
vim.keymap.set('n', "n", "nzzzv")
vim.keymap.set('n', "N", "Nzzzv")

-- " KEEP CURSOR IN THE CENTRE OF THE SCREEN WHEN CTRL-D, CTRL-U
vim.keymap.set('n', "<c-d>", "<c-d>zzzv")
vim.keymap.set('n', "<c-u>", "<c-u>zzzv")

-- " KEEP CURSOR IN A SANE PLACE WHEN USING J TO JOIN LINES
vim.keymap.set('n', "J", "mzJ`z")

vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "gg\"+yG")


-- " DELETE INTO BLACK HOLE REGISTER
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- SELECT TEXT YOU JUST PASTED
-- FROM: https://vim.fandom.com/wiki/Selecting_your_pasted_text#:~:text=For%20example%2C%20you%20may%20press,the%20pasted%20text%20character%2Dwise.
vim.keymap.set("n", "gp", "`[v`]")


-- " [count] yanks, comments out, and pastes a copy below, and restores the default register with
-- what we yanked previously
-- vim.cmd[[nnoremap <expr> <leader>T '<esc>' . v:count1 . '"zyy:.,+' . (v:count1 - 1) . 'Commentary<cr>' . v:count1 . 'j<esc>"zP' . '\| :let @"=@0<cr>' ]]
vim.cmd[[nmap <expr> <leader>T '<esc>' . v:count1 . '"zyy' . v:count1 . 'gcc' . v:count1 . 'j<esc>"zP' . '\| :let @"=@0<cr>' ]]

-- vim.cmd[[nnoremap <expr> <leader>t '<esc>' . v:count1 . '"zyy' . v:count1 . 'j<esc>"zP']]
vim.cmd[[nnoremap <expr> <leader>t '<esc>' . v:count1 . '"zyy' . v:count1 . 'j<esc>"zP' . '\| :let @"=@0<cr>' ]]

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


-- SUM LINES, mnemonic: Add
if vim.fn.has('unix') == 1 then
	-- vim.keymap.set("n", "<leader>=a", ":%!awk '{print; total+=$1}END{print total}'<cr>")
	-- BELOW DOESNT WORK WELL WITH DECIMAL POINTS! ONLY WITH INTEGERS
	-- vim.keymap.set("n", "<leader>=a", ":%!awk '{gsub(/[^0-9\\.]/, \"\"); print; total+=$1}END{print total}'<cr>")
	vim.keymap.set("n", "<leader>=a", ":%!awk '{gsub(/[^0-9\\.\\-]/, \"\"); print; total+=$1}END{print total}'<cr>")

	function CopyAndCreateVerticalSplit()
		vim.cmd('setlocal cursorbind')
		vim.cmd('normal! ggVGy')
		vim.cmd('vnew')
		local new_buffer = vim.api.nvim_get_current_buf()
		local new_window = vim.api.nvim_get_current_win()

		vim.cmd('buffer ' .. new_buffer)
		vim.api.nvim_win_set_width(new_window, 10)
		vim.cmd('normal! P')
		vim.cmd('buffer ' .. new_buffer .. ' | setlocal cursorbind')
		vim.cmd([[ silent! %s/\.\([a-zA-Z\-]\)/\1/g ]]) -- REMOVE .'s that are followed by a letter
		vim.cmd([[ silent! %s/\-\([a-zA-Z\-]\)/\1/g ]]) -- REMOVE -'s that are followed by a letter
		

		vim.cmd('%!awk \'{gsub(/[^0-9\\.\\-]/, \"\"); print; total+=$1}END{print total}\'')
	end
	vim.api.nvim_set_keymap('n', '<leader>=A', ':lua CopyAndCreateVerticalSplit()<CR>', { noremap = true, silent = true })
else
	-- vim.keymap.set("n", "<leader>=s", ":%!wsl awk '{print; total+=\\$1}END{print total}'<cr>")
	vim.keymap.set("n", "<leader>=a", ":lua vim.notify('Summing not supported in Windows, it uses awk', vim.log.levels.ERROR)<cr>")
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
vim.keymap.set("n", "]g", ":lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<cr>")
vim.keymap.set("n", "[g", ":lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<cr>")
vim.keymap.set("n", "]G", ":lua vim.diagnostic.goto_next()<cr>")
vim.keymap.set("n", "[G", ":lua vim.diagnostic.goto_prev()<cr>")
vim.keymap.set("n", "<leader>rn", ":lua vim.lsp.buf.rename()<cr>")
vim.keymap.set("n", "<leader>ca", ":lua vim.lsp.buf.code_action()<cr>")

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
		vim.diagnostic.disable()
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
vim.keymap.set("n", "<leader>/", ":set scrolloff=0<cr>VHoL<esc>:set scrolloff=1<cr>``<c-y>/\\%V")

-- JUMP TO A WINDOW BY NUMBER
-- FROM: https://youtube.com/watch?v=XyCRvk-VcXU&feature=shares
for i = 1, 6 do
	local lhs = "<leader>" .. i
	local rhs = i .. "<C-W>w"
	vim.keymap.set("n", lhs, rhs, { desc = "Switch to window " .. i })
end

-- CLOSE CURRENT WINDOW
vim.keymap.set("n", "<leader>;", ":clo<cr>")

-- HIGHLIGHT WORD UNDER THE CURSOR WITHOUT SEARCHING NEXT OCCURANCE
vim.keymap.set("n", "<leader>*", "yiw0/0<cr>")
