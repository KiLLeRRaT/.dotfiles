-- INSTALL PACKER IF ITS NOT INSTALLED
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
	vim.cmd [[packadd packer.nvim]]
end

-- vim.cmd [[packadd packer.nvim]]

local pluginfiles_BufWritePost = vim.api.nvim_create_augroup("pluginfiles_BufWritePost", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = {
		-- "**/nvim/lua/killerrat/**/init.lua",
		-- "**/nvim/lua/killerrat/plugins/*"
		"**/nvim/lua/killerrat/*"
	},
	callback = function()
		vim.cmd [[PackerCompile]]
		print("PackerCompile called!")
	end,
	group = pluginfiles_BufWritePost
})

local packer = require("packer")
local util = require("packer.util")

-- CONFIG IDEA FROM: https://www.reddit.com/r/neovim/comments/txwpj8/comment/i3phc3h/?utm_source=share&utm_medium=web2x&context=3

local function packer_spec()
	local use = use;

-- Packer can manage itself
	use { 'wbthomason/packer.nvim' }

	-- Lazy loading:
	-- Load on specific commands
	-- use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}

	-- Load on a combination of conditions: specific filetypes or commands
	-- Also run code after load (see the "config" key)
	-- use {
	-- 	'w0rp/ale',
	-- 	ft = {'sh', 'zsh', 'bash', 'c', 'cpp', 'cmake', 'html', 'markdown', 'racket', 'vim', 'tex'},
	-- 	cmd = 'ALEEnable',
	-- 	config = 'vim.cmd[[ALEEnable]]'
	-- }


----------------------------------------
	-- LIBRARIES
----------------------------------------
	use { 'nvim-lua/plenary.nvim' }																		-- https://github.com/nvim-lua/plenary.nvim
	use { 'tpope/vim-repeat' }																				-- https://github.com/tpope/vim-repeat

----------------------------------------
	-- THEMES
----------------------------------------
	use { 'folke/tokyonight.nvim', branch = 'main' }									-- https://github.com/folke/tokyonight.nvim
	-- use { 'ellisonleao/gruvbox.nvim' }
----------------------------------------
	-- TOOLS
----------------------------------------
	use { 'johnfrankmorgan/whitespace.nvim'	}

	use { 'nvim-telescope/telescope.nvim' }									-- https://github.com/nvim-telescope/telescope.nvim
	use { 'nvim-telescope/telescope-fzf-native.nvim',
		run = 'make' }																				-- https://github.com/nvim-telescope/telescope-fzf-native.nvim
	use { 'nvim-telescope/telescope-live-grep-args.nvim' }	-- https://github.com/nvim-telescope/telescope-live-grep-args.nvim

	use { 'preservim/nerdtree' }														-- https://github.com/preservim/nerdtree
	-- THIS DOESNT SEEM TO WORK, SIMILAR ERROR AS:
	-- https://github.com/wbthomason/packer.nvim/issues/316 BUT NOT SURE HOW TO SORT IT OUT!
	-- use { 'preservim/nerdtree',
	-- 	opt = true, cmd = { 'NERDTree',  'NERDTreeFocus', 'NERDTreeToggle', 'NERDTreeFind'}
	-- }																			-- https://github.com/preservim/nerdtree

	use { 'ThePrimeagen/harpoon' }													-- https://github.com/ThePrimeagen/harpoon
	use { 'max397574/better-escape.nvim' }									-- https://github.com/max397574/better-escape.nvim
	use { 'phaazon/hop.nvim' }															-- https://github.com/phaazon/hop.nvim
	use { 'dstein64/vim-startuptime' }											-- https://github.com/dstein64/vim-startuptime
	use { 'kylechui/nvim-surround' }												-- https://github.com/kylechui/nvim-surround
	use { 'tpope/vim-fugitive' }														-- https://github.com/tpope/vim-fugitive
	use { 'tpope/vim-abolish' }															-- https://github.com/tpope/vim-abolish
	use { 'tpope/vim-unimpaired' }													-- https://github.com/tpope/vim-unimpaired
	use { 'tpope/vim-obsession' }														-- https://github.com/tpope/vim-obsession
	use { 'simeji/winresizer' }															-- https://github.com/simeji/winresizer
	-- DOES NOT SUPPORT A COUNT YET! ARGH
	-- use { 'b3nj5m1n/kommentary' }												-- https://github.com/b3nj5m1n/kommentary
	use { 'tpope/vim-commentary' }													-- https://github.com/tpope/vim-commentary
	use { 'gbprod/substitute.nvim' }												-- https://github.com/gbprod/substitute.nvim
	use { 'github/copilot.vim' }														-- https://github.com/github/copilot.vim
	-- " SWITCH TO OPPOSITE WORD, E.G. TRUE -> FALSE, etc.
	use { 'AndrewRadev/switch.vim' }												-- https://github.com/AndrewRadev/switch.vim
	use { 'nvim-lualine/lualine.nvim' }											-- https://github.com/nvim-lualine/lualine.nvim
	use { 'akinsho/bufferline.nvim' }												-- https://github.com/akinsho/bufferline.nvim
	use { 'lewis6991/gitsigns.nvim' }												-- https://github.com/lewis6991/gitsigns.nvim
	use { 'vimwiki/vimwiki' }																-- https://github.com/vimwiki/vimwiki

	-- neorg related
	use { 'nvim-neorg/neorg',
		requires = 'nvim-neorg/neorg-telescope'  }						-- https://github.com/nvim-neorg/neorg
	use { 'nvim-neorg/neorg-telescope'}											-- https://github.com/nvim-neorg/neorg-telescope

	use { 'ryanoasis/vim-devicons' }												-- https://github.com/ryanoasis/vim-devicons
	-- Modify files right in the quick fix list
	use { 'stefandtw/quickfix-reflector.vim' }							-- https://github.com/stefandtw/quickfix-reflector.vim
	use { 'mechatroner/rainbow_csv' }												-- https://github.com/mechatroner/rainbow_csv
	use { 'sindrets/diffview.nvim',
		requires = 'nvim-lua/plenary.nvim' }									-- https://github.com/sindrets/diffview.nvim
	use { 'uga-rosa/ccc.nvim' }															-- https://github.com/uga-rosa/ccc.nvim



	-- " Plug 'ThePrimeagen/vim-be-good'
	-- " Plug 'https://github.com/tpope/vim-eunuch' " Vim sugar for the UNIX shell commands
	-- Plug 'https://github.com/ap/vim-css-color'
	-- Plug 'https://github.com/kyazdani42/nvim-web-devicons'
	-- Plug 'https://github.com/neoclide/vim-jsx-improve'
	-- Plug 'PhilRunninger/nerdtree-visual-selection'


