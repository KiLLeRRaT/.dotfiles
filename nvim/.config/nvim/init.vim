" CONTENTS
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" REMAPS / REMAPPINGS / KEYS
" FUGITIVE
" PLUGINS
" FOLDING
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set path+=**
set number
set relativenumber
set hlsearch
set cursorline
set incsearch
set spelllang=en,af
set dictionary=/usr/share/dict/words
set showcmd
set autoread " READ FILE IF OUTSIDE CHANGES ARE DETECTED
" set columns=80           " window width in columns

" UPDATED TO 100 on 25 Mar 2022
" set textwidth=80         " command 'gw' formats text to this width
set textwidth=100         " command 'gw' formats text to this width

set ignorecase           " case insensitive search...
set smartcase		" if you do a search with a capital in it, it will
			" perform a case sensitive search

" Tabs and not spaces!
set autoindent
set noexpandtab

" set tabstop=4
" set shiftwidth=4
set tabstop=2
set shiftwidth=2

set splitright splitbelow " Open splits in the right and below

" Shady Characters
" set listchars=tab:>\ ,nbsp:_,trail:·
set listchars=tab:\|\ ,nbsp:_,trail:·,space:·
" " set listchars=tab:🠞\ ,nbsp:_,trail:·
set list
set nowrap
set mouse=a

" SET SHELL TO POWERSHELL
if (has('win32'))
	" let &shell = has('win32') ? 'powershell' : 'pwsh'
	let &shell = 'pwsh'
	let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
	" let &shellredir = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode' " OLD METHOD, SEE: :help shell-powershell
	let &shellredir = '-RedirectStandardOutput %s -NoNewWindow -Wait'
	let &shellpipe = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
	set shellquote= shellxquote=
	set noshelltemp " FROM: https://superuser.com/a/1561892/69729, Sorts out the issue with shell returned 1, E485 and temp files
endif
" /SET SHELL TO POWERSHELL

" SET FONT TO NERDFONT IF USING nvim-qt
if exists(':GuiFont')
	GuiFont! CaskaydiaCove Nerd Font:h12
endif


" if (has('wsl'))
" 	" SET WSL CLIPBOARD INTEGRATION, just install choco install win32yank
" 	" clipboard with win32yank.exe
" 	" in ~/bin/win32yank.exe
" 	" https://github.com/equalsraf/win32yank/releases {{{
" 	let g:clipboard = {
" 													\   'name': 'win32yank-wsl',
" 													\   'copy': {
" 													\      '+': 'win32yank.exe -i --crlf',
" 													\      '*': 'win32yank.exe -i --crlf',
" 													\    },
" 													\   'paste': {
" 													\      '+': 'win32yank.exe -o --lf',
" 													\      '*': 'win32yank.exe -o --lf',
" 													\   },
" 													\   'cache_enabled': 0,
" 													\ }
" 	" }}}
" endif



" MAKE ESC GO TO NORMAL MODE IN TERMINAL, FROM: http://vimcasts.org/episodes/neovim-terminal-mappings/
" tnoremap <Esc> <C-\><C-n>
" tnoremap <M-[> <Esc>
" tnoremap <C-v><Esc> <Esc>
tnoremap jk <C-\><C-n>
" tnoremap <M-[> <Esc>
" VERBATIM ESCAPE, JUST LIKE <C-V> TO ENTER OTHER COMMANDS LIKE TAB ETC.
tnoremap <C-v><Esc> <Esc>
" tnoremap <C-w>h <C-\><C-n><C-w>h
" tnoremap <C-w>j <C-\><C-n><C-w>j
" tnoremap <C-w>k <C-\><C-n><C-w>k
" tnoremap <C-w>l <C-\><C-n><C-w>l

" MAKE SURE TO KEEP YOUR COLOR SCHEME AFTER LOADING ANOTHER SCHEME LATER DOWN
" THE CONFIG
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red

augroup WhitespaceMatch
  " Remove ALL autocommands for the WhitespaceMatch group.
  autocmd!
  autocmd BufWinEnter * let w:whitespace_match_number =
        \ matchadd('ExtraWhitespace', '\s\+$')
  autocmd InsertEnter * call s:ToggleWhitespaceMatch('i')
  autocmd InsertLeave * call s:ToggleWhitespaceMatch('n')
augroup END
function! s:ToggleWhitespaceMatch(mode)
  let pattern = (a:mode == 'i') ? '\s\+\%#\@<!$' : '\s\+$'
  if exists('w:whitespace_match_number')
    call matchdelete(w:whitespace_match_number)
    call matchadd('ExtraWhitespace', pattern, 10, w:whitespace_match_number)
  else
    " Something went wrong, try to be graceful.
    let w:whitespace_match_number =  matchadd('ExtraWhitespace', pattern)
  endif
