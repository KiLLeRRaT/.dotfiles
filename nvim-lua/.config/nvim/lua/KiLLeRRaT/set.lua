
-- vim.opt.tabstop = 4
-- vim.opt.softtabstop = 4
-- vim.opt.shiftwidth = 4
-- vim.opt.expandtab = true



-- " CONTENTS
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- " REMAPS / REMAPPINGS / KEYS
-- " FUGITIVE
-- " PLUGINS
-- " FOLDING
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- set path+=**

-- set number
vim.opt.number = true
-- set relativenumber
vim.opt.relativenumber = true

-- set hlsearch
vim.opt.hlsearch = true
-- set cursorline
vim.opt.cursorline = true
-- set incsearch
vim.opt.incsearch = true
-- set spelllang=en,af
vim.opt.spelllang = "en,af"
-- set dictionary=/usr/share/dict/words
-- vim.opt.spelllang = "/usr/share/dict/words"

-- set showcmd
vim.opt.showcmd = true
-- set autoread " READ FILE IF OUTSIDE CHANGES ARE DETECTED

-- set textwidth=100         " command 'gw' formats text to this width
vim.opt.textwidth = 100

-- set ignorecase           " case insensitive search...
vim.opt.ignorecase = true
-- set smartcase		" if you do a search with a capital in it, it will
vim.opt.smartcase = true
-- 			" perform a case sensitive search

-- " Tabs and not spaces!
-- set autoindent
vim.opt.autoindent = true
-- set noexpandtab
vim.opt.expandtab = false

-- set tabstop=2
vim.opt.tabstop = 2
-- set shiftwidth=2
vim.opt.shiftwidth = 2

-- set splitright splitbelow " Open splits in the right and below
vim.opt.splitright = true
vim.opt.splitbelow = true

-- " Shady Characters
-- " set listchars=tab:>\ ,nbsp:_,trail:·
-- set listchars=tab:\|\ ,nbsp:_,trail:·,space:·
vim.opt.listchars = "tab:| ,nbsp:_,trail:·,space:·"

-- set list
vim.opt.list = true
-- set nowrap
vim.opt.wrap = false
-- set mouse=a
vim.opt.mouse = "a"

-- " SET SHELL TO POWERSHELL
if vim.fn.has('win32') then
	-- let &shell = 'pwsh'
	vim.o.shell = 'pwsh'
	-- let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
	vim.o.shellcmdflag = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
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
-- autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = {"*"},
	command = vim.cmd[[highlight ExtraWhitespace ctermbg=red guibg=red]],
})

-- local whitespaceMatch = vim.api.nvim_create_augroup("WhitespaceMatch", {})
-- augroup WhitespaceMatch
	-- group = "whitespaceMatch"

--   " Remove ALL autocommands for the WhitespaceMatch group.
--   autocmd!
--   autocmd BufWinEnter * let w:whitespace_match_number =
--         \ matchadd('ExtraWhitespace', '\s\+$')
vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = {"*"},
	command = vim.cmd[[let w:whitespace_match_number =
		\ matchadd('ExtraWhitespace', '\s\+$')]],
})

--   autocmd InsertEnter * call s:ToggleWhitespaceMatch('i')
-- vim.api.nvim_create_autocmd("InsertEnter", {
-- 	pattern = {"*"},
-- 	command = vim.cmd[[call s:ToggleWhitespaceMatch('i')]],
-- })

--   autocmd InsertLeave * call s:ToggleWhitespaceMatch('n')
-- vim.api.nvim_create_autocmd("InsertLeave", {
-- 	pattern = {"*"},
-- 	command = vim.cmd[[call s:ToggleWhitespaceMatch('n')]],
-- })

-- augroup END

-- function! s:ToggleWhitespaceMatch(mode)
--   let pattern = (a:mode == 'i') ? '\s\+\%#\@<!$' : '\s\+$'
--   if exists('w:whitespace_match_number')
--     call matchdelete(w:whitespace_match_number)
--     call matchadd('ExtraWhitespace', pattern, 10, w:whitespace_match_number)
--   else
--     " Something went wrong, try to be graceful.
--     let w:whitespace_match_number =  matchadd('ExtraWhitespace', pattern)
--   endif
-- endfunction

-- " HIGHLIGHT YANKED TEXT
-- autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup=(vim.fn['hlexists']('HighlightedyankRegion') > 0 and 'HighlightedyankRegion' or 'IncSearch'), timeout=700}
-- FROM: https://github.com/neovim/neovim/issues/17758#issuecomment-1072650270
local highlight_yank = vim.api.nvim_create_augroup("highlight_yank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", { callback = function()
	vim.highlight.on_yank({ higroup = "IncSearch", timeout = 700 })
end, group = highlight_yank })