----------------------------------------
	-- COMPLETION AND SNIPPETS
----------------------------------------
	use { "hrsh7th/nvim-cmp" }																				-- https://github.com/hrsh7th/nvim-cmp
	use { "hrsh7th/cmp-nvim-lsp" }																		-- https://github.com/hrsh7th/cmp-nvim-lsp
	use { "hrsh7th/cmp-buffer" }																			-- https://github.com/hrsh7th/cmp-buffer
	use { "hrsh7th/cmp-path" }																				-- https://github.com/hrsh7th/cmp-path
	use { "hrsh7th/cmp-nvim-lsp-signature-help" }											-- https://github.com/hrsh7th/cmp-nvim-lsp-signature-help
	use { "hrsh7th/cmp-calc" }																				-- https://github.com/hrsh7th/cmp-calc
	use { "hrsh7th/cmp-emoji" }																				-- https://github.com/hrsh7th/cmp-emoji
	use { 'L3MON4D3/LuaSnip' }																				-- https://github.com/L3MON4D3/LuaSnip
	use { 'saadparwaiz1/cmp_luasnip' }																-- https://github.com/saadparwaiz1/cmp_luasnip

----------------------------------------
	-- LSP RELATED PLUGINS
----------------------------------------
	use { "williamboman/mason.nvim" }
	use { "williamboman/mason-lspconfig.nvim" }
	use { "neovim/nvim-lspconfig" }

	use {
		'nvim-treesitter/nvim-treesitter',
		run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
	}																																	-- https://github.com/nvim-treesitter/nvim-treesitter

	use { "nvim-treesitter/nvim-treesitter-textobjects" }							-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
	use { 'rmagatti/goto-preview' }																		-- https://github.com/rmagatti/goto-preview

	-- STICKY HEADERS/FUNCTIONS AT THE TOP OF THE WINDOW WHEN SCROLLING
	use { 'nvim-treesitter/nvim-treesitter-context' }


	-- " SQL
	-- " Plug 'https://github.com/tpope/vim-dadbod'
	-- " Plug 'https://github.com/kristijanhusak/vim-dadbod-ui'
	-- " Plug 'https://github.com/kristijanhusak/vim-dadbod-completion'

	-- " DEBUGGERS
	-- " Plug 'https://github.com/leoluz/nvim-dap-go'
	-- Plug 'https://github.com/rcarriga/nvim-dap-ui'
	-- Plug 'https://github.com/theHamsta/nvim-dap-virtual-text'
	-- Plug 'https://github.com/nvim-telescope/telescope-dap.nvim'
	-- Plug 'https://github.com/mfussenegger/nvim-dap'

	use { 'lambdalisue/suda.vim' }																		-- https://github.com/lambdalisue/suda.vim

	-- " Open LSP goto defn in floating windows
	-- call plug#end()



	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require('packer').sync()
	end
end

local compile_path = util.join_paths(
	vim.fn.stdpath("config"), "generated", "packer_compiled.vim"
)

packer.startup {
	packer_spec,
	config = {
		compile_path = compile_path,
		preview_updates = true, -- If true, always preview updates before choosing which plugins to update, same as `PackerUpdate --preview`.
	}
}

vim.cmd("source " .. compile_path)

-- TO CHECK IF A PLUGIN IS INSTALLED
function _G.plugin_loaded(plugin_name)
	local p = _G.packer_plugins
	return p ~= nil and p[plugin_name] ~= nil and p[plugin_name].loaded
end

function dump(o)
	 if type(o) == 'table' then
			local s = '{ '
			for k,v in pairs(o) do
				 if type(k) ~= 'number' then k = '"'..k..'"' end
				 s = s .. '['..k..'] = ' .. dump(v) .. ','
			end
			return s .. '} '
	 else
			return tostring(o)
	 end
end
-- print("Plugins:", dump(_G.packer_plugins))

-- vim.api.nvim_buf_set_lines(0, -1, -1, false, {
-- 	"Plugins:",
-- 	dump(_G.packer_plugins)
-- })

-- /TO CHECK IF A PLUGIN IS INSTALLED