endfunction



" SHOW LONG LINES
highlight ColorColumn cterm=reverse ctermfg=142 ctermbg=235 gui=reverse guifg=#b8bb26 guibg=#282828
call matchadd('ColorColumn', '\%101v', 100)

" https://superuser.com/a/356865/69729
" autocmd Filetype * :match Error /^\t*\zs \+/
" autocmd Filetype * if &ft!="yaml"|:match Error /^\t*\zs \+/|endif
" autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab | match none

" HIGHLIGHT YANKED TEXT
autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup=(vim.fn['hlexists']('HighlightedyankRegion') > 0 and 'HighlightedyankRegion' or 'IncSearch'), timeout=700}

" Nice menu when typing `:find *.py`
set wildmode=longest,list,full
set wildmenu
" Ignore files
set wildignore+=*_build/*
set wildignore+=**/node_modules/*
set wildignore+=**/.git/*

" Bit of NETRW tweaks to make it more like NERDTree
" let g:netrw_banner = 0
" let g:netrw_liststyle = 3
" let g:netrw_browse_split = 4
" let g:netrw_altv = 1
" let g:netrw_winsize = 10
"  augroup ProjectDrawer
"  	autocmd!
"  	autocmd VimEnter * :Vexplore
 " augroup END


" INSTALL VIM PLUGGED
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"if (has('win32'))
"	" WINDOWS
"	" let plugPath = 'C:/GBox/Applications/Tools/Applications/Neovim/nvim-win64/lsp-instance/data/nvim-data/site/autoload/plug.vim'
"	" if empty(glob('~/AppData/Local/nvim-data/site/autoload/plug.vim'))
"	if empty(glob(stdpath('data') . '/site/autoload/plug.vim'))
"			silent !curl -fLo glob(stdpath('data') . '/site/autoload/plug.vim') --create-dirs
"					\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"			"autocmd VimEnter * PlugInstall --sync | source ~/AppData/Local/nvim/init.vim
"			autocmd VimEnter * PlugInstall --sync | source stdpath('config') . '/init.vim'
"	endif
"elseif (has('mac') || has('unix'))
"	" LINUX
"	let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
"	if empty(glob(data_dir . '/autoload/plug.vim'))
"		silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
"		autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
"	endif
"endif


" PLUGINS
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" call plug#begin('~/.dotfiles/nvim/.config/nvim/plugged') " LINUX, REMOVED PATH SO THAT ITS NOT IN
" MY GIT REPO
call plug#begin()
" THEMES
" Plug 'altercation/vim-colors-solarized'
" Plug 'morhetz/gruvbox'
Plug 'https://github.com/folke/tokyonight.nvim', { 'branch': 'main' }

Plug 'https://github.com/nvim-lua/plenary.nvim'
Plug 'https://github.com/nvim-telescope/telescope.nvim'
Plug 'https://github.com/preservim/nerdtree'
Plug 'https://github.com/ThePrimeagen/harpoon'
" Plug 'ThePrimeagen/vim-be-good'
Plug 'https://github.com/tpope/vim-abolish'
Plug 'https://github.com/tpope/vim-commentary'
Plug 'https://github.com/tpope/vim-eunuch'
Plug 'https://github.com/tpope/vim-fugitive'
Plug 'https://github.com/tpope/vim-repeat'
Plug 'https://github.com/tpope/vim-surround'
Plug 'https://github.com/tpope/vim-unimpaired'
" Plug 'vim-airline/vim-airline'
Plug 'https://github.com/nvim-lualine/lualine.nvim'
Plug 'https://github.com/akinsho/bufferline.nvim'
Plug 'https://github.com/phaazon/hop.nvim'

Plug 'https://github.com/nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'https://github.com/nvim-telescope/telescope-live-grep-args.nvim'
Plug 'https://github.com/github/copilot.vim'
Plug 'https://github.com/dstein64/vim-startuptime'
Plug 'https://github.com/ap/vim-css-color'
" Plug 'ryanoasis/vim-devicons'
Plug 'https://github.com/kyazdani42/nvim-web-devicons'
Plug 'https://github.com/lewis6991/gitsigns.nvim'
" Plug 'nvim-telescope/telescope-hop.nvim'
" Plug 'nvim-telescope/telescope-rg.nvim'
" Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'https://github.com/neoclide/vim-jsx-improve'
Plug 'https://github.com/jdhao/better-escape.vim'
Plug 'https://github.com/simeji/winresizer'
Plug 'PhilRunninger/nerdtree-visual-selection'
Plug 'https://github.com/nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects'
Plug 'https://github.com/vimwiki/vimwiki'

" LSP RELATED PLUGINS
Plug 'https://github.com/neovim/nvim-lspconfig'
Plug 'https://github.com/hrsh7th/nvim-cmp' " autocompletion framework
Plug 'https://github.com/hrsh7th/cmp-nvim-lsp' " LSP autocompletion provider
Plug 'https://github.com/hrsh7th/cmp-buffer'
Plug 'https://github.com/hrsh7th/cmp-path'
Plug 'https://github.com/hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'https://github.com/hrsh7th/cmp-calc'
Plug 'https://github.com/williamboman/nvim-lsp-installer'
" https://github.com/hrsh7th?tab=repositories

" /LSP RELATED PLUGINS

" SQL
" Plug 'https://github.com/tpope/vim-dadbod'
" Plug 'https://github.com/kristijanhusak/vim-dadbod-ui'
" Plug 'https://github.com/kristijanhusak/vim-dadbod-completion'

" DEBUGGERS
" Plug 'https://github.com/leoluz/nvim-dap-go'
Plug 'https://github.com/rcarriga/nvim-dap-ui'
Plug 'https://github.com/theHamsta/nvim-dap-virtual-text'
Plug 'https://github.com/nvim-telescope/telescope-dap.nvim'
Plug 'https://github.com/mfussenegger/nvim-dap'

" Modify files right in the quick fix list
Plug 'https://github.com/stefandtw/quickfix-reflector.vim'

" SWITCH TO OPPOSITE WORD, E.G. TRUE -> FALSE, etc.
Plug 'https://github.com/AndrewRadev/switch.vim'
Plug 'https://github.com/lambdalisue/suda.vim'

" Open LSP goto defn in floating windows
Plug 'https://github.com/rmagatti/goto-preview'
call plug#end()


" SNAPSHOT PLUGINS BEFORE UPDATING!!!
" FROM: https://shyr.io/blog/vim-plugin-lockfile
command APlugUpdate
  \ PlugUpdate | exe 'PlugSnapshot! ' . stdpath('config') . '/vim-plug-snapshot.vim'


" FOLDING
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldcolumn=1 "defines 1 col at window left, to indicate folding
set foldlevelstart=99 "start file with all folds opened

let javaScript_fold=1 "activate folding by JS syntax
" let cs_fold=1
" let xml_syntax_folding=1
let xml_folding=1
let yaml_fold=1
let vb_fold=1

" SAVE FOLDING AND OTHER THINGS WHEN YOU OPEN AND CLOSE FILES/VIM, FROM: https://vim.fandom.com/wiki/Make_views_automatic
set viewoptions-=options
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent! loadview

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" /FOLDING

" SYNTAX HIGHLIGHTING FOR CSHTML/RAZOR
autocmd BufNewFile,BufRead *.cshtml set syntax=html

syntax on
set background=dark
" let g:solarized_termtrans = 1
"colorscheme solarized

" let g:gruvbox_guisp_fallback = "bg" " THIS TURNS ON SPELLBAD PROPERLY FOR SPELLCHECK HIGHLIGHTING IN GRUVBOX
" let g:gruvbox_transparent_bg = 1
" colorscheme gruvbox

let g:tokyonight_transparent = 1
colorscheme tokyonight

autocmd VimEnter * hi Normal ctermbg=none

set termguicolors
hi! Normal ctermbg=NONE guibg=NONE

" REMAPS / REMAPPINGS / KEYS
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
let mapleader = " "

" SWITCH TO PREV BUFFER AND CLOSE THE ONE YOU SWITCHED AWAY FROM, CLOSES A
" BUFFER WITHOUT MESSING UP THE SPLIT
nnoremap <leader>bd :bp \| :sp \| :bn \| :bd<cr>

nnoremap <leader>ba :bufdo bd<cr>

nnoremap ' `

" KEEP CURSOR IN THE CENTRE OF THE SCREEN WHEN SEARCHING NEXT
nnoremap n nzzzv
nnoremap N Nzzzv

" KEEP CURSOR IN A SANE PLACE WHEN USING J TO JOIN LINES
nnoremap J mzJ`z

" does not work in VSCODE
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y gg"+yG
" does not work in VSCODE

" DELETE INTO BLACK HOLE REGISTER
nnoremap <leader>d "_d
vnoremap <leader>d "_d

" [count] yanks, comments out, and pastes a copy below
" nnoremap <expr> <leader>t '<esc>' . v:count1 . 'yy:.,+' . (v:count1 - 1) . 'Commentary<cr>' . v:count1 . 'j<esc>P'
nnoremap <expr> <leader>T '<esc>' . v:count1 . '"zyy:.,+' . (v:count1 - 1) . 'Commentary<cr>' . v:count1 . 'j<esc>"zP'
nnoremap <expr> <leader>t '<esc>' . v:count1 . '"zyy' . v:count1 . 'j<esc>"zP'

" https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text
xnoremap <leader>p "_dP

" REPLACE SELECTION WITH YANKED TEXT
nnoremap <leader>riw ciw<C-R><C-0><esc>
nnoremap <leader>rit cit<C-R><C-0><esc>
nnoremap <leader>ri" ci"<C-R><C-0><esc>
nnoremap <leader>ri' ci'<C-R><C-0><esc>
nnoremap <leader>ri( ci)<C-R><C-0><esc>
nnoremap <leader>ri) ci)<C-R><C-0><esc>
nnoremap <leader>rib cib<C-R><C-0><esc>
nnoremap <leader>ri{ ci{<C-R><C-0><esc>
nnoremap <leader>ri} ci}<C-R><C-0><esc>
nnoremap <leader>ri[ ci[<C-R><C-0><esc>
nnoremap <leader>ri] ci]<C-R><C-0><esc>
nnoremap <leader>ri< ci<<C-R><C-0><esc>
nnoremap <leader>ri> ci><C-R><C-0><esc>
nnoremap <leader>ri` ci`<C-R><C-0><esc>

" REPLACE SELECTION WITH YANKED TEXT FROM CLIPBOARD
nnoremap <leader>Riw ciw<C-R><C-*><esc>
nnoremap <leader>Rit cit<C-R><C-*><esc>
nnoremap <leader>Ri" ci"<C-R><C-*><esc>
nnoremap <leader>Ri' ci'<C-R><C-*><esc>
nnoremap <leader>Ri( ci)<C-R><C-*><esc>
nnoremap <leader>Ri) ci)<C-R><C-*><esc>
nnoremap <leader>Rib cib<C-R><C-*><esc>
nnoremap <leader>Ri{ ci{<C-R><C-*><esc>
nnoremap <leader>Ri} ci}<C-R><C-*><esc>
nnoremap <leader>Ri[ ci[<C-R><C-*><esc>
nnoremap <leader>Ri] ci]<C-R><C-*><esc>
nnoremap <leader>Ri< ci<<C-R><C-*><esc>
nnoremap <leader>Ri> ci><C-R><C-*><esc>
nnoremap <leader>Ri` ci`<C-R><C-*><esc>

nnoremap <leader>raw caw<C-R><C-0><esc>
nnoremap <leader>rat cat<C-R><C-0><esc>
nnoremap <leader>ra" ca"<C-R><C-0><esc>
nnoremap <leader>ra' ca'<C-R><C-0><esc>
nnoremap <leader>ra( ca)<C-R><C-0><esc>
nnoremap <leader>ra) ca)<C-R><C-0><esc>
nnoremap <leader>rab cab<C-R><C-0><esc>
nnoremap <leader>ra{ ca{<C-R><C-0><esc>
nnoremap <leader>ra} ca}<C-R><C-0><esc>
nnoremap <leader>ra[ ca[<C-R><C-0><esc>
nnoremap <leader>ra] ca]<C-R><C-0><esc>
nnoremap <leader>ra< ca<<C-R><C-0><esc>
nnoremap <leader>ra> ca><C-R><C-0><esc>
nnoremap <leader>ra` ca`<C-R><C-0><esc>

nnoremap <leader>Raw caw<C-R><C-*><esc>
nnoremap <leader>Rat cat<C-R><C-*><esc>
nnoremap <leader>Ra" ca"<C-R><C-*><esc>
nnoremap <leader>Ra' ca'<C-R><C-*><esc>
nnoremap <leader>Ra( ca)<C-R><C-*><esc>
nnoremap <leader>Ra) ca)<C-R><C-*><esc>
nnoremap <leader>Rab cab<C-R><C-*><esc>
nnoremap <leader>Ra{ ca{<C-R><C-*><esc>
nnoremap <leader>Ra} ca}<C-R><C-*><esc>
nnoremap <leader>Ra[ ca[<C-R><C-*><esc>
nnoremap <leader>Ra] ca]<C-R><C-*><esc>
nnoremap <leader>Ra< ca<<C-R><C-*><esc>
nnoremap <leader>Ra> ca><C-R><C-*><esc>
nnoremap <leader>Ra` ca`<C-R><C-*><esc>
" /REPLACE SELECTION WITH YANKED TEXT

" BELOW COMMENTED OUT BECAUSE IT BREAKS THE ABOVE...
" nnoremap <leader>p "+p

" DISABLE CTRL-Z IN WINDOWS SINCE IT FREEZES VIM!: https://github.com/neovim/neovim/issues/6660
nnoremap <C-z> <nop>
inoremap <C-z> <nop>
vnoremap <C-z> <nop>
snoremap <C-z> <nop>
xnoremap <C-z> <nop>
cnoremap <C-z> <nop>
onoremap <C-z> <nop>


" Append inside ", ), etc, to get the ^R you have to press ctrl + v, and then
" ctrl + r to input ^R
nnoremap <leader>ciw ciw"
nnoremap <leader>ciW ciW"
nnoremap <leader>cit cit"
nnoremap <leader>ci" ci""
nnoremap <leader>ci' ci'"
nnoremap <leader>ci( ci("
nnoremap <leader>cib cib"
nnoremap <leader>ci) ci)"
nnoremap <leader>ci{ ci{"
nnoremap <leader>ci} ci}"
nnoremap <leader>ci[ ci["
nnoremap <leader>ci] ci]"
nnoremap <leader>ci< ci<"
nnoremap <leader>ci> ci>"
nnoremap <leader>ci` ci`"

" COPY CURRENT FILENAME OR FULL FILE PATH TO SYSTEM CLIPBOARD
nnoremap <leader>cf :echo expand("%:t") \| :let @+ = expand("%:t")<cr>
nnoremap <leader>cF :echo expand("%:p") \| :let @+ = expand("%:p")<cr>
" OPEN CURRENT FOLDER IN WINDOWS EXPLORER
" EXPAND COLON PARAMETERS FROM: https://vi.stackexchange.com/a/1885
nnoremap gF :!start %:p:h<cr>

" " REPLACE VISUAL SELECTION
" vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" REFRESH FILE FROM DISK
nnoremap <F5> :e %<cr>

" REFRESH FILE FROM DISK AND GO TO BOTTOM
nnoremap <silent><S-F5> :e %<cr>G

" RELOAD CONFIG
" nnoremap <C-f5> :so ~/.dotfiles/nvim/.config/nvim/init.vim<cr>
nnoremap <C-F5> :execute 'source ' . stdpath('config') . '/init.vim'<cr>

" " EDIT CONFIG
" nnoremap <A-f5> :e ~/.dotfiles/nvim/.config/nvim/init.vim<cr>
nnoremap <A-F5> :execute 'edit ' . stdpath('config') . '/init.vim'<cr>:cd %:h<cr>

" EDIT NOTES FOLDER
nnoremap <A-n> :e C:\GBox\Notes<cr>:cd C:\GBox\Notes<cr>

" EDIT SCRIPTS FOLDER
nnoremap <A-s> :e C:\GBox\Applications\Tools\Scripts<cr>:cd C:\GBox\Applications\Tools\Scripts<cr>

" BUILD SOLUTION
nnoremap <leader>rb :!dotnet build *.sln

" DIFF WITH SAVED, FROM: https://stackoverflow.com/a/749320/182888
function! s:DiffWithSaved()
	let filetype=&ft
	diffthis
	vnew | r # | normal! 1Gdd
	diffthis
	exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

" GO TO LINE UNDER CURSOR
" nnoremap gn yiw:exec (@" =~ '^\d\+$' ? 'norm @"G' : '')<cr>
" DO A SEARCH USING THE LINE YOU'RE ON, FROM: https://vi.stackexchange.com/a/6210/38923
" nnoremap <leader>* 0y$/\V<c-r>"<cr>

" SPELL CHECKING ]s and [s for next/prev, z= for spelling suggestion, zg to
" add to dictionary
map <F6> :setlocal spell!<CR>

" map <F2> :AirlineToggle<CR>:AirlineRefresh<CR>
" map <C-F2> :AirlineRefresh<CR>

" RUN jq and use tab indents, then remove the ^M chars because vim is doing stupid things.
" vnoremap <leader>=j :'<,'>!jq --tab .<cr>:%s/\r/e<cr>
" nnoremap <leader>=j :%!jq --tab .<cr>:%s/\r/e<cr>
vnoremap <leader>=j :'<,'>!jq "--tab ."<cr>:%s/\r<cr>
nnoremap <leader>=j :%!jq "--tab ."<cr>:%s/\r<cr>
" PASTE JSON FROM CLIPBOARD, AND FORMAT IT
nnoremap <leader>=J ggdG"+P:%!jq "--tab ."<cr>:%s/\r<cr>
" RETAB FILE
nnoremap <leader>=t :%retab!<cr>
" REMOVE TRAILING WHITESPACE FROM ALL LINES
nnoremap <leader>=w :%s/\s\+$//<cr>

" cm.Parameters.Add, and cm.Parameters.Value lines can be combined into single line using this
" function! MergeParametersAndValue()
" 	exec "normal ^f@ya\"$x/\<c-r>0\<cr>f.y$NNA\<c-r>0\<esc>0"
" 	silent! call repeat#set("\<space>=v", v:count)
" endfunction

function! MergeParametersAndValue()
	exec "normal ^f@ya\"$x/\<c-r>0\<cr>f.y$ddNA\<c-r>0\<esc>0"
	silent! call repeat#set("\<space>=v", v:count)
endfunction
autocmd FileType cs nnoremap <buffer> <leader>=v :call MergeParametersAndValue()<cr>



" TELESCOPE
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>ff <cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files<cr>
" LAST TELESCOPE VERSION WHERE THE BELOW WORKS: git reset --hard 5a58b1f
" nnoremap <expr> <leader>fF ':Telescope find_files<cr>' . "'" . expand('<cword>')
nnoremap <leader>fF :execute 'Telescope find_files default_text=' . "'" . expand('<cword>')<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
" nnoremap <expr> <leader>fG ':Telescope live_grep<cr>' . expand('<cword>')
nnoremap <leader>fG :execute 'Telescope live_grep default_text=' . expand('<cword>')<cr>

" nnoremap <leader>fR <cmd>lua require("telescope").extensions.live_grep_raw.live_grep_raw()<cr>
nnoremap <leader>fR <cmd>lua require("telescope").extensions.live_grep_args.live_grep_args()<cr>

nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fk <cmd>Telescope help_tags<cr>
nnoremap <leader>fm <cmd>Telescope keymaps<cr>
nnoremap <leader>fc <cmd>Telescope git_commits<cr>
nnoremap <leader>fr <cmd>Telescope git_branches<cr>
" nnoremap <leader>fs <cmd>Telescope git_status<cr>
nnoremap <leader>fs <cmd>Telescope colorscheme<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" OVERRIDES THE STANDARD z= shortcut!
nnoremap z= <cmd>Telescope spell_suggest<cr>

" SEARCH MY OWN GBOX SCRIPTS
lua require("killerrat")
nnoremap <leader>sf :lua require('killerrat.telescope').search_scripts()<CR>
nnoremap <leader>sg :lua require('killerrat.telescope').grep_scripts()<CR>

" lua require('telescope').load_extension('fzf')
" lua require('telescope').load_extension('hop')

" COMMENTARY
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" SET // COMMENTS FOR C# FILES
autocmd FileType cs setlocal commentstring=\/\/\ %s

" SET -- COMMENTS FOR SQL FILES
autocmd FileType sql setlocal commentstring=--\ %s

" SET -- COMMENTS FOR YAML FILES
" autocmd FileType yaml setlocal commentstring=#\ %s
" autocmd FileType yml setlocal commentstring=#\ %s

" COMMENT OUT USING {/* */}, AND SUPPORTS REPEAT FOR THE ENTIRE COMMAND
" autocmd FileType typescriptreact nnoremap <leader>gcc I{/*<esc>A*/}<esc><cr>
function! CommentReact()
		exec "normal! I{/*\<esc>A*/}\<esc>"
		silent! call repeat#set("\<space>gcc", v:count)
