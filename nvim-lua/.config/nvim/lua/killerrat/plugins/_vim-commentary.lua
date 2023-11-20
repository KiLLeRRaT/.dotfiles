-- autocmd FileType cs setlocal commentstring=\/\/\ %s
-- autocmd FileType sql setlocal commentstring=--\ %s
local commentary = vim.api.nvim_create_augroup("commentary", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = "sql",
	callback = function()
		vim.schedule(function()
			vim.opt_local.commentstring = "-- %s"
		end)
	end,
	group = commentary
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "cs",
	callback = function()
		vim.schedule(function()
			vim.opt_local.commentstring = "// %s"
		end)
	end,
	group = commentary
})

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
