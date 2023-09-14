-- set path+=**

vim.opt.number = true
vim.opt.relativenumber = true

-- SET THE LINE NUMBERS TO ABSOLUTE NUMBERS WHEN ENDTERING COMMAND MODE
local set_cmdline = vim.api.nvim_create_augroup("set_cmdline", { clear = true })
vim.api.nvim_create_autocmd("CmdlineEnter", {
	pattern = {"*"},
	callback = function()
		-- print("cmdline enter")
		vim.opt.relativenumber = false
		vim.cmd('redraw')
	end,
	group = set_cmdline
})
vim.api.nvim_create_autocmd("CmdlineLeave", {
	pattern = {"*"},
	callback = function()
		-- print("cmdline leave")
		vim.opt.relativenumber = true
		vim.cmd('redraw')
	end,
	group = set_cmdline
})

vim.opt.hlsearch = true
vim.opt.cursorline = true
vim.opt.incsearch = true
vim.opt.spelllang = "en,af"
-- vim.opt.spelllang = "/usr/share/dict/words"

vim.opt.showcmd = true

-- set autoread " READ FILE IF OUTSIDE CHANGES ARE DETECTED

vim.opt.textwidth = 100 -- command 'gw' formats text to this width
vim.opt.colorcolumn = "100"
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- vim.opt.autoindent = true
-- vim.opt.smartindent = true
-- vim.opt.expandtab = false
-- vim.opt.tabstop = 2
-- vim.opt.shiftwidth = 2
-- -- vim.cmd[[filetype plugin on]]
-- -- vim.cmd[[filetype indent off]]

vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.listchars = "tab:| ,nbsp:_,trail:·,space:·"
vim.opt.list = true
vim.opt.wrap = false
vim.opt.mouse = "a"
vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.undofile = true
vim.opt.breakindent = true

-- always show this many lines from the edge of the window top and bottom
vim.opt.scrolloff = 5

-- IF after so many ms no changes made, write the swapfile to disk
vim.opt.updatetime = 100

-- " SET SHELL TO POWERSHELL
-- print("has win32: ", vim.fn.has('win32'))
-- print("has wsl: ", vim.fn.has('wsl'))
-- print("has unix: ", vim.fn.has('unix'))
if vim.fn.has('win32') == 1 then
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

-- " SYNTAX HIGHLIGHTING FOR CSHTML/RAZOR
-- autocmd BufNewFile,BufRead *.cshtml set syntax=html
local syntax_cshtml = vim.api.nvim_create_augroup("syntax_cshtml", { clear = true })
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
	-- pattern = "*.cshtml",
	pattern = {"*.cshtml", "*.aspx"},
	callback = function()
		vim.schedule(function()
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
vim.g.maplocalleader = "\\"


-- GENERATE HOST SPECIFIC CONFIG WHEN SAVING i3 OR i3status CONFIG FILES
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = {
		-- "**/i3*/.config/i3(status)?/config"
		"**/i3*/.config/i3*/config.allHosts",
		"**/.config/alacritty/alacritty.allHosts.yml"
		-- "**/config"
	},
	callback = function()
		vim.cmd [[!~/.config/nvim/generateHostConfig.sh]]
		print("generateHostConfig.sh called!")
	end,
	group = vim.api.nvim_create_augroup("set_i3config_BufWritePost", { clear = true })
})

