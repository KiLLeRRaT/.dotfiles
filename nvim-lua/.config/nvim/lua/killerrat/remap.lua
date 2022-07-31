-- " REMAPS / REMAPPINGS / KEYS
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- " SWITCH TO PREV BUFFER AND CLOSE THE ONE YOU SWITCHED AWAY FROM, CLOSES A
-- " BUFFER WITHOUT MESSING UP THE SPLIT
-- nnoremap <leader>bd :bp \| :sp \| :bn \| :bd<cr>

-- nnoremap <leader>ba :bufdo bd<cr>

-- nnoremap ' `
vim.keymap.set('n', "'", "`")

-- " KEEP CURSOR IN THE CENTRE OF THE SCREEN WHEN SEARCHING NEXT
-- nnoremap n nzzzv
vim.keymap.set('n', "n", "nzzzv")
-- nnoremap N Nzzzv
vim.keymap.set('n', "N", "Nzzzv")

-- " KEEP CURSOR IN A SANE PLACE WHEN USING J TO JOIN LINES
-- nnoremap J mzJ`z
vim.keymap.set('n', "J", "mzJ`z")

-- nnoremap <leader>y "+y
vim.keymap.set("n", "<leader>y", "\"+y")
-- vnoremap <leader>y "+y
vim.keymap.set("v", "<leader>y", "\"+y")
-- nnoremap <leader>Y gg"+yG
-- vim.keymap.set("n", "<leader>Y", "gg\"+yG")

-- " DELETE INTO BLACK HOLE REGISTER
-- nnoremap <leader>d "_d
vim.keymap.set("n", "<leader>d", "\"_d")
-- vnoremap <leader>d "_d
vim.keymap.set("v", "<leader>d", "\"_d")

-- " [count] yanks, comments out, and pastes a copy below
-- nnoremap <expr> <leader>T '<esc>' . v:count1 . '"zyy:.,+' . (v:count1 - 1) . 'Commentary<cr>' . v:count1 . 'j<esc>"zP'
vim.cmd[[nnoremap <expr> <leader>T '<esc>' . v:count1 . '"zyy:.,+' . (v:count1 - 1) . 'Commentary<cr>' . v:count1 . 'j<esc>"zP']]
-- nnoremap <expr> <leader>t '<esc>' . v:count1 . '"zyy' . v:count1 . 'j<esc>"zP'
-- vim.api.nvim_set_keymap("n", "<leader>t", "'<esc>' . v:count1 . '\"zyy' . v:count1 . 'j<esc>\"zP", { noremap = true })
vim.cmd[[nnoremap <expr> <leader>t '<esc>' . v:count1 . '"zyy' . v:count1 . 'j<esc>"zP']]

-- " https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text
-- xnoremap <leader>p "_dP
vim.keymap.set("x", "<leader>p", "\"_dP")

-- REPLACE SELECTION WITH YANKED TEXT
local text_objects = {"w", "t", "\"", "'", "(", ")", "b", "{", "}", "[", "]", "<", ">", "`"}
for i, v in ipairs(text_objects) do
	-- REPLACE INNER SELECTION WITH YANKED TEXT
	vim.keymap.set("n", "<leader>ri" .. v, "ci" .. v .. "<C-R><C-0><esc>")
	-- REPLACE INNER SELECTION WITH YANKED TEXT FROM CLIPBOARD
	vim.keymap.set("n", "<leader>Ri" .. v, "ci" .. v .. "<C-R><C-*><esc>")
	-- REPLACE AROUND SELECTION WITH YANKED TEXT
	vim.keymap.set("n", "<leader>ra" .. v, "ca" .. v .. "<C-R><C-0><esc>")
	-- REPLACE AROUND SELECTION WITH YANKED TEXT FROM CLIPBOARD
	vim.keymap.set("n", "<leader>Ra" .. v, "ca" .. v .. "<C-R><C-*><esc>")
	-- APPEND INSIDE
	vim.keymap.set("n", "<leader>ci" .. v, "ci" .. v .. "<C-R>\"")

end
-- /REPLACE SELECTION WITH YANKED TEXT

-- " DISABLE CTRL-Z IN WINDOWS SINCE IT FREEZES VIM!: https://github.com/neovim/neovim/issues/6660
local all_modes = {"n", "i", "v", "s", "x", "c", "o"}
for i, v in ipairs(all_modes) do
	vim.keymap.set(v, "<C-z>", "<nop>")
end


-- " COPY CURRENT FILENAME OR FULL FILE PATH TO SYSTEM CLIPBOARD
-- nnoremap <leader>cf :echo expand("%:t") \| :let @+ = expand("%:t")<cr>
vim.cmd[[nnoremap <leader>cf :echo expand("%:t") \| :let @+ = expand("%:t")<cr>]]
-- nnoremap <leader>cF :echo expand("%:p") \| :let @+ = expand("%:p")<cr>
vim.cmd[[nnoremap <leader>cF :echo expand("%:p") \| :let @+ = expand("%:p")<cr>]]