endfunction
autocmd FileType typescriptreact nnoremap <buffer> <leader>gcc :call CommentReact()<cr>

" autocmd FileType typescriptreact nnoremap <leader>gcu ^3dl<esc>$F*D<cr>
function! UncommentReact()
		exec "normal! ^3dl\<esc>$F*D"
		silent! call repeat#set("\<space>gcu", v:count)
endfunction
autocmd FileType typescriptreact nnoremap <buffer> <leader>gcu :call UncommentReact()<cr>
" /COMMENT OUT USING {/* */}, AND SUPPORTS REPEAT FOR THE ENTIRE COMMAND


" QUICK FIX LIST: https://stackoverflow.com/a/1747286/182888
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
":copen " Open the quickfix window
":ccl   " Close it
":cw    " Open it if there are "errors", close it otherwise (some people prefer this)
":cn    " Go to the next error in the window
":cp    " Go to the previous error in the window
":cnf   " Go to the first error in the next file
":.cc   " Go to error under cursor (if cursor is in quickfix window)
"nnoremap <leader>cn :cnext<cr>
"nnoremap <leader>cp :cprevious<cr>
"nnoremap <leader>cc :ccl<cr>
"nnoremap <leader>co :copen<cr>
nnoremap <c-q> :copen<cr>
nnoremap <c-j> :cn<cr>
nnoremap <c-k> :cp<cr>
" nnoremap <leader>eq :lopen<cr>
" nnoremap <leader>ej :lnext<cr>
" nnoremap <leader>ek :lprev<cr>

