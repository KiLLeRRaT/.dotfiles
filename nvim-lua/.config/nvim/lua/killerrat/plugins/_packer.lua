-- INSTALL PACKER IF ITS NOT INSTALLED
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
	vim.cmd [[packadd packer.nvim]]
end


-- vim.cmd [[packadd packer.nvim]]
vim.cmd [[autocmd BufWritePost **/nvim/lua/killerrat/plugins/init.lua PackerCompile]]

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
	use { 'nvim-lua/plenary.nvim' }																	-- https://github.com/nvim-lua/plenary.nvim

----------------------------------------
	-- THEMES
----------------------------------------
	use { 'folke/tokyonight.nvim', branch = 'main' }									-- https://github.com/folke/tokyonight.nvim

----------------------------------------
	-- TOOLS
----------------------------------------
	use { 'johnfrankmorgan/whitespace.nvim'	}

	use { 'nvim-telescope/telescope.nvim' }														-- https://github.com/nvim-telescope/telescope.nvim
	use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }	-- https://github.com/nvim-telescope/telescope-fzf-native.nvim
	use { 'nvim-telescope/telescope-live-grep-args.nvim' }						-- https://github.com/nvim-telescope/telescope-live-grep-args.nvim

	use { 'preservim/nerdtree' }																			-- https://github.com/preservim/nerdtree
	use { 'ThePrimeagen/harpoon' }																		-- https://github.com/ThePrimeagen/harpoon

	-- Plug 'https://github.com/jdhao/better-escape.vim'
	use { 'max397574/better-escape.nvim' }

-- use {
--   "max397574/better-escape.nvim",
--   config = function()
--     require("better_escape").setup()
--   end,
-- }


	-- " Plug 'ThePrimeagen/vim-be-good'
	-- Plug 'https://github.com/tpope/vim-abolish'
	-- Plug 'https://github.com/tpope/vim-commentary'
	-- Plug 'https://github.com/tpope/vim-eunuch'
	-- Plug 'https://github.com/tpope/vim-fugitive'
	-- Plug 'https://github.com/tpope/vim-repeat'
	-- Plug 'https://github.com/tpope/vim-surround'
	-- Plug 'https://github.com/tpope/vim-unimpaired'
	-- " Plug 'vim-airline/vim-airline'
	-- Plug 'https://github.com/nvim-lualine/lualine.nvim'
	-- Plug 'https://github.com/akinsho/bufferline.nvim'
	-- Plug 'https://github.com/phaazon/hop.nvim'

	-- Plug 'https://github.com/github/copilot.vim'
	-- Plug 'https://github.com/dstein64/vim-startuptime'
	-- Plug 'https://github.com/ap/vim-css-color'
	-- " Plug 'ryanoasis/vim-devicons'
	-- Plug 'https://github.com/kyazdani42/nvim-web-devicons'
	-- Plug 'https://github.com/lewis6991/gitsigns.nvim'
	-- " Plug 'nvim-telescope/telescope-hop.nvim'
	-- " Plug 'nvim-telescope/telescope-rg.nvim'
	-- " Plug 'nvim-telescope/telescope-ui-select.nvim'
	-- Plug 'https://github.com/neoclide/vim-jsx-improve'
	-- Plug 'https://github.com/simeji/winresizer'
	-- Plug 'PhilRunninger/nerdtree-visual-selection'
	-- Plug 'https://github.com/nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	-- Plug 'https://github.com/nvim-treesitter/nvim-treesitter-textobjects'
	-- Plug 'https://github.com/vimwiki/vimwiki'

	-- " LSP RELATED PLUGINS
	-- Plug 'https://github.com/neovim/nvim-lspconfig'
	-- Plug 'https://github.com/hrsh7th/nvim-cmp' " autocompletion framework
	-- Plug 'https://github.com/hrsh7th/cmp-nvim-lsp' " LSP autocompletion provider
	-- Plug 'https://github.com/hrsh7th/cmp-buffer'
	-- Plug 'https://github.com/hrsh7th/cmp-path'
	-- Plug 'https://github.com/hrsh7th/cmp-nvim-lsp-signature-help'
	-- Plug 'https://github.com/hrsh7th/cmp-calc'
	-- Plug 'https://github.com/hrsh7th/cmp-emoji'
	-- " Plug 'https://github.com/uga-rosa/cmp-dictionary'
	-- " Plug 'https://github.com/f3fora/cmp-spell'
	-- Plug 'https://github.com/williamboman/nvim-lsp-installer'
	-- " https://github.com/hrsh7th?tab=repositories

	-- " /LSP RELATED PLUGINS

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

	-- " Modify files right in the quick fix list
	-- Plug 'https://github.com/stefandtw/quickfix-reflector.vim'

	-- " SWITCH TO OPPOSITE WORD, E.G. TRUE -> FALSE, etc.
	-- Plug 'https://github.com/AndrewRadev/switch.vim'
	-- Plug 'https://github.com/lambdalisue/suda.vim'

	-- " Open LSP goto defn in floating windows
	-- Plug 'https://github.com/rmagatti/goto-preview'
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
		compile_path = compile_path
	}
}

vim.cmd("source " .. compile_path)

-- TO CHECK IF A PLUGIN IS INSTALLED
function _G.plugin_loaded(plugin_name)
	local p = _G.packer_plugins
	return p ~= nil and p[plugin_name] ~= nil and p[plugin_name].loaded
end

-- function dump(o)
-- 	 if type(o) == 'table' then
-- 			local s = '{ '
-- 			for k,v in pairs(o) do
-- 				 if type(k) ~= 'number' then k = '"'..k..'"' end
-- 				 s = s .. '['..k..'] = ' .. dump(v) .. ','
-- 			end
-- 			return s .. '} '
-- 	 else
-- 			return tostring(o)
-- 	 end
-- end
-- print("Plugins:", dump(_G.packer_plugins))
