-- set path+=**

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.hlsearch = true
vim.opt.cursorline = true
vim.opt.incsearch = true
vim.opt.spelllang = "en,af"
-- vim.opt.spelllang = "/usr/share/dict/words"

vim.opt.showcmd = true

-- set autoread " READ FILE IF OUTSIDE CHANGES ARE DETECTED

vim.opt.textwidth = 100 -- command 'gw' formats text to this width
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.autoindent = true
vim.opt.expandtab = false
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.listchars = "tab:| ,nbsp:_,trail:·,space:·"
vim.opt.list = true
vim.opt.wrap = false
vim.opt.mouse = "a"

-- " SET SHELL TO POWERSHELL
if vim.fn.has('win32') then
	-- let &shell = 'pwsh'
	vim.o.shell = 'pwsh'
	-- let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
	vim.o.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
	-- let &shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait'
	vim.o.shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait'
	-- let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
	vim.o.shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'

	-- set shellquote= shellxquote=
	vim.opt.shellquote = ''
	vim.opt.shellxquote = ''
	-- set noshelltemp " FROM: https://superuser.com/a/1561892/69729, Sorts out the issue with shell returned 1, E485 and temp files
	vim.opt.shelltemp = false
end
-- " /SET SHELL TO POWERSHELL

-- " MAKE SURE TO KEEP YOUR COLOR SCHEME AFTER LOADING ANOTHER SCHEME LATER DOWN
-- " THE CONFIG
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = {"*"},
	command = vim.cmd[[highlight ExtraWhitespace ctermbg=red guibg=red]],
})

vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = {"*"},
	command = vim.cmd[[let w:whitespace_match_number =
		\ matchadd('ExtraWhitespace', '\s\+$')]],
})

-- " HIGHLIGHT YANKED TEXT
-- autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup=(vim.fn['hlexists']('HighlightedyankRegion') > 0 and 'HighlightedyankRegion' or 'IncSearch'), timeout=700}
-- FROM: https://github.com/neovim/neovim/issues/17758#issuecomment-1072650270
local highlight_yank = vim.api.nvim_create_augroup("highlight_yank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", { callback = function()
	vim.highlight.on_yank({ higroup = "IncSearch", timeout = 700 })
end, group = highlight_yank })


-- " FOLDING
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- set foldmethod=expr
-- set foldexpr=nvim_treesitter#foldexpr()
-- set foldcolumn=1 "defines 1 col at window left, to indicate folding
-- set foldlevelstart=99 "start file with all folds opened

-- let javaScript_fold=1 "activate folding by JS syntax
-- " let cs_fold=1
-- " let xml_syntax_folding=1
-- let xml_folding=1
-- let yaml_fold=1
-- let vb_fold=1

-- " SAVE FOLDING AND OTHER THINGS WHEN YOU OPEN AND CLOSE FILES/VIM, FROM: https://vim.fandom.com/wiki/Make_views_automatic
vim.opt.viewoptions = vim.opt.viewoptions - { "options" }

-- autocmd BufWinLeave *.* mkview
local folding = vim.api.nvim_create_augroup("folding", { clear = true })
vim.api.nvim_create_autocmd("BufWinLeave", {
	pattern = {"*"},
	command = vim.cmd[[silent! mkview]],
	group = folding
})

-- autocmd BufWinEnter *.* silent! loadview
vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = {"*"},
	command = vim.cmd[[silent! loadview]],
	group = folding
})

-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- " /FOLDING

-- " SYNTAX HIGHLIGHTING FOR CSHTML/RAZOR
-- autocmd BufNewFile,BufRead *.cshtml set syntax=html
local syntax_cshtml = vim.api.nvim_create_augroup("syntax_cshtml", { clear = true })
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
	pattern = "*.cshtml",
	callback = function()
		vim.schedule(function()
			print("im here man")
			vim.opt.syntax = "html"
		end)
	end,
	group = syntax_cshtml
})

-- syntax on

-- hi! Normal ctermbg=NONE guibg=NONE

-- THIS HAS TO BE BEFORE ANY MAPPING FILES OTHERWISE THE MAPPINGS ARE BOUND TO WHAT THE LEADER WAS
-- BEFORE THIS CHANGE!!!
vim.g.mapleader = " "






















-- " QUICK FIX LIST: https://stackoverflow.com/a/1747286/182888
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- ":copen " Open the quickfix window
-- ":ccl   " Close it
-- ":cw    " Open it if there are "errors", close it otherwise (some people prefer this)
-- ":cn    " Go to the next error in the window
-- ":cp    " Go to the previous error in the window
-- ":cnf   " Go to the first error in the next file
-- ":.cc   " Go to error under cursor (if cursor is in quickfix window)
-- "nnoremap <leader>cn :cnext<cr>
-- "nnoremap <leader>cp :cprevious<cr>
-- "nnoremap <leader>cc :ccl<cr>
-- "nnoremap <leader>co :copen<cr>
-- nnoremap <c-q> :copen<cr>
-- nnoremap <c-j> :cn<cr>
-- nnoremap <c-k> :cp<cr>
-- " nnoremap <leader>eq :lopen<cr>
-- " nnoremap <leader>ej :lnext<cr>
-- " nnoremap <leader>ek :lprev<cr>

-- " LSP
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- " FROM: https://rudism.com/coding-csharp-in-neovim/

-- lua require('plugins')

-- autocmd FileType cs nnoremap <buffer> K :lua vim.lsp.buf.hover()<CR>