" HOP, REPLACES EASY MOTION
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
lua require'hop'.setup { keys = 'asdfghjkl;qwertyuiopzxcvbnm', jump_on_sole_occurrence = false }
" map <Leader>w :HopWord<cr>
map <Leader>w <cmd>:HopWord<cr>
map <Leader>W <cmd>:HopWordMW<cr>
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" /HOP

" NERDTree
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" " Start NERDTree when Vim starts with a directory argument.
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
"     \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

" " If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
" autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
"     \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
"
" enable line numbers
let NERDTreeShowLineNumbers=1
let NERDTreeShowHidden=1

if (has('win32'))
	" let g:NERDTreeCopyCmd= 'copy '
	let g:NERDTreeCopyCmd= 'Copy-Item -Recurse '
endif

" make sure relative line numbers are used
autocmd FileType nerdtree setlocal relativenumber

nnoremap <leader>nn :NERDTreeFocus<CR>
" nnoremap <leader>n :NERDTree<CR>
nnoremap <leader>nt :NERDTreeToggle<CR>
" nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>nf :NERDTreeFind<CR>

" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" Start NERDTree when Vim starts with a directory argument.
" autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
		\ execute 'NERDTree' argv()[0] | wincmd p | enew | wincmd p | execute 'cd '.argv()[0] | endif

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
" autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
" 		\ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" /NERDTree

