" CONTENTS
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" REMAPS / REMAPPINGS / KEYS
" FUGITIVE
" PLUGINS
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set path+=**
set number
set relativenumber
set hlsearch
set cursorline
set incsearch
set spelllang=en,af
set showcmd
set autoread " READ FILE IF OUTSIDE CHANGES ARE DETECTED
" set columns=80           " window width in columns
" set textwidth=80         " command 'gw' formats text to this width
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
set listchars=tab:>\ ,nbsp:_,trail:·
" set listchars=tab:🠞\ ,nbsp:_,trail:·
set list
set mouse=a
" NEOVIM CLIENT SERVER STUFF, SEE "C:\GBox\Applications\Tools\Scripts\Aliases\nvim.bat"
" silent execute "!echo " . v:servername . " > C:\\Users\\Albert\\AppData\\Local\\nvim-data\\servername.txt"

" Highlight Shady Characters
" match Error / \+$/ " TRAILING SPACE
" match Error /\t\+$/ " TRAILING TAB
" match Error /^\t*\zs \+/ " SPACES INSTEAD OF TABS

" MAKE SURE TO KEEP YOUR COLOR SCHEME AFTER LOADING ANOTHER SCHEME LATER DOWN
" THE CONFIG
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
" call matchadd('ExtraWhitespace', '/\s\+\%#\@<!$/', 100)
" call matchadd('ExtraWhitespace', '/^\t*\zs \+/', 100) " SHOW SPACES AT THE
" START OF LINES



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








" highlight ExtraWhitespace ctermbg=red guibg=red
" augroup WhitespaceMatch
"   " Remove ALL autocommands for the WhitespaceMatch group.
"   autocmd!
"   autocmd BufWinEnter * let w:whitespace_match_number = matchadd('ExtraWhitespace', '/^\t*\zs \+/')
"   autocmd BufWinEnter * let w:whitespace_match_number2 = matchadd('ExtraWhitespace', '/^\t*\zs \+/')
"   autocmd InsertEnter * call s:ToggleWhitespaceMatch('i')
"   autocmd InsertLeave * call s:ToggleWhitespaceMatch('n')
" augroup END
" function! s:ToggleWhitespaceMatch(mode)
"   let pattern = (a:mode == 'i') ? '/^\t*\zs \+/' : '/^\t*\zs \+/'
"   let pattern2 = (a:mode == 'i') ? '/^\t*\zs \+/' : '/^\t*\zs \+/'
"   if exists('w:whitespace_match_number')
"     call matchdelete(w:whitespace_match_number)
"     call matchdelete(w:whitespace_match_number2)
"     call matchadd('ExtraWhitespace', pattern, 10, w:whitespace_match_number)
"     call matchadd('ExtraWhitespace', pattern2, 10, w:whitespace_match_number2)
"   else
"     " Something went wrong, try to be graceful.
"     let w:whitespace_match_number =  matchadd('ExtraWhitespace', pattern)
"     let w:whitespace_match_number2 =  matchadd('ExtraWhitespace', pattern2)
"   endif
" endfunction


" SHOW LONG LINES
highlight ColorColumn cterm=reverse ctermfg=142 ctermbg=235 gui=reverse guifg=#b8bb26 guibg=#282828
call matchadd('ColorColumn', '\%81v', 100)

" https://superuser.com/a/356865/69729
" autocmd Filetype * :match Error /^\t*\zs \+/
" autocmd Filetype * if &ft!="yaml"|:match Error /^\t*\zs \+/|endif
" autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab | match none

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


" PLUGINS
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" INSTALL VIM PLUGGED
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if (has('win32'))
	" WINDOWS
	if empty(glob('~/AppData/Local/nvim-data/site/autoload/plug.vim'))
			silent !curl -fLo ~/AppData/Local/nvim-data/site/autoload/plug.vim --create-dirs
					\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
			autocmd VimEnter * PlugInstall --sync | source ~/AppData/Local/nvim/init.vim
	endif
elseif (has('mac') || has('unix'))
	" LINUX
	let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
	if empty(glob(data_dir . '/autoload/plug.vim'))
		silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
		autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
	endif
endif

"" auto-install vim-plug
"const plug_path = stdpath('data') . '/site/autoload/plug.vim'
"if empty(glob(plug_path))
"  "silent exe '!curl -fLo ' . plug_path . ' --create-dirs
"  exe '!curl -fLo ' . plug_path . ' --create-dirs
"        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
"  "autocmd VimEnter * PlugInstall
"endif

