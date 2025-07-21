local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local pluginCondForHost = function(plugin)
	local hostname = vim.loop.os_gethostname()
	local hostnamePlugins = require("killerrat.plugins.hosts")
	local hp = hostnamePlugins[hostname]

	if (hp == nil) then return true end
	local enabled = hp[plugin.name]
	-- print ("hostname: " .. hostname)
	-- print ("pluginCondForHost:Plugin: " .. plugin.name .. ": " .. tostring(enabled));

	if (enabled == nil) then return true end
	return enabled
end


local lazyPlugins = {
	----------------------------------------
		-- LIBRARIES
	----------------------------------------
	{ 'nvim-lua/plenary.nvim' },																	-- https://github.com/nvim-lua/plenary.nvim
	{ 'tpope/vim-repeat' },																			-- https://github.com/tpope/vim-repeat

	----------------------------------------
		-- THEMES
	----------------------------------------
	{ 'folke/tokyonight.nvim', branch = 'main' },								-- https://github.com/folke/tokyonight.nvim
	---- { 'ellisonleao/gruvbox.nvim' }
	----------------------------------------
		-- TOOLS
	----------------------------------------
	{
		"sphamba/smear-cursor.nvim",
		opts = {},
	},
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {}
	}, 																									-- https://github.com/ibhagwan/fzf-lua
	{ 'johnfrankmorgan/whitespace.nvim'	},
	{ 'nvim-telescope/telescope.nvim' },								-- https://github.com/nvim-telescope/telescope.nvim,
	{ 'nvim-telescope/telescope-fzf-native.nvim',
		build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }, -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
	{ 'nvim-telescope/telescope-live-grep-args.nvim' },-- https://github.com/nvim-telescope/telescope-live-grep-args.nvim
	{ 'preservim/nerdtree',
		dependencies = { 'ryanoasis/vim-devicons' },
		cmd = {"NERDTreeFocus", "NERDTreeToggle", "NERDTreeFind" }
	},	-- https://github.com/preservim/nerdtree
	{ 'stevearc/oil.nvim',
		opts = {},
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"cbochs/grapple.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},																											-- https://github.com/cbochs/grapple.nvim
	{ 'max397574/better-escape.nvim' },								-- https://github.com/max397574/better-escape.nvim
	-- { 'phaazon/hop.nvim' },														-- https://github.com/phaazon/hop.nvim
	{ 'smoka7/hop.nvim' },														-- https://github.com/smoka7/hop.nvim
	--{ 'ggandor/leap.nvim' },														-- https://github.com/ggandor/leap.nvim

	{
		"folke/flash.nvim",
		event = "VeryLazy",
		keys = {
			{ "<leader>s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
			{ "<leader>S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
			{ "<leader>r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
			{ "<leader>R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			{ "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
		},
	},

	-- gx without having netrw
	{
		"chrishrb/gx.nvim",
		event = { "BufEnter" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true, -- default Settings
	}, -- https://github.com/chrishrb/gx.nvim


	--{ 'dstein64/vim-startuptime' },										-- https://github.com/dstein64/vim-startuptime
	{ 'kylechui/nvim-surround' },											-- https://github.com/kylechui/nvim-surround
	{ 'tpope/vim-fugitive' },													-- https://github.com/tpope/vim-fugitive
	{ 'tpope/vim-abolish' },														-- https://github.com/tpope/vim-abolish
	{ 'tpope/vim-unimpaired' },												-- https://github.com/tpope/vim-unimpaired
	{ 'Shatur/neovim-session-manager',
		dependencies = { "nvim-lua/plenary.nvim" }
	},																									-- https://github.com/Shatur/neovim-session-manager
	{ 'simeji/winresizer' },														-- https://github.com/simeji/winresizer


	---- DOES NOT SUPPORT A COUNT YET! ARGH
	---- { 'b3nj5m1n/kommentary' },											-- https://github.com/b3nj5m1n/kommentary
	-- { 'tpope/vim-commentary' },												-- https://github.com/tpope/vim-commentary

	-- { 'echasnovski/mini.comment', version = false },			-- https://github.com/echasnovski/mini.comment
	{ 'JoosepAlviste/nvim-ts-context-commentstring' },			-- https://github.com/JoosepAlviste/nvim-ts-context-commentstring

	{ 'gbprod/substitute.nvim' },											-- https://github.com/gbprod/substitute.nvim
	-- { 'github/copilot.vim' },													-- https://github.com/github/copilot.vim
	{ "zbirenbaum/copilot.lua",
	  cmd = "Copilot",
		event = "InsertEnter",
		cond = pluginCondForHost,
	},													-- https://github.com/zbirenbaum/copilot.lua
	-- {
	-- 	{
	-- 		"CopilotC-Nvim/CopilotChat.nvim",
	-- 		dependencies = {
	-- 			{ "zbirenbaum/copilot.lua" }, -- or zbirenbaum/copilot.lua
	-- 			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
	-- 		},
	-- 		-- build = "make tiktoken", -- Only on MacOS or Linux
	-- 		-- opts = {
	-- 		-- 	-- See Configuration section for options
	-- 		-- },
	-- 		-- See Commands section for default commands if you want to lazy load on them
	-- 	},
	-- },																									-- https://github.com/CopilotC-Nvim/CopilotChat.nvim
	{
		"yetone/avante.nvim",
		event = "VeryLazy",
		lazy = false,
		version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
		build = "make",
		cond = pluginCondForHost,
		dependencies = {
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			-- "echasnovski/mini.pick", -- for file_selector provider mini.pick
			"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
			"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
			"ibhagwan/fzf-lua", -- for file_selector provider fzf
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			-- {
			-- 	-- Make sure to set this up properly if you have lazy=true
			-- 	'MeanderingProgrammer/render-markdown.nvim',
			-- 	opts = {
			-- 		file_types = { "markdown", "Avante" },
			-- 	},
			-- 	ft = { "markdown", "Avante" },
			-- },
		},
	},


























	-- " SWITCH TO OPPOSITE WORD, E.G. TRUE -> FALSE, etc.
	{ 'AndrewRadev/switch.vim' },											-- https://github.com/AndrewRadev/switch.vim
	{ 'nvim-lualine/lualine.nvim' },										-- https://github.com/nvim-lualine/lualine.nvim
	-- { 'akinsho/bufferline.nvim' },											-- https://github.com/akinsho/bufferline.nvim
	{ 'lewis6991/gitsigns.nvim' },											-- https://github.com/lewis6991/gitsigns.nvim
	-- neorg related
	{
		"vhyrro/luarocks.nvim",
		cond = pluginCondForHost,
		priority = 1000, -- We'd like this plugin to load first out of the rest
		config = true, -- This automatically runs `require("luarocks-nvim").setup()`
	},
	-- { 'nvim-neorg/neorg',
	-- 	cond = pluginCondForHost,
	-- 	dependencies = { "luarocks.nvim" },
	-- 	-- dependencies = {'nvim-neorg/neorg-telescope', 'nvim-lua/plenary.nvim'},
	-- 	-- build = ":Neorg sync-parsers",
	-- 	ft = "norg",
	-- 	version = "*"
	-- },												-- https://github.com/nvim-neorg/neorg
	{ 'nvim-neorg/neorg',
		cond = pluginCondForHost,
		ft = "norg",
		version = "*",
	},												-- https://github.com/nvim-neorg/neorg
	{ 'nvim-neorg/neorg-telescope',
		dependencies = {'nvim-telescope/telescope.nvim'},
		ft = "norg"
	},										-- https://github.com/nvim-neorg/neorg-telescope
	{ 'ryanoasis/vim-devicons', priority = 100 },											-- https://github.com/ryanoasis/vim-devicons
	{ "nvim-tree/nvim-web-devicons" },
	-- Modify files right in the quick fix list
	{ 'stefandtw/quickfix-reflector.vim' },						-- https://github.com/stefandtw/quickfix-reflector.vim
	{ 'mechatroner/rainbow_csv' },											-- https://github.com/mechatroner/rainbow_csv
	{ 'sindrets/diffview.nvim',
		dependencies = 'nvim-lua/plenary.nvim' },								-- https://github.com/sindrets/diffview.nvim
	{ 'uga-rosa/ccc.nvim' },														-- https://github.com/uga-rosa/ccc.nvim
	{ 'lambdalisue/suda.vim' },												-- https://github.com/lambdalisue/suda.vim
	{ 'terrastruct/d2-vim', ft = "d2" },	-- https://github.com/terrastruct/d2-vim
	{ 'mbbill/undotree' },															-- https://github.com/mbbill/undotree
	-- BELOW COLORIZER HAS DEPRECATED VIM API STUFF BUT THEY ARE NOT UPDATING, CHANGED TO A FORK
	-- INSTEAD
	-- { 'norcalli/nvim-colorizer.lua' },														-- https://github.com/norcalli/nvim-colorizer.lua
	{ 'catgoose/nvim-colorizer.lua' },														-- https://github.com/norcalli/nvim-colorizer.lua
	{ "folke/zen-mode.nvim", cmd = "ZenMode" },
	{ "tris203/hawtkeys.nvim",
		dependencies = "nvim-lua/plenary.nvim", config = { } }, -- https://github.com/tris203/hawtkeys.nvim
	{
		"michaelrommel/nvim-silicon",
		cond = pluginCondForHost,
		lazy = true,
		cmd = "Silicon",
		-- config = function()
			-- require("silicon").setup({
			-- 	-- Configuration here, or leave empty to use defaults
			-- 	font = "VictorMono NF=34;Noto Emoji=34"
			-- })
		-- end
	},



	------------------------------------------
	--	-- COMPLETION AND SNIPPETS
	------------------------------------------
	{ "hrsh7th/nvim-cmp" },																			-- https://github.com/hrsh7th/nvim-cmp
	{ "hrsh7th/cmp-nvim-lsp" },																	-- https://github.com/hrsh7th/cmp-nvim-lsp
	{ "hrsh7th/cmp-buffer" },																		-- https://github.com/hrsh7th/cmp-buffer
	{ "hrsh7th/cmp-path" },																			-- https://github.com/hrsh7th/cmp-path
	{ "hrsh7th/cmp-nvim-lsp-signature-help" },										-- https://github.com/hrsh7th/cmp-nvim-lsp-signature-help
	{ "hrsh7th/cmp-calc" },																			-- https://github.com/hrsh7th/cmp-calc
	{ "hrsh7th/cmp-emoji" },																			-- https://github.com/hrsh7th/cmp-emoji
	{ 'L3MON4D3/LuaSnip' },																			-- https://github.com/L3MON4D3/LuaSnip
	{ 'saadparwaiz1/cmp_luasnip' },															-- https://github.com/saadparwaiz1/cmp_luasnip
	{ 'Issafalcon/lsp-overloads.nvim'},													-- https://github.com/Issafalcon/lsp-overloads.nvim
	-- { 'uga-rosa/cmp-dictionary' },																-- https://github.com/uga-rosa/cmp-dictionary

	----------------------------------------
		-- LSP RELATED PLUGINS
	----------------------------------------
	{ "williamboman/mason.nvim" },
	{ "williamboman/mason-lspconfig.nvim" },
	{ "neovim/nvim-lspconfig" },
	{
		'nvim-treesitter/nvim-treesitter',
		build = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
	},																																-- https://github.com/nvim-treesitter/nvim-treesitter

	{ "nvim-treesitter/nvim-treesitter-textobjects" },						-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
	{ 'rmagatti/goto-preview' },																	-- https://github.com/rmagatti/goto-preview

	-- STICKY HEADERS/FUNCTIONS AT THE TOP OF THE WINDOW WHEN SCROLLING
	{ 'nvim-treesitter/nvim-treesitter-context' },
	{ 'nvim-treesitter/playground',
		cmd = "TSPlaygroundToggle"
	},
	-- goto definition on decompiled sources
	-- { 'Hoffs/omnisharp-extended-lsp.nvim' },
	{
		"seblyng/roslyn.nvim",
		ft = { "cs", "razor", "vb" },
		dependencies = {
			{
				-- By loading as a dependencies, we ensure that we are available to set
				-- the handlers for roslyn
				'tris203/rzls.nvim',
				config = function()
					---@diagnostic disable-next-line: missing-fields
					require('rzls').setup {}
				end,
			},
		}
	},

	----------------------------------------
	-- DEBUGGERS
	----------------------------------------
	{ 'michaelb/sniprun', build = 'sh ./install.sh'},
	{ 'rcarriga/nvim-dap-ui', cond = pluginCondForHost,
		dependencies = {'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' } },
	{ 'theHamsta/nvim-dap-virtual-text', cond = pluginCondForHost,
		dependencies = {'mfussenegger/nvim-dap'} },
	{ 'nvim-telescope/telescope-dap.nvim', cond = pluginCondForHost,
		dependencies = {'mfussenegger/nvim-dap'} },
	{ 'mfussenegger/nvim-dap', cond = pluginCondForHost },
	{ 'nvim-neotest/nvim-nio', cond = pluginCondForHost },

	----------------------------------------
	-- SQL
	----------------------------------------
	{ "kndndrj/nvim-dbee",
		cond = pluginCondForHost,
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		build = function()
			require("dbee").install()
		end,
		config = function() require("dbee").setup() end,
	}, -- https://github.com/kndndrj/nvim-dbee

	{ "kristijanhusak/vim-dadbod-ui",
		cond = pluginCondForHost,
		dependencies = {
			{ 'tpope/vim-dadbod', lazy = true },
			{ 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
		}
	}, -- https://github.com/kristijanhusak/vim-dadbod-ui?tab=readme-ov-file
}

require("lazy").setup(lazyPlugins, {
	performance = {
		rtp = {
			disabled_plugins = {
				-- "netrwPlugin"
			}
		}
	}
})



local M = {}

-- FROM: https://www.reddit.com/r/neovim/comments/128lwld/comment/jejaoxq/
M.LazyHasPlugin = function(name)
	-- print("Checking for plugin: " .. name)
	local isInstalled = require("lazy.core.config").plugins[name] ~= nil
	-- if (isInstalled) then
	-- 	print(name .. " is installed!")
	-- else
	-- 	print(name .. " is not installed!")
	-- end
	return isInstalled
end

return M