-- " INSTALL VIM PLUGGED
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- "if (has('win32'))
-- "	" WINDOWS
-- "	" let plugPath = 'C:/GBox/Applications/Tools/Applications/Neovim/nvim-win64/lsp-instance/data/nvim-data/site/autoload/plug.vim'
-- "	" if empty(glob('~/AppData/Local/nvim-data/site/autoload/plug.vim'))
-- "	if empty(glob(stdpath('data') . '/site/autoload/plug.vim'))
-- "			silent !curl -fLo glob(stdpath('data') . '/site/autoload/plug.vim') --create-dirs
-- "					\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
-- "			"autocmd VimEnter * PlugInstall --sync | source ~/AppData/Local/nvim/init.vim
-- "			autocmd VimEnter * PlugInstall --sync | source stdpath('config') . '/init.vim'
-- "	endif
-- "elseif (has('mac') || has('unix'))
-- "	" LINUX
-- "	let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
-- "	if empty(glob(data_dir . '/autoload/plug.vim'))
-- "		silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
-- "		autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
-- "	endif
-- "endif


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
-- set viewoptions-=options
vim.opt.viewoptions = vim.opt.viewoptions - { "options" }

-- autocmd BufWinLeave *.* mkview
local folding = vim.api.nvim_create_augroup("folding", { clear = true })
vim.api.nvim_create_autocmd("BufWinLeave", {
	pattern = {"*"},
	command = vim.cmd[[mkview]],
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
	pattern = {"*.cshtml"},
	callback = function()
		vim.opt.syntax = "html"
		print("syntax=htmlAlbert")
	end,
	group = syntax_cshtml
})

-- syntax on
-- set background=dark
vim.opt.background = "dark"

-- " let g:solarized_termtrans = 1
-- "colorscheme solarized

-- " let g:gruvbox_guisp_fallback = "bg" " THIS TURNS ON SPELLBAD PROPERLY FOR SPELLCHECK HIGHLIGHTING IN GRUVBOX
-- " let g:gruvbox_transparent_bg = 1
-- " colorscheme gruvbox

-- let g:tokyonight_transparent = 1
vim.g.tokyonight_transparent = true
vim.g.tokyonight_transparent_sidebar = true
-- colorscheme tokyonight
vim.cmd("colorscheme tokyonight")

-- autocmd VimEnter * hi Normal ctermbg=none

-- set termguicolors
vim.opt.termguicolors = true

-- hi! Normal ctermbg=NONE guibg=NONE

vim.g.mapleader = " "





















-- " TELESCOPE
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- " nnoremap <leader>ff <cmd>Telescope find_files<cr>
-- nnoremap <leader>ff <cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files<cr>
-- " LAST TELESCOPE VERSION WHERE THE BELOW WORKS: git reset --hard 5a58b1f
-- nnoremap <leader>fF :execute 'Telescope find_files default_text=' . "'" . expand('<cword>')<cr>
-- nnoremap <leader>fg <cmd>Telescope live_grep<cr>
-- nnoremap <leader>fG :execute 'Telescope live_grep default_text=' . expand('<cword>')<cr>

-- " nnoremap <leader>fR <cmd>lua require("telescope").extensions.live_grep_raw.live_grep_raw()<cr>
-- nnoremap <leader>fR <cmd>lua require("telescope").extensions.live_grep_args.live_grep_args()<cr>

-- nnoremap <leader>fb <cmd>Telescope buffers<cr>
-- nnoremap <leader>fk <cmd>Telescope help_tags<cr>
-- nnoremap <leader>fm <cmd>Telescope keymaps<cr>
-- nnoremap <leader>fc <cmd>Telescope git_commits<cr>
-- nnoremap <leader>fr <cmd>Telescope git_branches<cr>
-- " nnoremap <leader>fs <cmd>Telescope git_status<cr>
-- nnoremap <leader>fs <cmd>Telescope colorscheme<cr>
-- nnoremap <leader>fh <cmd>Telescope help_tags<cr>

-- " OVERRIDES THE STANDARD z= shortcut!
-- nnoremap z= <cmd>Telescope spell_suggest<cr>

-- " SEARCH MY OWN GBOX SCRIPTS
-- lua require("killerrat")
-- nnoremap <leader>sf :lua require('killerrat.telescope').search_scripts()<CR>
-- nnoremap <leader>sg :lua require('killerrat.telescope').grep_scripts()<CR>

-- " lua require('telescope').load_extension('fzf')
-- " lua require('telescope').load_extension('hop')

-- " COMMENTARY
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- " SET // COMMENTS FOR C# FILES
-- autocmd FileType cs setlocal commentstring=\/\/\ %s

-- " SET -- COMMENTS FOR SQL FILES
-- autocmd FileType sql setlocal commentstring=--\ %s

-- " SET -- COMMENTS FOR YAML FILES
-- " autocmd FileType yaml setlocal commentstring=#\ %s
-- " autocmd FileType yml setlocal commentstring=#\ %s

-- " COMMENT OUT USING {/* */}, AND SUPPORTS REPEAT FOR THE ENTIRE COMMAND
-- " autocmd FileType typescriptreact nnoremap <leader>gcc I{/*<esc>A*/}<esc><cr>
-- function! CommentReact()
-- 		exec "normal! I{/*\<esc>A*/}\<esc>"
-- 		silent! call repeat#set("\<space>gcc", v:count)
-- endfunction
-- autocmd FileType typescriptreact nnoremap <buffer> <leader>gcc :call CommentReact()<cr>