" OSX SPECIFIC
"let plug_install = 0
"let autoload_plug_path = stdpath('config') . '/autoload/plug.vim'
"if !filereadable(autoload_plug_path)
"    silent exe '!curl -fL --create-dirs -o ' . autoload_plug_path .
"       \ ' https://raw.github.com/junegunn/vim-plug/master/plug.vim'
"    execute 'source ' . fnameescape(autoload_plug_path)
"    let plug_install = 1
"endif
"unlet autoload_plug_path

call plug#begin('~/.dotfiles/nvim/.config/nvim/plugged') " LINUX
" call plug#begin('~/.config/nvim/plugged') " LINUX
"call plug#begin('~/.vim/plugged') " WINDOWS
"call plug#begin('~/.config/nvim/plugins') " OSX
" Plug 'neovim/nvim-lspconfig'
" Plug 'sheerun/vim-polyglot'
" Plug 'altercation/vim-colors-solarized'
Plug 'dense-analysis/ale' " LINTER
" Plug 'easymotion/vim-easymotion'
Plug 'morhetz/gruvbox'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'OmniSharp/omnisharp-vim'
Plug 'preservim/nerdtree'
Plug 'ThePrimeagen/harpoon'
Plug 'ThePrimeagen/vim-be-good'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-airline/vim-airline'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'phaazon/hop.nvim'
" Plug 'neovim/nvim-lspconfig'
" Plug 'nvim-lua/completion-nvim'
" Plug 'nvim-lua/diagnostic-nvim'
" Plug 'Leandros/telescope-fzf-native.nvim', {'branch': 'feature/windows_build_support'}
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
" Plug 'github/copilot.vim', { 'branch': 'suggestion-cycling-pr' } " MY OWN TEMP BRANCH
Plug 'github/copilot.vim'
Plug 'dstein64/vim-startuptime'
Plug 'ap/vim-css-color'
Plug 'ryanoasis/vim-devicons'
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-telescope/telescope-hop.nvim'
Plug 'nvim-telescope/telescope-rg.nvim'
call plug#end()

"if plug_install
"    PlugInstall --sync
"endif
"unlet plug_install
"
" OMNISHARP
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Don't autoselect first omnicomplete option, show options even if there is only
" one (so the preview documentation is accessible). Remove 'preview', 'popup'
" and 'popuphidden' if you don't want to see any documentation whatsoever.
" Note that neovim does not support `popuphidden` or `popup` yet:
" https://github.com/neovim/neovim/issues/10996

" COMMENTED OUT ON 28 Jan 2022
" if has('patch-8.1.1880')
"   set completeopt=longest,menuone,popuphidden
"   " Highlight the completion documentation popup background/foreground the same as
"   " the completion menu itself, for better readability with highlighted
"   " documentation.
"   set completepopup=highlight:Pmenu,border:off
" else
"   set completeopt=longest,menuone,preview
"   " Set desired preview window height for viewing documentation.
"   set previewheight=5
"endif
" /COMMENTED OUT ON 28 Jan 2022

" Tell ALE to use OmniSharp for linting C# files, and no other linters.
let g:ale_linters = { 'cs': ['OmniSharp'] }
" let g:OmniSharp_server_path = 'C:\Users\Albert\AppData\Local\omnisharp-vim\omnisharp-roslyn\OmniSharp.exe' " WINDOWS
" WE DONT WANT TO DEFINE THIS IN LINUX AND WINDOWS ANYMORE

" REMOVED TEMP TO TEST SOMETHING IF IT WILL INSTALL omnisharp-roslyn
" AUTOMATICALLY
" let g:OmniSharp_server_path = 'C:\Users\Albert\AppData\Local\omnisharp-vim\omnisharp-roslyn\OmniSharp.exe'

" augroup omnisharp_commands
"   autocmd!

"   " THIS DOESNT WORK, ARGH! autocmd FileType cs ++once OmniSharpStartServer
"   " Show type information automatically when the cursor stops moving.
"   " Note that the type is echoed to the Vim command line, and will overwrite
"   " any other messages in this space including e.g. ALE linting messages.
"   autocmd CursorHold *.cs OmniSharpTypeLookup