" HARPOON
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
nnoremap <silent><leader>a :lua require("harpoon.mark").add_file()<CR>
nnoremap <silent><leader>H :lua require("harpoon.ui").toggle_quick_menu()<CR>
" nnoremap <silent><leader>tc :lua require("harpoon.cmd-ui").toggle_quick_menu()<CR>

nnoremap <silent><leader>h :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <silent><leader>j :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <silent><leader>k :lua require("harpoon.ui").nav_file(3)<CR>
" LEADER LL because leader l will pause for a bit since we use leader lj, etc
" for other things
nnoremap <silent><leader>l :lua require("harpoon.ui").nav_file(4)<CR>
nnoremap <silent><leader>; :lua require("harpoon.ui").nav_file(5)<CR>
" nnoremap <silent><leader>tu :lua require("harpoon.term").gotoTerminal(1)<CR>
" nnoremap <silent><leader>te :lua require("harpoon.term").gotoTerminal(2)<CR>
" nnoremap <silent><leader>cu :lua require("harpoon.term").sendCommand(1, 1)<CR>
" nnoremap <silent><leader>ce :lua require("harpoon.term").sendCommand(1, 2)<CR>
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" FUGITIVE
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
nnoremap <leader>gs :Git<cr>
nnoremap <leader>gS :Git pull<cr>:Git push<cr>
nnoremap <leader>gp :Git push<cr>
nnoremap <leader>gP :Git push --force-with-lease<cr>
nnoremap <leader>gf :Git fetch<cr>
nnoremap <leader>gl :Git pull<cr>
nnoremap <leader>gbb :Git branch<cr>
nnoremap <leader>gba :Git branch --all<cr>
nnoremap <leader>gbr :Git branch --remote<cr>
nnoremap <leader>gbd :Git branch -d
nnoremap <leader>gbD :Git branch -D
" nnoremap <leader>gcc :Git commit -m ""<left>
" nnoremap <leader>gca :Git commit -am ""<left>
nnoremap <leader>gco :Git checkout<space>
nnoremap <leader>gT :Git tag<cr>
nnoremap <leader>gt :Git tag<space>
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" /FUGITIVE

