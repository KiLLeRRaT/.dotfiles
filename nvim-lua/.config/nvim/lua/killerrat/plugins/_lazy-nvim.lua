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
	{ 'https://github.com/nvim-lua/plenary.nvim' },
	{ 'https://github.com/tpope/vim-repeat' },

	----------------------------------------
		-- THEMES
	----------------------------------------
	{ 'https://github.com/folke/tokyonight.nvim', branch = 'main' },
	---- { 'ellisonleao/gruvbox.nvim' }

	----------------------------------------
		-- TOOLS
	----------------------------------------
	-- {
	-- 	"https://github.com/sphamba/smear-cursor.nvim",
	-- },
	{
		"https://github.com/ibhagwan/fzf-lua",
		dependencies = { "https://github.com/nvim-tree/nvim-web-devicons" },
	},
	{ 'https://github.com/johnfrankmorgan/whitespace.nvim'	},
	{ 'https://github.com/nvim-telescope/telescope.nvim' },
	{ 'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
		build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' },
	{ 'https://github.com/nvim-telescope/telescope-live-grep-args.nvim' },
	{ 'https://github.com/preservim/nerdtree',
		dependencies = { 'ryanoasis/vim-devicons' },
		cmd = {"NERDTreeFocus", "NERDTreeToggle", "NERDTreeFind" }
	},
	{ 'https://github.com/stevearc/oil.nvim',
		-- Optional dependencies
		dependencies = { "https://github.com/nvim-tree/nvim-web-devicons" },
	},
	{
		"https://github.com/cbochs/grapple.nvim",
		dependencies = { "https://github.com/nvim-lua/plenary.nvim" },
	},
	{ 'https://github.com/max397574/better-escape.nvim' },
	-- { 'phaazon/hop.nvim' },
	{ 'https://github.com/smoka7/hop.nvim' },
	--{ 'ggandor/leap.nvim' },

	-- {
	-- 	"https://github.com/folke/flash.nvim",
	-- 	event = "VeryLazy",
	-- 	keys = {
	-- 		{ "<leader>s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
	-- 		{ "<leader>S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
	-- 		{ "<leader>r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
	-- 		{ "<leader>R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
	-- 		{ "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
	-- 	},
	-- },

	-- gx without having netrw
	{
		"https://github.com/chrishrb/gx.nvim",
		event = { "BufEnter" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true, -- default Settings
	},


	--{ 'dstein64/vim-startuptime' },
	{ 'https://github.com/kylechui/nvim-surround' },
	{ 'https://github.com/tpope/vim-fugitive' },
	{ 'https://github.com/tpope/vim-abolish' },
	{ 'https://github.com/tpope/vim-unimpaired' },
	{ 'https://github.com/Shatur/neovim-session-manager',
		dependencies = { "nvim-lua/plenary.nvim" }
	},
	{ 'https://github.com/simeji/winresizer' },


	-- { 'echasnovski/mini.comment', version = false },
	{ 'https://github.com/JoosepAlviste/nvim-ts-context-commentstring' },

	{ 'https://github.com/gbprod/substitute.nvim' },
	-- { 'github/copilot.vim' },
	{ "https://github.com/zbirenbaum/copilot.lua",
	  cmd = "Copilot",
		event = "InsertEnter",
		cond = pluginCondForHost,
	},
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
	-- },
	{
		"https://github.com/yetone/avante.nvim",
		event = "VeryLazy",
		lazy = false,
		version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
		build = "make",
		cond = pluginCondForHost,
		dependencies = {
			"https://github.com/stevearc/dressing.nvim",
			"https://github.com/nvim-lua/plenary.nvim",
			"https://github.com/MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			-- "echasnovski/mini.pick", -- for file_selector provider mini.pick
			"https://github.com/nvim-telescope/telescope.nvim", -- for file_selector provider telescope
			"https://github.com/hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
			"https://github.com/ibhagwan/fzf-lua", -- for file_selector provider fzf
			"https://github.com/nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"https://github.com/zbirenbaum/copilot.lua", -- for providers='copilot'
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
	{ 'https://github.com/AndrewRadev/switch.vim' },
	{ 'https://github.com/nvim-lualine/lualine.nvim' },
	-- { 'akinsho/bufferline.nvim' },
	{ 'https://github.com/lewis6991/gitsigns.nvim' },
	-- neorg related
	{
		"https://github.com/vhyrro/luarocks.nvim",
		cond = pluginCondForHost,
		priority = 1000, -- We'd like this plugin to load first out of the rest
		config = function()
			-- luarocks 3.13+ changed require("luarocks.vendor.dkjson") to
			-- require("dkjson") but the vendor path isn't in package.path
			local rocks_dir = vim.fn.stdpath("data") .. "/lazy/luarocks.nvim/.rocks"
			local vendor_path = rocks_dir .. "/share/lua/5.1/luarocks/vendor/?.lua"
			if not package.path:find("luarocks/vendor", 1, true) then
				package.path = package.path .. ";" .. vendor_path
			end
			require("luarocks-nvim").setup()
		end,
	},
	-- { 'nvim-neorg/neorg',
	-- 	cond = pluginCondForHost,
	-- 	dependencies = { "luarocks.nvim" },
	-- 	-- dependencies = {'nvim-neorg/neorg-telescope', 'nvim-lua/plenary.nvim'},
	-- 	-- build = ":Neorg sync-parsers",
	-- 	ft = "norg",
	-- 	version = "*"
	-- },
	{ 'https://github.com/nvim-neorg/neorg',
		cond = pluginCondForHost,
		ft = "norg",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"vhyrro/luarocks.nvim",
		}
	},
	{ 'https://github.com/nvim-neorg/neorg-telescope',
		dependencies = {'https://github.com/nvim-telescope/telescope.nvim'},
		ft = "norg"
	},
	{ 'https://github.com/ryanoasis/vim-devicons', priority = 100 },
	{ "https://github.com/nvim-tree/nvim-web-devicons" },
	-- Modify files right in the quick fix list
	{ 'https://github.com/stefandtw/quickfix-reflector.vim' },
	{ 'https://github.com/mechatroner/rainbow_csv' },
	{ 'https://github.com/sindrets/diffview.nvim',
		dependencies = 'nvim-lua/plenary.nvim' },
	{ 'https://github.com/AndrewRadev/linediff.vim' }, -- Compare two parts of files by using visual highlights and the :Linediff command
	-- { 'https://github.com/uga-rosa/ccc.nvim' },	-- Replaced by nvim-colorizer.lua for now
	{ 'https://github.com/lambdalisue/suda.vim' },
	{ 'https://github.com/terrastruct/d2-vim', ft = "d2" },
	{ 'https://github.com/mbbill/undotree' },
	-- BELOW COLORIZER HAS DEPRECATED VIM API STUFF BUT THEY ARE NOT UPDATING, CHANGED TO A FORK
	-- INSTEAD
	-- { 'norcalli/nvim-colorizer.lua' },
	{ 'https://github.com/catgoose/nvim-colorizer.lua' },
	{ "https://github.com/folke/zen-mode.nvim", cmd = "ZenMode" },
	{ "https://github.com/tris203/hawtkeys.nvim",
		dependencies = "nvim-lua/plenary.nvim", config = { } },
	{
		"https://github.com/michaelrommel/nvim-silicon",
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
	{ "https://github.com/hrsh7th/nvim-cmp" },
	{ "https://github.com/hrsh7th/cmp-nvim-lsp" },
	{ "https://github.com/hrsh7th/cmp-buffer" },
	{ "https://github.com/hrsh7th/cmp-path" },
	{ "https://github.com/hrsh7th/cmp-nvim-lsp-signature-help" },
	{ "https://github.com/hrsh7th/cmp-calc" },
	{ "https://github.com/hrsh7th/cmp-emoji" },
	{ 'https://github.com/L3MON4D3/LuaSnip' },
	{ 'https://github.com/saadparwaiz1/cmp_luasnip' },
	{ 'https://github.com/Issafalcon/lsp-overloads.nvim'},
	-- { 'uga-rosa/cmp-dictionary' },

	----------------------------------------
		-- LSP RELATED PLUGINS
	----------------------------------------
	{ "https://github.com/williamboman/mason.nvim" },
	{ "https://github.com/williamboman/mason-lspconfig.nvim" },
	{ "https://github.com/neovim/nvim-lspconfig" },
	{
		'https://github.com/nvim-treesitter/nvim-treesitter',
		branch = 'master', -- main has lots of breaking changes, need to upgrade later in the future, see:
		-- https://www.reddit.com/r/neovim/comments/1pndf9e/my_new_nvimtreesitter_configuration_for_the_main/
		-- https://github.com/nvim-treesitter/nvim-treesitter/tree/main?tab=readme-ov-file#quickstart
		build = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
	},

	{ "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
	{ 'https://github.com/rmagatti/goto-preview' },

	-- STICKY HEADERS/FUNCTIONS AT THE TOP OF THE WINDOW WHEN SCROLLING
	{ 'https://github.com/nvim-treesitter/nvim-treesitter-context' },
	{ 'https://github.com/nvim-treesitter/playground',
		cmd = "TSPlaygroundToggle"
	},
	-- goto definition on decompiled sources
	-- { 'Hoffs/omnisharp-extended-lsp.nvim' },

	-- {
	-- 	"https://github.com/seblyng/roslyn.nvim",
	-- 	ft = { "cs", "razor", "vb" },
	-- 	dependencies = {
	-- 		{
	-- 			-- By loading as a dependencies, we ensure that we are available to set
	-- 			-- the handlers for roslyn
	-- 			'https://github.com/tris203/rzls.nvim',
	-- 			config = function()
	-- 				---@diagnostic disable-next-line: missing-fields
	-- 				require('rzls').setup {}
	-- 			end,
	-- 		},
	-- 	}
	-- },
	{
		"seblyng/roslyn.nvim",
		---@module 'roslyn.config'
		---@type RoslynNvimConfig
		opts = { },
	},

	{
		'stevearc/conform.nvim',
		opts = {},
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
	},

	----------------------------------------
	-- DEBUGGERS
	----------------------------------------
	{ 'https://github.com/michaelb/sniprun', build = 'sh ./install.sh'},
	{ 'https://github.com/rcarriga/nvim-dap-ui', cond = pluginCondForHost,
		dependencies = {'https://github.com/mfussenegger/nvim-dap', 'https://github.com/nvim-neotest/nvim-nio' } },
	{ 'https://github.com/theHamsta/nvim-dap-virtual-text', cond = pluginCondForHost,
		dependencies = {'https://github.com/mfussenegger/nvim-dap'} },
	{ 'https://github.com/nvim-telescope/telescope-dap.nvim', cond = pluginCondForHost,
		dependencies = {'https://github.com/mfussenegger/nvim-dap'} },
	{ 'https://github.com/mfussenegger/nvim-dap', cond = pluginCondForHost },
	{ 'https://github.com/nvim-neotest/nvim-nio', cond = pluginCondForHost },

	----------------------------------------
	-- SQL
	----------------------------------------
	{ "https://github.com/kndndrj/nvim-dbee",
		cond = pluginCondForHost,
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		build = function()
			require("dbee").install()
		end,
		config = function() require("dbee").setup() end,
	},

	{ "https://github.com/kristijanhusak/vim-dadbod-ui",
		cond = pluginCondForHost,
		dependencies = {
			{ 'https://github.com/tpope/vim-dadbod', lazy = true },
			{ 'https://github.com/kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
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