"   " The following commands are contextual, based on the cursor position.
"   autocmd FileType cs nmap <silent> <buffer> gd <Plug>(omnisharp_go_to_definition)
"   autocmd FileType cs nmap <silent> <buffer> <Leader>osfu <Plug>(omnisharp_find_usages)
"   autocmd FileType cs nmap <silent> <buffer> <Leader>osfi <Plug>(omnisharp_find_implementations)
"   autocmd FileType cs nmap <silent> <buffer> <Leader>ospd <Plug>(omnisharp_preview_definition)
"   autocmd FileType cs nmap <silent> <buffer> <Leader>ospi <Plug>(omnisharp_preview_implementations)
"   autocmd FileType cs nmap <silent> <buffer> <Leader>ost <Plug>(omnisharp_type_lookup)
"   autocmd FileType cs nmap <silent> <buffer> <Leader>osd <Plug>(omnisharp_documentation)
"   autocmd FileType cs nmap <silent> <buffer> <Leader>osfs <Plug>(omnisharp_find_symbol)
"   autocmd FileType cs nmap <silent> <buffer> <Leader>osfx <Plug>(omnisharp_fix_usings)
" "  autocmd FileType cs nmap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)
" "  autocmd FileType cs imap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)
"   autocmd FileType cs nmap <silent> <buffer> <Leader>\ <Plug>(omnisharp_signature_help)
"   autocmd FileType cs imap <silent> <buffer> <Leader>\ <Plug>(omnisharp_signature_help)

"   " Navigate up and down by method/property/field
"   autocmd FileType cs nmap <silent> <buffer> [[ <Plug>(omnisharp_navigate_up)
"   autocmd FileType cs nmap <silent> <buffer> ]] <Plug>(omnisharp_navigate_down)
"   " Find all code errors/warnings for the current solution and populate the quickfix window
"   autocmd FileType cs nmap <silent> <buffer> <Leader>osgcc <Plug>(omnisharp_global_code_check)
"   " Contextual code actions (uses fzf, vim-clap, CtrlP or unite.vim selector when available)
"   autocmd FileType cs nmap <silent> <buffer> <Leader>osca <Plug>(omnisharp_code_actions)
"   autocmd FileType cs xmap <silent> <buffer> <Leader>osca <Plug>(omnisharp_code_actions)
"   " Repeat the last code action performed (does not use a selector)
"   autocmd FileType cs nmap <silent> <buffer> <Leader>os. <Plug>(omnisharp_code_action_repeat)
"   autocmd FileType cs xmap <silent> <buffer> <Leader>os. <Plug>(omnisharp_code_action_repeat)

"   autocmd FileType cs nmap <silent> <buffer> <Leader>os= <Plug>(omnisharp_code_format)

"   autocmd FileType cs nmap <silent> <buffer> <Leader>osnm <Plug>(omnisharp_rename)

"   autocmd FileType cs nmap <silent> <buffer> <Leader>osre <Plug>(omnisharp_restart_server)
"   autocmd FileType cs nmap <silent> <buffer> <Leader>osst <Plug>(omnisharp_start_server)
"   autocmd FileType cs nmap <silent> <buffer> <Leader>ossp <Plug>(omnisharp_stop_server)
" " Action name	Default mapping
" " sigNext	<C-j>
" " sigPrev	<C-k>
" " sigParamNext	<C-l>
" " sigParamPrev	<C-h>
" augroup END

" Enable snippet completion, using the ultisnips plugin
" let g:OmniSharp_want_snippet=1




" OLD STUFF BELOW.....
" local pid = vim.fn.getpid()
" local omnisharp_bin = "C:\GBox\Applications\Tools\Applications\Neovim\omnisharp-win-x64\1.37.17\OmniSharp.exe"
" require'lspconfig'.omnisharp.setup {
" 	cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) };
" 	filetypes = { "cs", "vb" }
" 	init_options = {}
" 	on_new_config = function(new_config, new_root_dir)
" 	if new_root_dir then
" 		table.insert(new_config.cmd, '-s')
" 		table.insert(new_config.cmd, new_root_dir)
" 	end
" end,
" root_dir = root_pattern(".sln") or root_pattern(".csproj")
"    }

