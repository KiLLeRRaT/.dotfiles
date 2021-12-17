
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set path+=**
set number
set relativenumber
set hlsearch
set incsearch
set spelllang=en,af
set showcmd

" set columns=80           " window width in columns
" set textwidth=80         " command 'gw' formats text to this width
set ignorecase           " case insensitive search...
set smartcase		" if you do a search with a capital in it, it will
			" perform a case sensitive search

" Tabs and not spaces!
set autoindent
set noexpandtab
set tabstop=4
set shiftwidth=4

" Shady Characters
set listchars=tab:>\ ,nbsp:_,trail:·
set list
set splitright
" Highlight Shady Characters

" :hi GroupA cterm=bold ctermfg=235 ctermbg=167 gui=bold guifg=#282828 guibg=#fb4934
" :match GroupA / \+$/
" :2match GroupA /\t/

" :match GroupA / \+$/
" :syntax match GroupA /\t/

" :hi LineTooLong cterm=bold ctermbg=red guibg=LightYellow
" :match LineTooLong /\%>80v.\+/
:match Error / \+$/
:match Error /\t\+$/
:match Error /^\t*\zs \+/




" Nice menu when typing `:find *.py`
set wildmode=longest,list,full
set wildmenu
" Ignore files
set wildignore+=*_build/*
set wildignore+=**/node_modules/*
set wildignore+=**/.git/*

" Bit of NETRW tweaks to make it more like NERDTree
let g:netrw_banner = 0
let g:netrw_liststyle = 3
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
" WINDOWS
" if empty(glob('~/AppData/Local/nvim-data/site/autoload/plug.vim'))
"     silent !curl -fLo ~/AppData/Local/nvim-data/site/autoload/plug.vim --create-dirs
"         \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
"     autocmd VimEnter * PlugInstall --sync | source ~/AppData/Local/nvim/init.vim
" endif


" LINUX
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
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

call plug#begin('~/.config/nvim/plugged') " LINUX
"call plug#begin('~/.vim/plugged') " WINDOWS
"call plug#begin('~/.config/nvim/plugins') " OSX
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
" Plug 'neovim/nvim-lspconfig'
Plug 'OmniSharp/omnisharp-vim'
Plug 'dense-analysis/ale' " LINTER
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
" Plug 'sheerun/vim-polyglot'
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'altercation/vim-colors-solarized'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-commentary'
Plug 'ThePrimeagen/vim-be-good'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-eunuch'
Plug 'ThePrimeagen/harpoon'
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
if has('patch-8.1.1880')
  set completeopt=longest,menuone,popuphidden
  " Highlight the completion documentation popup background/foreground the same as
  " the completion menu itself, for better readability with highlighted
  " documentation.
  set completepopup=highlight:Pmenu,border:off
else
  set completeopt=longest,menuone,preview
  " Set desired preview window height for viewing documentation.
  set previewheight=5
endif

" Tell ALE to use OmniSharp for linting C# files, and no other linters.
let g:ale_linters = { 'cs': ['OmniSharp'] }
let g:OmniSharp_server_path = 'C:\Users\Albert\AppData\Local\omnisharp-vim\omnisharp-roslyn\OmniSharp.exe'

augroup omnisharp_commands
  autocmd!

  " THIS DOESNT WORK, ARGH! autocmd FileType cs ++once OmniSharpStartServer
  " Show type information automatically when the cursor stops moving.
  " Note that the type is echoed to the Vim command line, and will overwrite
  " any other messages in this space including e.g. ALE linting messages.
  autocmd CursorHold *.cs OmniSharpTypeLookup

  " The following commands are contextual, based on the cursor position.
  autocmd FileType cs nmap <silent> <buffer> gd <Plug>(omnisharp_go_to_definition)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfu <Plug>(omnisharp_find_usages)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfi <Plug>(omnisharp_find_implementations)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ospd <Plug>(omnisharp_preview_definition)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ospi <Plug>(omnisharp_preview_implementations)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ost <Plug>(omnisharp_type_lookup)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osd <Plug>(omnisharp_documentation)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfs <Plug>(omnisharp_find_symbol)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osfx <Plug>(omnisharp_fix_usings)
"  autocmd FileType cs nmap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)
"  autocmd FileType cs imap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)
  autocmd FileType cs nmap <silent> <buffer> <Leader>\ <Plug>(omnisharp_signature_help)
  autocmd FileType cs imap <silent> <buffer> <Leader>\ <Plug>(omnisharp_signature_help)
  
  " Navigate up and down by method/property/field
  autocmd FileType cs nmap <silent> <buffer> [[ <Plug>(omnisharp_navigate_up)
  autocmd FileType cs nmap <silent> <buffer> ]] <Plug>(omnisharp_navigate_down)
  " Find all code errors/warnings for the current solution and populate the quickfix window
  autocmd FileType cs nmap <silent> <buffer> <Leader>osgcc <Plug>(omnisharp_global_code_check)
  " Contextual code actions (uses fzf, vim-clap, CtrlP or unite.vim selector when available)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osca <Plug>(omnisharp_code_actions)
  autocmd FileType cs xmap <silent> <buffer> <Leader>osca <Plug>(omnisharp_code_actions)
  " Repeat the last code action performed (does not use a selector)
  autocmd FileType cs nmap <silent> <buffer> <Leader>os. <Plug>(omnisharp_code_action_repeat)
  autocmd FileType cs xmap <silent> <buffer> <Leader>os. <Plug>(omnisharp_code_action_repeat)

  autocmd FileType cs nmap <silent> <buffer> <Leader>os= <Plug>(omnisharp_code_format)

  autocmd FileType cs nmap <silent> <buffer> <Leader>osnm <Plug>(omnisharp_rename)

  autocmd FileType cs nmap <silent> <buffer> <Leader>osre <Plug>(omnisharp_restart_server)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osst <Plug>(omnisharp_start_server)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ossp <Plug>(omnisharp_stop_server)
" Action name	Default mapping
" sigNext	<C-j>
" sigPrev	<C-k>
" sigParamNext	<C-l>
" sigParamPrev	<C-h>
augroup END

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

syntax on
set background=dark
"let g:solarized_termtrans = 1
"colorscheme solarized
colorscheme gruvbox
let g:gruvbox_guisp_fallback = "bg" " THIS TURNS ON SPELLBAD PROPERLY FOR SPELLCHECK HIGHLIGHTING IN GRUVBOX
"autocmd VimEnter * ++nested colorscheme gruvbox

set termguicolors

" REMAPS / REMAPPINGS / KEYS
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
let mapleader = " "
inoremap jk <Esc>
vnoremap jk <Esc>

nnoremap <Leader>+ :vertical resize +5<CR>
nnoremap <Leader>- :vertical resize -5<CR>

nnoremap Y yg$ " MAKE Y behave the same as C, A, I, D
nnoremap n nzzzv " KEEP CURSOR IN THE CENTRE OF THE SCREEN WHEN SEARCHING NEXT
nnoremap N Nzzzv
nnoremap J mzJ`z " KEEP CURSOR IN A SANE PLACE WHEN USING J TO JOIN LINES

" does not work in VSCODE
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y gg"+yG
" does not work in VSCODE

" DELETE INTO BLACK HOLE REGISTER
nnoremap <leader>d "_d 
vnoremap <leader>d "_d

" https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text
"nnoremap <leader>p "_dP
nnoremap <leader>p "+p

" nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
"nnoremap <C-p>f <cmd>lua require('telescope.builtin').find_files()<cr>
"nnoremap <C-p>g <cmd>lua require('telescope.builtin').live_grep()<cr>
"nnoremap <C-p>b <cmd>lua require('telescope.builtin').buffers()<cr>
"nnoremap <C-p>t <cmd>lua require('telescope.builtin').help_tags()<cr>

" TELESCOPE
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>


" COMMENTARY
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
autocmd FileType cs setlocal commentstring=\/\/\ %s " SET // COMMENTS FOR C# FILES

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
nnoremap <c-n> :cn<cr>
nnoremap <c-p> :cp<cr>

" EASY MOTION
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
nmap s <Plug>(easymotion-overwin-f)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
"nmap s <Plug>(easymotion-overwin-f2)

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>el <Plug>(easymotion-lineforward)
map <Leader>ej <Plug>(easymotion-j)
map <Leader>ek <Plug>(easymotion-k)
map <Leader>eh <Plug>(easymotion-linebackward)
map <Leader>w <Plug>(easymotion-bd-w)
" /EASY MOTION
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

" Remap code completion to Ctrl+Space {{{2
inoremap <C-@> <C-x><C-o> 
" REFRESH FILE FROM DISK
nnoremap <f5> :e %<cr>

" NERDTree
"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
nnoremap <leader>n :NERDTreeFocus<CR>
" nnoremap <C-t> :NERDTree<CR>
" nnoremap <C-t> :NERDTreeToggle<CR>
" nnoremap <C-f> :NERDTreeFind<CR>

"~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" /NERDTree

" Airline
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
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
nnoremap <silent><leader>l :lua require("harpoon.ui").nav_file(4)<CR>
" nnoremap <silent><leader>tu :lua require("harpoon.term").gotoTerminal(1)<CR>
" nnoremap <silent><leader>te :lua require("harpoon.term").gotoTerminal(2)<CR>
" nnoremap <silent><leader>cu :lua require("harpoon.term").sendCommand(1, 1)<CR>
" nnoremap <silent><leader>ce :lua require("harpoon.term").sendCommand(1, 2)<CR>
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~




