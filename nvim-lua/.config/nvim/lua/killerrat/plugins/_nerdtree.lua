-- WE ARE NOT CHECKING HERE, BECAUSE WE WANT TO RUN THIS ALWAYS, SINCE WE LAZYLOAD NERDTree!
-- if not _G.plugin_loaded("nerdtree") then
-- 	do return end
-- end

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

vim.g.NERDTreeShowLineNumbers = 1
vim.g.NERDTreeShowHidden = 1

-- " FROM: https://stackoverflow.com/a/47287079/182888
vim.g.NERDTreeChDirMode = 2

if vim.fn.has('win32') == 1 then
	vim.g.NERDTreeCopyCmd = 'Copy-Item -Recurse '
end

-- " make sure relative line numbers are used
-- autocmd FileType nerdtree setlocal relativenumber
local nerdtree_relativenumber = vim.api.nvim_create_augroup("nerdtree_relativenumber", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = {"nerdtree"},
	callback = function()
		vim.opt_local.relativenumber = true
	end,
	group = nerdtree_relativenumber
})

vim.keymap.set("n", "<leader>nn", ":NERDTreeFocus<CR>")
vim.keymap.set("n", "<leader>nt", ":NERDTreeToggle<CR>")
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