" /OMNISHARP
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" FROM: https://codito.in/c-and-vim/
" Folding : http://vim.wikia.com/wiki/Syntax-based_folding, see comment by Ostrygen
" au FileType cs set omnifunc=syntaxcomplete#Complete
" au FileType cs set foldmethod=marker
" au FileType cs set foldmarker={,}
" au FileType cs set foldtext=substitute(getline(v:foldstart),'{.*','{...}',)
" au FileType cs set foldlevelstart=0`
" au FileType cs set foldlevel=0
" au FileType cs set foldclose=none


autocmd BufNewFile,BufRead *.cshtml set syntax=html " SYNTAX HIGHLIGHTING FOR CSHTML/RAZOR

syntax on
set background=dark
"let g:solarized_termtrans = 1
"colorscheme solarized
colorscheme gruvbox
let g:gruvbox_guisp_fallback = "bg" " THIS TURNS ON SPELLBAD PROPERLY FOR SPELLCHECK HIGHLIGHTING IN GRUVBOX
let g:gruvbox_transparent_bg = 1
autocmd VimEnter * hi Normal ctermbg=none
"autocmd VimEnter * ++nested colorscheme gruvbox

set termguicolors
hi! Normal ctermbg=NONE guibg=NONE
" hi! NonText ctermbg=NONE guibg=NONE
" REMAPS / REMAPPINGS / KEYS
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
let mapleader = " "
inoremap jk <Esc>
vnoremap jk <Esc>

" SWITCH TO PREV BUFFER AND CLOSE THE ONE YOU SWITCHED AWAY FROM, CLOSES A
" BUFFER WITHOUT MESSING UP THE SPLIT
nnoremap <leader>bd :bp\|bd #<cr>
nnoremap <leader>ba :bufdo bd<cr>

" INSTEAD USE
" <c-w>+ and <c-w>- AND
" <c-w>> and <c-w>< AND
" <c-w>_ and <c-w>|
" nnoremap <leader>v> :vertical resize +5<CR>
" nnoremap <leader>v< :vertical resize -5<CR>
" nnoremap <leader>h> :resize +5<CR>
" nnoremap <leader>h< :resize -5<CR>

" nnoremap <leader>+ :vertical resize +5<CR>
" nnoremap <leader>- :vertical resize -5<CR>

" MAKE Y behave the same as C, A, I, D
nnoremap Y yg$
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
nnoremap <expr> <leader>t '<esc>' . v:count1 . 'yy:.,+' . v:count1 . 'Commentary<cr>' . v:count1 . 'jO<esc>p'

" https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text
xnoremap <leader>p "_dP

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
nnoremap <leader>ci) ci)"
nnoremap <leader>ci{ ci{"
nnoremap <leader>ci} ci}"
nnoremap <leader>ci[ ci["
nnoremap <leader>ci] ci]"
nnoremap <leader>ci< ci<"
nnoremap <leader>ci> ci>"
nnoremap <leader>ci` ci`"

" COPY CURRENT FILENAME OR FULL FILE PATH TO SYSTEM CLIPBOARD
nnoremap <leader>cf :let @+ = expand("%:t")<cr>
nnoremap <leader>cF :let @+ = expand("%:p")<cr>

" REPLACE VISUAL SELECTION
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" REFRESH FILE FROM DISK
nnoremap <f5> :e %<cr>
" REFRESH FILE FROM DISK AND GO TO BOTTOM
nnoremap <S-f5> :e %<cr>G
" RELOAD CONFIG
nnoremap <C-f5> :so ~/AppData/Local/nvim/init.vim<cr>
" EDIT CONFIG
nnoremap <A-f5> :e ~/AppData/Local/nvim/init.vim<cr>

" EDIT NOTES FOLDER
nnoremap <A-n> :e C:\GBox\Notes<cr>

