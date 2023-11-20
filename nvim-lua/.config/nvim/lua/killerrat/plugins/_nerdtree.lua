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


		-- If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
-- autocmd BufEnter * if winnr() == winnr('h') && bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
--     \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

-- -- THIS INSERTS SOME TAB CHARS IN OUR ACTIVE BUFFER WHEN WE DISPLAY NERDTREE
-- local nerdtree_no_clobber = vim.api.nvim_create_augroup("nerdtree_no_clobber", { clear = true })
-- vim.api.nvim_create_autocmd("BufEnter", {
-- 	pattern = {"*"},
-- 	callback = function()
-- 		if vim.fn.winnr() == vim.fn.winnr('h') and vim.fn.bufname('#') ~= 'NERD_tree_\\d\\+' and vim.fn.bufname('%') ~= 'NERD_tree_\\d\\+' and vim.fn.winnr('$') > 1 then
-- 			local buf = vim.fn.bufnr()
-- 			vim.cmd("buffer#")
-- 			vim.cmd("normal! <C-W>w")
-- 			vim.cmd("buffer" .. buf)
-- 		end
-- 	end,
-- 		group = nerdtree_no_clobber
-- })


-- call webdevicons#refresh() sorts out the brackets around the icons
vim.keymap.set("n", "<leader>nn", ":NERDTreeFocus<CR>:call webdevicons#refresh()<CR>")
vim.keymap.set("n", "<leader>nt", ":NERDTreeToggle<CR>:call webdevicons#refresh()<CR>")
vim.keymap.set("n", "<leader>nf", ":NERDTreeFind<CR>:call webdevicons#refresh()<CR>")