-- " nnoremap gd :lua vim.lsp.buf.definition()<CR>
-- nnoremap gd :Telescope lsp_definitions<CR>
-- nnoremap gD :lua vim.lsp.buf.type_definition()<CR>
-- " <leader>gi because gi takes you to last edit and puts you in insert mode
-- nnoremap <leader>gi :lua vim.lsp.buf.implementation()<CR>
-- nnoremap gr :Telescope lsp_references<CR>
-- nnoremap ]g :lua vim.diagnostic.goto_next()<CR>
-- nnoremap [g :lua vim.diagnostic.goto_prev()<CR>
-- nnoremap <leader>fd :Telescope diagnostics<CR>
-- " nnoremap <leader>fa :%Telescope lsp_range_code_actions<CR>
-- " nnoremap <leader>fa :lua vim.lsp.buf.range_code_action()<CR>
-- nnoremap <leader>rn :lua vim.lsp.buf.rename()<CR>
-- nnoremap <leader>ca :lua vim.lsp.buf.code_action()<CR>


-- " nnoremap('<leader>fu', 'Telescope lsp_references')
-- " nnoremap('<leader>gd', 'Telescope lsp_definitions')
-- " nnoremap('<leader>rn', 'lua vim.lsp.buf.rename()')
-- " nnoremap('<leader>dn', 'lua vim.lsp.diagnostic.goto_next()')
-- " nnoremap('<leader>dN', 'lua vim.lsp.diagnostic.goto_prev()')
-- " nnoremap('<leader>dd', 'Telescope lsp_document_diagnostics')
-- " nnoremap('<leader>dD', 'Telescope lsp_workspace_diagnostics')
-- " nnoremap('<leader>xx', 'Telescope lsp_code_actions')
-- " nnoremap('<leader>xd', '%Telescope lsp_range_code_actions')

-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- " /LSP


-- " GIT SIGNS: https://github.com/lewis6991/gitsigns.nvim
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- lua require('gitsigns').setup()
-- " Navigation
-- " nnoremap ]c :Gitsigns next_hunk<cr>
-- " nnoremap [c :Gitsigns prev_hunk<cr>
-- nnoremap ]h :Gitsigns next_hunk<cr>
-- nnoremap [h :Gitsigns prev_hunk<cr>

--     " -- Actions
-- nnoremap <leader>ds :Gitsigns stage_hunk<cr>

-- " REPLACE ^M AFTER RESET HUNK
-- nnoremap <leader>dr :Gitsigns reset_hunk<cr>:%s/\r<cr>

--     " map('n', '<leader>hS', gs.stage_buffer)
-- nnoremap <leader>du :Gitsigns undo_stage_hunk<cr>
--     " map('n', '<leader>hR', gs.reset_buffer)
-- nnoremap <leader>dp :Gitsigns preview_hunk<cr>
-- " nnoremap <leader>hb :Gitsigns blame_line{full=true}<cr>
-- nnoremap <leader>db :Gitsigns toggle_current_line_blame<cr>

--     " map('n', '<leader>hb', function() gs.blame_line{full=true} end)
--     " map('n', '<leader>tb', gs.toggle_current_line_blame)
--     " map('n', '<leader>hd', gs.diffthis)
--     " map('n', '<leader>hD', function() gs.diffthis('~') end)
--     " map('n', '<leader>td', gs.toggle_deleted)

-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- " /GIT SIGNS


-- " VIM DEV ICONS
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- " FIX THE ISSUE WITH SQUARE BRACKETS AROUND THE ICONS IN NERD TREE, FROM: https://github.com/ryanoasis/vim-devicons/issues/215#issuecomment-377786230
-- if exists("g:loaded_webdevicons")
-- 	call webdevicons#refresh()
-- endif
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- " /VIM DEV ICONS


-- " DEBUGGERS
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- nnoremap <F8> :lua require("dap").continue()<CR>
-- nnoremap <F9> :lua require("dap").toggle_breakpoint()<CR>
-- nnoremap <F10> :lua require("dap").step_over()<CR>
-- nnoremap <F11> :lua require("dap").step_into()<CR>
-- nnoremap <S-F11> :lua require("dap").step_out()<CR>
-- nnoremap <F12> :lua require("dap").repl.open()<CR>
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- " /DEBUGGERS

-- " BUFFERLINE
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- nnoremap <silent> gb :BufferLinePick<CR>
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- " /BUFFERLINE
-- " SWITCH.VIM
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- " FROM: https://github.com/AndrewRadev/switch.vim
-- " keybinding is gs
-- let g:switch_custom_definitions =
--     \ [
--     \   switch#NormalizedCase(['private', 'protected', 'internal', 'public']),
--     \   switch#NormalizedCase(['true', 'false']),
--     \   switch#NormalizedCase(['before', 'after']),
--     \   switch#NormalizedCase(['to', 'from']),
--     \   switch#NormalizedCase(['==', '!=']),
--     \   switch#NormalizedCase(['min', 'max']),
--     \   switch#NormalizedCase(['UAT', 'PROD']),
--     \ ]
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- " /SWITCH.VIM



-- " VIM WIKI
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- let g:vimwiki_list = [{'path': '~/GBox/Notes/wiki/',
--                       \ 'syntax': 'markdown', 'ext': '.md'}]
-- " :help g:vimwiki_map_prefix
-- let g:vimwiki_map_prefix = '<leader>v'
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- " /VIM WIKI