" BUILD SOLUTION
" nnoremap <C-S-B> :!dotnet build *.sln

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
nnoremap gn yiw:exec (@" =~ '^\d\+$' ? 'norm @"G' : '')<cr>
" DO A SEARCH USING THE LINE YOU'RE ON, FROM: https://vi.stackexchange.com/a/6210/38923
nnoremap <leader>* 0y$/\V<c-r>"<cr>

" SPELL CHECKING ]s and [s for next/prev, z= for spelling suggestion, zg to
" add to dictionary
map <F6> :setlocal spell!<CR>


" TELESCOPE
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>ff <cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files<cr>
nnoremap <expr> <leader>fF ':Telescope find_files<cr>' . "'" . expand('<cword>')
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <expr> <leader>fG ':Telescope live_grep<cr>' . expand('<cword>')
nnoremap <leader>fR <cmd>lua require("telescope").extensions.live_grep_raw.live_grep_raw()<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fk <cmd>Telescope help_tags<cr>
nnoremap <leader>fm <cmd>Telescope keymaps<cr>
nnoremap <leader>fc <cmd>Telescope git_commits<cr>
nnoremap <leader>fr <cmd>Telescope git_branches<cr>

" SEARCH MY OWN GBOX SCRIPTS
lua require("killerrat")
nnoremap <leader>sf :lua require('killerrat.telescope').search_scripts()<CR>
nnoremap <leader>sg :lua require('killerrat.telescope').grep_scripts()<CR>

lua require('telescope').load_extension('fzf')
" lua require('telescope').load_extension('hop')

" COMMENTARY
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" SET // COMMENTS FOR C# FILES
autocmd FileType cs setlocal commentstring=\/\/\ %s

" SET -- COMMENTS FOR C# FILES
autocmd FileType sql setlocal commentstring=--\ %s

autocmd FileType typescriptreact nnoremap <leader>gcc I{/*<esc>A*/}<esc><cr>
autocmd FileType typescriptreact nnoremap <leader>gcu ^3dl<esc>$F*D<cr>


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
nnoremap <leader>lq :lopen<cr>
nnoremap <leader>lj :lnext<cr>
nnoremap <leader>lk :lprev<cr>

" EASY MOTION DISABLED IN FAVOR OF HOP
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"let g:EasyMotion_do_mapping = 0 " Disable default mappings

"" Jump to anywhere you want with minimal keystrokes, with just one key binding.
"" `s{char}{label}`
"" nmap s <Plug>(easymotion-overwin-f)
"" or
"" `s{char}{char}{label}`
"" Need one more keystroke, but on average, it may be more comfortable.
""nmap s <Plug>(easymotion-overwin-f2)

"" Turn on case-insensitive feature
"let g:EasyMotion_smartcase = 1

"" JK motions: Line motions
"map <Leader>el <Plug>(easymotion-lineforward)
"map <Leader>ej <Plug>(easymotion-j)
"map <Leader>ek <Plug>(easymotion-k)
"map <Leader>eh <Plug>(easymotion-linebackward)
"map <Leader>w <Plug>(easymotion-bd-w)
" /EASY MOTION
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" HOP, REPLACES EASY MOTION
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
lua require'hop'.setup { keys = 'asdfghjkl;qwertyuiopzxcvbnm', jump_on_sole_occurrence = false }
map <Leader>w :HopWord<cr>
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" /HOP

" Remap code completion to Ctrl+Space {{{2
" inoremap <C-@> <C-x><C-o>

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
" make sure relative line numbers are used
autocmd FileType nerdtree setlocal relativenumber

" nnoremap <leader>nf :NERDTreeFocus<CR>
" nnoremap <leader>n :NERDTree<CR>
nnoremap <leader>nt :NERDTreeToggle<CR>
" nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>nf :NERDTreeFind<CR>

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" /NERDTree

" Airline
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#formatter = 'short_path' " default | jsformatter | unique_tail | unique_tail_improved | short_path | tabnr, from: https://github.com/vim-airline/vim-airline#default, to create custom ones: https://stackoverflow.com/a/53754280/182888
let g:airline_powerline_fonts = 1
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" /Airline

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
nnoremap <silent><leader>ll :lua require("harpoon.ui").nav_file(4)<CR>
nnoremap <silent><leader>; :lua require("harpoon.ui").nav_file(5)<CR>
" nnoremap <silent><leader>tu :lua require("harpoon.term").gotoTerminal(1)<CR>
" nnoremap <silent><leader>te :lua require("harpoon.term").gotoTerminal(2)<CR>
" nnoremap <silent><leader>cu :lua require("harpoon.term").sendCommand(1, 1)<CR>
" nnoremap <silent><leader>ce :lua require("harpoon.term").sendCommand(1, 2)<CR>
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" FUGITIVE
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
nnoremap <leader>gs :Git<cr>
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

" COC, FROM: https://github.com/neoclide/coc.nvim
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" TextEdit might fail if hidden is not set.
" set hidden

" Some servers have issues with backup files, see #649.
" set nobackup
" set nowritebackup

" Give more space for displaying messages.
" set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
" set updatetime=300

" Don't pass messages to |ins-completion-menu|.
" set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
" if has("nvim-0.5.0") || has("patch-8.1.1564")
"   " Recently vim can merge signcolumn and number column into one
"   set signcolumn=number
" else
"   set signcolumn=yes
" endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
" nmap <silent> [g <Plug>(coc-diagnostic-prev)
" nmap <silent> ]g <Plug>(coc-diagnostic-next)

" IF THIS GETS OUT OF HAND SEE: https://vi.stackexchange.com/a/10666/38923
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" autocmd FileType cs nmap <silent> gd <Plug>(coc-definition)
" autocmd FileType cs nmap <silent> gy <Plug>(coc-type-definition)
" autocmd FileType cs nmap <silent> gi <Plug>(coc-implementation)
" autocmd FileType cs nmap <silent> gr <Plug>(coc-references)

" autocmd FileType cs nmap gd <Plug>(coc-definition)
" autocmd FileType cs nmap gy <Plug>(coc-type-definition)
" autocmd FileType cs nmap gi <Plug>(coc-implementation)
" autocmd FileType cs nmap gr <Plug>(coc-references)

" THE BELOW DOESNT QUITE WORK
" autocmd FileType cs nmap gs <Plug>(coc-showSignatureHelp)
" autocmd FileType cs nmap gs CocActionAsync('showSignatureHelp')<CR>

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
" xmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
" nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
" xmap if <Plug>(coc-funcobj-i)
" omap if <Plug>(coc-funcobj-i)
" xmap af <Plug>(coc-funcobj-a)
" omap af <Plug>(coc-funcobj-a)
" xmap ic <Plug>(coc-classobj-i)
" omap ic <Plug>(coc-classobj-i)
" xmap ac <Plug>(coc-classobj-a)
" omap ac <Plug>(coc-classobj-a)

" " Remap <C-f> and <C-b> for scroll float windows/popups.
" if has('nvim-0.4.0') || has('patch-8.2.0750')
"   nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"   nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
"   inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
"   inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
"   vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
"   vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
" endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
" nmap <silent> <C-s> <Plug>(coc-range-select)
" xmap <silent> <C-s> <Plug>(coc-range-select)

" " Add `:Format` command to format current buffer.
" command! -nargs=0 Format :call CocAction('format')

" " Add `:Fold` command to fold current buffer.
" command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" " Add `:OR` command for organize imports of the current buffer.
" command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
" nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" " Manage extensions.
" nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" " Show commands.
" nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" " Find symbol of current document.
" nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" " Search workspace symbols.
" nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" " Do default action for next item.
" nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" " Do default action for previous item.
" nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" " Resume latest coc list.
" nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" MY OWN COC SETTINGS AND SETUP
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" let g:coc_global_extensions = ['coc-json', 'coc-git']
let g:coc_global_extensions = [
	\'coc-emoji',
	\'coc-calc',
	\'coc-yaml',
	\'coc-yank',
	\'coc-omnisharp',
	\'coc-tsserver'
\]
" https://github.com/weirongxu/coc-calc
" https://github.com/neoclide/coc-eslint
" https://github.com/neoclide/coc-html
" https://github.com/coc-extensions/coc-omnisharp
" https://github.com/neoclide/coc-prettier
" https://github.com/fannheyward/coc-sql
" https://github.com/neoclide/coc-tsserver
" https://github.com/neoclide/coc-yaml
" https://github.com/neoclide/coc-yank

nnoremap <silent> <space>cy  :<C-u>CocList -A --normal yank<cr>

" " append result on current expression
" nmap <Leader>ca <Plug>(coc-calc-result-append)
" " replace result on current expression
" nmap <Leader>cr <Plug>(coc-calc-result-replace)
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" /COC
" LSP
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" FROM: https://rishabhrd.github.io/jekyll/update/2020/09/19/nvim_lsp_config.html

" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" /LSP

" GITHUB COPILOT
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" imap <silent><nowait><expr> <c-j> copilot#NextResult(1)
" imap <silent><nowait><expr> <c-k> copilot#NextResult(-1)
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
nnoremap <leader>dr :Gitsigns reset_hunk<cr>
    " map('n', '<leader>hS', gs.stage_buffer)
    " map('n', '<leader>hu', gs.undo_stage_hunk)
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
