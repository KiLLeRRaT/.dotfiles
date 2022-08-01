-- If plugin is not loaded (e.g. disabled), skip this file!
-- print ("Plugin: " .. _G.packer_plugins)
if not _G.plugin_loaded("nerdtree") then
	do return end
end

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
vim.g.NERDTreeShowLineNumbers = 1

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
vim.keymap.set("n", "<leader>nn", ":NERDTreeFocus<CR>")
-- nnoremap <leader>nt :NERDTreeToggle<CR>
vim.keymap.set("n", "<leader>nt", ":NERDTreeToggle<CR>")
-- nnoremap <leader>nf :NERDTreeFind<CR>
vim.keymap.set("n", "<leader>nf", ":NERDTreeFind<CR>")

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