-- " OPEN CURRENT FOLDER IN WINDOWS EXPLORER
-- " EXPAND COLON PARAMETERS FROM: https://vi.stackexchange.com/a/1885
-- " nnoremap gF :!start %:p:h<cr>

-- " " REPLACE VISUAL SELECTION
-- " vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

-- " REFRESH FILE FROM DISK
-- nnoremap <F5> :e %<cr>
vim.keymap.set("n", "<F5>", ":e %<cr>")

-- " REFRESH FILE FROM DISK AND GO TO BOTTOM
-- nnoremap <silent><S-F5> :e %<cr>G
vim.keymap.set("n", "<S-F5>", ":e %<cr>G")

-- " RELOAD CONFIG
-- " nnoremap <C-f5> :so ~/.dotfiles/nvim/.config/nvim/init.vim<cr>
-- nnoremap <C-F5> :execute 'source ' . stdpath('config') . '/init.vim'<cr>
-- vim.api.nvim_set_keymap("n", "<C-F5>", ":execute 'source ' . stdpath('config') . '/init.vim'<cr>", { noremap = true })
vim.keymap.set("n", "<C-F5>", ":execute 'source ' . stdpath('config') . '/init.lua'<cr>")

-- " " EDIT CONFIG
-- " nnoremap <A-f5> :e ~/.dotfiles/nvim/.config/nvim/init.vim<cr>
-- nnoremap <A-F5> :execute 'edit ' . stdpath('config') . '/init.vim'<cr>:cd %:h<cr>

-- " EDIT NOTES FOLDER
-- nnoremap <A-n> :e C:\GBox\Notes<cr>:cd C:\GBox\Notes<cr>

-- " EDIT SCRIPTS FOLDER
-- nnoremap <A-s> :e C:\GBox\Applications\Tools\Scripts<cr>:cd C:\GBox\Applications\Tools\Scripts<cr>
-- vim.api.nvim_set_keymap("n", "<A-s>", ":e C:\\GBox\\Applications\\Tools\\Scripts<cr>:cd C:\\GBox\\Applications\\Tools\\Scripts<cr>", { noremap = true })
local scripts_path = "C:\\GBox\\Applications\\Tools\\Scripts"
vim.keymap.set("n", "<A-s>", ":e " .. scripts_path .. "<cr>:cd " .. scripts_path .. "<cr>")

-- " BUILD SOLUTION
-- nnoremap <leader>rb :!dotnet build *.sln

-- " DIFF WITH SAVED, FROM: https://stackoverflow.com/a/749320/182888
-- function! s:DiffWithSaved()
-- 	let filetype=&ft
-- 	diffthis
-- 	vnew | r # | normal! 1Gdd
-- 	diffthis
-- 	exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
-- endfunction
-- com! DiffSaved call s:DiffWithSaved()



-- " SPELL CHECKING ]s and [s for next/prev, z= for spelling suggestion, zg to
-- " add to dictionary
-- map <F6> :setlocal spell!<CR>
vim.keymap.set("n", "<F6>", ":setlocal spell!<CR>:setlocal spell?<CR>")


-- " RUN jq and use tab indents, then remove the ^M chars because vim is doing stupid things.
-- " vnoremap <leader>=j :'<,'>!jq --tab .<cr>:%s/\r/e<cr>
-- " nnoremap <leader>=j :%!jq --tab .<cr>:%s/\r/e<cr>
-- vnoremap <leader>=j :'<,'>!jq "--tab ."<cr>:%s/\r<cr>
-- nnoremap <leader>=j :%!jq "--tab ."<cr>:%s/\r<cr>
-- " PASTE JSON FROM CLIPBOARD, AND FORMAT IT
-- nnoremap <leader>=J ggdG"+P:%!jq "--tab ."<cr>:%s/\r<cr>
-- " RETAB FILE

-- nnoremap <leader>=t :%retab!<cr>
vim.keymap.set("n", "<leader>=t", ":%retab!<cr>")
-- " REMOVE TRAILING WHITESPACE FROM ALL LINES
-- nnoremap <leader>=w :%s/\s\+$//<cr>
-- MOVED TO _whitespace-nvim.lua FOR NOW
-- vim.keymap.set("n", "<leader>=w", ":%s/\\s\\+$//<cr>")

-- " cm.Parameters.Add, and cm.Parameters.Value lines can be combined into single line using this
-- " function! MergeParametersAndValue()
-- " 	exec "normal ^f@ya\"$x/\<c-r>0\<cr>f.y$NNA\<c-r>0\<esc>0"
-- " 	silent! call repeat#set("\<space>=v", v:count)
-- " endfunction

-- function! MergeParametersAndValue()
-- 	exec "normal ^f@ya\"$x/\<c-r>0\<cr>f.y$ddNA\<c-r>0\<esc>0"
-- 	silent! call repeat#set("\<space>=v", v:count)
-- endfunction
-- autocmd FileType cs nnoremap <buffer> <leader>=v :call MergeParametersAndValue()<cr>