" LSP
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" FROM: https://rudism.com/coding-csharp-in-neovim/

lua require('plugins')

autocmd FileType cs nnoremap <buffer> K :lua vim.lsp.buf.hover()<CR>

" nnoremap gd :lua vim.lsp.buf.definition()<CR>
nnoremap gd :Telescope lsp_definitions<CR>
nnoremap gD :lua vim.lsp.buf.type_definition()<CR>
nnoremap gi :lua vim.lsp.buf.implementation()<CR>
nnoremap gr :Telescope lsp_references<CR>
nnoremap ]g :lua vim.diagnostic.goto_next()<CR>
nnoremap [g :lua vim.diagnostic.goto_prev()<CR>
nnoremap <leader>fd :Telescope diagnostics<CR>
" nnoremap <leader>fa :%Telescope lsp_range_code_actions<CR>
" nnoremap <leader>fa :lua vim.lsp.buf.range_code_action()<CR>
nnoremap <leader>rn :lua vim.lsp.buf.rename()<CR>
nnoremap <leader>ca :lua vim.lsp.buf.code_action()<CR>


" nnoremap('<leader>fu', 'Telescope lsp_references')
" nnoremap('<leader>gd', 'Telescope lsp_definitions')
" nnoremap('<leader>rn', 'lua vim.lsp.buf.rename()')
" nnoremap('<leader>dn', 'lua vim.lsp.diagnostic.goto_next()')
" nnoremap('<leader>dN', 'lua vim.lsp.diagnostic.goto_prev()')
" nnoremap('<leader>dd', 'Telescope lsp_document_diagnostics')
" nnoremap('<leader>dD', 'Telescope lsp_workspace_diagnostics')
" nnoremap('<leader>xx', 'Telescope lsp_code_actions')
" nnoremap('<leader>xd', '%Telescope lsp_range_code_actions')

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" /LSP

" GITHUB COPILOT
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" /GITHUB COPILOT

" GIT SIGNS: https://github.com/lewis6991/gitsigns.nvim
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
lua require('gitsigns').setup()
" Navigation
nnoremap ]c :Gitsigns next_hunk<cr>
nnoremap [c :Gitsigns prev_hunk<cr>

    " -- Actions
nnoremap <leader>ds :Gitsigns stage_hunk<cr>

" REPLACE ^M AFTER RESET HUNK
nnoremap <leader>dr :Gitsigns reset_hunk<cr>:%s/\r<cr>

    " map('n', '<leader>hS', gs.stage_buffer)
nnoremap <leader>du :Gitsigns undo_stage_hunk<cr>
    " map('n', '<leader>hR', gs.reset_buffer)
nnoremap <leader>dp :Gitsigns preview_hunk<cr>
" nnoremap <leader>hb :Gitsigns blame_line{full=true}<cr>
nnoremap <leader>db :Gitsigns toggle_current_line_blame<cr>

    " map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    " map('n', '<leader>tb', gs.toggle_current_line_blame)
    " map('n', '<leader>hd', gs.diffthis)
    " map('n', '<leader>hD', function() gs.diffthis('~') end)
    " map('n', '<leader>td', gs.toggle_deleted)

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" /GIT SIGNS


" VIM DEV ICONS
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" FIX THE ISSUE WITH SQUARE BRACKETS AROUND THE ICONS IN NERD TREE, FROM: https://github.com/ryanoasis/vim-devicons/issues/215#issuecomment-377786230
if exists("g:loaded_webdevicons")
	call webdevicons#refresh()
endif
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" /VIM DEV ICONS


" DEBUGGERS
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
nnoremap <F8> :lua require("dap").continue()<CR>
nnoremap <F9> :lua require("dap").toggle_breakpoint()<CR>
nnoremap <F10> :lua require("dap").step_over()<CR>
nnoremap <F11> :lua require("dap").step_into()<CR>
nnoremap <S-F11> :lua require("dap").step_out()<CR>
nnoremap <F12> :lua require("dap").repl.open()<CR>
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" /DEBUGGERS

" BUFFERLINE
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
nnoremap <silent> gb :BufferLinePick<CR>
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" /BUFFERLINE
" SWITCH.VIM
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" FROM: https://github.com/AndrewRadev/switch.vim
" keybinding is gs
let g:switch_custom_definitions =
    \ [
    \   switch#NormalizedCase(['private', 'protected', 'internal', 'public']),
    \   switch#NormalizedCase(['true', 'false']),
    \   switch#NormalizedCase(['before', 'after']),
    \   switch#NormalizedCase(['to', 'from']),
    \   switch#NormalizedCase(['==', '!=']),
    \   switch#NormalizedCase(['min', 'max']),
    \   switch#NormalizedCase(['UAT', 'PROD']),
    \ ]
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" /SWITCH.VIM



" VIM WIKI
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
let g:vimwiki_list = [{'path': '~/GBox/Notes/wiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
" :help g:vimwiki_map_prefix
let g:vimwiki_map_prefix = '<leader>v'
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" /VIM WIKI