-- " autocmd FileType typescriptreact nnoremap <leader>gcu ^3dl<esc>$F*D<cr>
-- function! UncommentReact()
-- 		exec "normal! ^3dl\<esc>$F*D"
-- 		silent! call repeat#set("\<space>gcu", v:count)
-- endfunction
-- autocmd FileType typescriptreact nnoremap <buffer> <leader>gcu :call UncommentReact()<cr>
-- " /COMMENT OUT USING {/* */}, AND SUPPORTS REPEAT FOR THE ENTIRE COMMAND


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

-- " HOP, REPLACES EASY MOTION
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- lua require'hop'.setup { keys = 'asdfghjkl;qwertyuiopzxcvbnm', jump_on_sole_occurrence = false }
-- " map <Leader>w :HopWord<cr>
-- map <Leader>w <cmd>:HopWord<cr>
-- map <Leader>W <cmd>:HopWordMW<cr>
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- " /HOP

-- " NERDTree
-- "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- " " Start NERDTree when Vim starts with a directory argument.
-- " autocmd StdinReadPre * let s:std_in=1
-- " autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
-- "     \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

-- " " If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
-- " autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
-- "     \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
-- "
-- " enable line numbers
-- let NERDTreeShowLineNumbers=1
-- let NERDTreeShowHidden=1
-- " FROM: https://stackoverflow.com/a/47287079/182888
-- let g:NERDTreeChDirMode = 2

-- if (has('win32'))
-- 	" let g:NERDTreeCopyCmd= 'copy '
-- 	let g:NERDTreeCopyCmd= 'Copy-Item -Recurse '
-- endif

-- " make sure relative line numbers are used
-- autocmd FileType nerdtree setlocal relativenumber

-- nnoremap <leader>nn :NERDTreeFocus<CR>
-- " nnoremap <leader>n :NERDTree<CR>
-- nnoremap <leader>nt :NERDTreeToggle<CR>
-- " nnoremap <leader>n :NERDTreeToggle<CR>
-- nnoremap <leader>nf :NERDTreeFind<CR>

-- " Start NERDTree when Vim is started without file arguments.
-- " autocmd StdinReadPre * let s:std_in=1
-- " autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

-- " Start NERDTree when Vim starts with a directory argument.
-- " autocmd StdinReadPre * let s:std_in=1
-- " autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
-- " 		\ execute 'NERDTree' argv()[0] | wincmd p | enew | wincmd p | execute 'cd '.argv()[0] | endif

-- " If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
-- " autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
-- " 		\ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
-- "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- " /NERDTree

-- " HARPOON
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- nnoremap <silent><leader>a :lua require("harpoon.mark").add_file()<CR>
-- nnoremap <silent><leader>A :lua require("harpoon.ui").toggle_quick_menu()<CR>
-- " nnoremap <silent><leader>H :lua require("harpoon.ui").toggle_quick_menu()<CR>

-- nnoremap <silent><leader>h :lua require("harpoon.ui").nav_file(1)<CR>
-- nnoremap <silent><leader>j :lua require("harpoon.ui").nav_file(2)<CR>
-- nnoremap <silent><leader>k :lua require("harpoon.ui").nav_file(3)<CR>
-- nnoremap <silent><leader>l :lua require("harpoon.ui").nav_file(4)<CR>
-- nnoremap <silent><leader>; :lua require("harpoon.ui").nav_file(5)<CR>

-- nnoremap <silent><leader>H :vsp<CR>:lua require("harpoon.ui").nav_file(1)<CR>
-- nnoremap <silent><leader>J :vsp<CR>:lua require("harpoon.ui").nav_file(2)<CR>
-- nnoremap <silent><leader>K :vsp<CR>:lua require("harpoon.ui").nav_file(3)<CR>
-- nnoremap <silent><leader>L :vsp<CR>:lua require("harpoon.ui").nav_file(4)<CR>
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- " FUGITIVE
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- nnoremap <leader>gs :Git<cr>
-- nnoremap <leader>gS :Git pull<cr>:Git push<cr>
-- nnoremap <leader>gp :Git push<cr>
-- nnoremap <leader>gP :Git push --force-with-lease<cr>
-- nnoremap <leader>gf :Git fetch<cr>
-- nnoremap <leader>gl :Git pull<cr>
-- nnoremap <leader>gbb :Git branch<cr>
-- nnoremap <leader>gba :Git branch --all<cr>
-- nnoremap <leader>gbr :Git branch --remote<cr>
-- nnoremap <leader>gbd :Git branch -d
-- nnoremap <leader>gbD :Git branch -D
-- " nnoremap <leader>gcc :Git commit -m ""<left>
-- " nnoremap <leader>gca :Git commit -am ""<left>
-- nnoremap <leader>gco :Git checkout<space>
-- nnoremap <leader>gT :Git tag<cr>
-- nnoremap <leader>gt :Git tag<space>
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- " /FUGITIVE

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

-- " GITHUB COPILOT
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
-- let g:copilot_no_tab_map = v:true
-- " let g:copilot_filetypes = {
-- " 	\ 'TelescopePrompt': v:false,
-- " 	\ }
-- " ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- " /GITHUB COPILOT

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


