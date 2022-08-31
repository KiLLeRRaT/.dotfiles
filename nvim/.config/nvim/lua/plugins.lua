-- autocomplete config
local lsp_symbols = {
		Text = "   (Text) ",
		Method = "   (Method)",
		Function = "   (Function)",
		Constructor = "   (Constructor)",
		Field = " ﴲ  (Field)",
		Variable = "[] (Variable)",
		Class = "   (Class)",
		Interface = " ﰮ  (Interface)",
		Module = "   (Module)",
		Property = " 襁 (Property)",
		Unit = "   (Unit)",
		Value = "   (Value)",
		Enum = " 練 (Enum)",
		Keyword = "   (Keyword)",
		Snippet = "   (Snippet)",
		Color = "   (Color)",
		File = "   (File)",
		Reference = "   (Reference)",
		Folder = "   (Folder)",
		EnumMember = "   (EnumMember)",
		Constant = " ﲀ  (Constant)",
		Struct = " ﳤ  (Struct)",
		Event = "   (Event)",
		Operator = "   (Operator)",
		TypeParameter = "   (TypeParameter)",
}

local cmp = require 'cmp'
cmp.setup {
  mapping = {
    ['<Esc>'] = cmp.mapping.abort(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    })
  },
  sources = {
    { name = 'nvim_lsp' },
		{ name = 'path' },
		{ name = "buffer" },
		{ name = 'nvim_lsp_signature_help' },
		{ name = 'vim-dadbod-completion' },
		{ name = 'calc' },
		{ name = 'emoji' },
		-- { name = 'spell' },
		-- { name = 'dictionary', keyword_length = 2 },
  },
	formatting = {
		format = function(entry, item)
			item.kind = lsp_symbols[item.kind]
			item.menu = ({
				buffer = "[B]",
				nvim_lsp = "[L]",
				path = "[P]",
				sql = "[DB]",
				-- luasnip = "[Snippet]",
				-- neorg = "[Neorg]",
			})[entry.source.name]

			return item
		end,
	},
}

-- SETUP AND RUN LSP INSTALLER
local lsp_installer_ensure_installed = { "bashls", "cssls", "dockerls", "eslint", "html", "jsonls", "pyright", "sumneko_lua", "tflint", "tsserver", "yamlls" }

-- PATH SETUP BASED ON OS
local omniSharpPath
local netcoredbgPath
if vim.fn.has('win32') == 1 then
	-- netcoredbgPath = 'C:/GBox/Applications/Tools/Applications/Neovim/netcoredbg/netcoredbg-win64-2.0.0-895/netcoredbg.exe'
	netcoredbgPath = 'C:/GBox/Applications/Tools/Applications/Neovim/netcoredbg/netcoredbg-win64-2.0.0-895/netcoredbg.exe'
	-- omniSharpPath = '~/GBox/Applications/Tools/Applications/Neovim/omnisharp/omnisharp-win-x64-1.39.0/OmniSharp.exe' -- THIS USED TO WORK, AND JUST SUDDENLY STOPPED WORKING, GRRR
	table.insert(lsp_installer_ensure_installed, "omnisharp")
	-- omniSharpPath = 'C:/GBox/Applications/Tools/Applications/Neovim/omnisharp/omnisharp-win-x64-1.39.1/OmniSharp.exe'
	-- omniSharpPath = 'C:/GBox/Applications/Tools/Applications/Neovim/omnisharp/omnisharp-win-x64-1.39.0/OmniSharp.exe'
	-- omniSharpPath = 'C:/GBox/Applications/Tools/Applications/Neovim/omnisharp/omnisharp-win-x64-net6.0-1.39.1/OmniSharp.exe'
	table.insert(lsp_installer_ensure_installed, "powershell_es")
elseif vim.fn.has('mac') == 1 then
	netcoredbgPath = '/Users/albert/GBox/Applications/Tools/Applications/Neovim/netcoredbg/netcoredbg-osx-amd64-2.0.0-915/netcoredbg'
	table.insert(lsp_installer_ensure_installed, "omnisharp")
elseif vim.fn.has('linux') == 1 then
	netcoredbgPath = 'C:/GBox/Applications/Tools/Applications/Neovim/nvim-win64/lsp-instance/netcoredbf-win64-2.0.0-895/netcoredbg.exe'
	table.insert(lsp_installer_ensure_installed, "omnisharp")
end

-- -- print( "Features: " .. vim.fn.has('win32') .. vim.fn.has('mac') .. vim.fn.has('linux'))
-- -- /PATH SETUP BASED ON OS

require("nvim-lsp-installer").setup {
    ensure_installed = lsp_installer_ensure_installed
}

-- OMNISHARP LSP CONFIG
-- local pid = vim.fn.getpid()
-- require'lspconfig'.omnisharp.setup {
--   capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
--   on_attach = function(_, bufnr)
--     vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
--   end,
-- 	-- on_new_config = function(new_config, new_root_dir)
-- 	-- 	if new_root_dir then
-- 	-- 		table.insert(new_config.cmd, '-s')
-- 	-- 		table.insert(new_config.cmd, new_root_dir)
-- 	-- 		-- table.insert(new_config.cmd, new_root_dir .. '/Sandfield.TIL.Orca.sln')
-- 	-- 		-- table.insert(new_config.cmd, new_root_dir .. '/Sandfield.POR.Portal.sln')
-- 	-- 	end
-- 	-- end,
-- 	-- cmd = { omniSharpPath, '--languageserver', '--hostPID', tostring(pid), '--loglevel', 'debug' },
-- 	-- cmd = { 'C:/GBox/Applications/Tools/Applications/Neovim/omnisharp/omnisharp-win-x64-1.38.2/OmniSharp.exe', '--languageserver', '--hostPID', tostring(pid), '--loglevel', 'debug' },
-- 	-- cmd = { 'C:/GBox/Applications/Tools/Applications/Neovim/omnisharp/omnisharp-win-x64-1.39.0/OmniSharp.exe', '--languageserver', '--hostPID', tostring(pid), '--loglevel', 'debug' },
-- 		-- cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) };

-- 	cmd = { omniSharpPath, '--languageserver', '--hostPID', tostring(pid), '--loglevel', 'debug' },

-- }
-- require'lspconfig'.omnisharp.setup {}
require'lspconfig'.omnisharp.setup {
	-- use_mono = true
	-- environment = "netframework"
	environment = "dotnet"
}
-- /OMNISHARP LSP CONFIG

-- LUA LINES, https://github.com/nvim-lualine/lualine.nvim#default-configuration
require'lualine'.setup {
	options = {
		-- theme = 'gruvbox'
		theme = 'palenight'
	}
}

require'bufferline'.setup {
	options = {
		diagnostics = "nvim_lsp",
		show_close_icon = false,
		show_buffer_close_icons = false,
		-- numbers = "buffer_id",
		-- number_style = "",
		numbers = function(opts)
			-- SEE: :h bufferline-numbers
			return string.format('%s:', opts.id)
		end,
		separator_style = "thick",
		middle_mouse_command = "b %d | bp | sp | bn | bd"
	}
}

-- ESLINT
--- npm i -g vscode-langservers-extracted
-- require'lspconfig'.eslint.setup {}
-- npm i -g eslint
local eslint_config = require("lspconfig.server_configurations.eslint")
require'lspconfig'.eslint.setup {
    -- opts.cmd = { "yarn", "exec", unpack(eslint_config.default_config.cmd) }
}

--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require'lspconfig'.html.setup {
  capabilities = capabilities,
}

require'lspconfig'.cssls.setup {
	capabilities = capabilities,
}

require'lspconfig'.jsonls.setup {
	capabilities = capabilities,
}

-- POWERSHELL
-- TODO:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#powershell_es
if vim.fn.has('win32') == 1 then
	require'lspconfig'.powershell_es.setup{}
end

-- TSSERVER
-- npm install -g typescript typescript-language-server
require'lspconfig'.tsserver.setup{}

-- YAMLLS
-- npm install -g yaml-language-server
-- ADD MODELINE TO FILES:
-- # yaml-language-server: $schema=<urlToTheSchema|relativeFilePath|absoluteFilePath}>
require'lspconfig'.yamlls.setup{}


-- PYTHON
require'lspconfig'.pyright.setup{}

-- LUA
require'lspconfig'.sumneko_lua.setup{}

-- TERRAFORM
require'lspconfig'.tflint.setup{}

-- BASH
require'lspconfig'.bashls.setup{}

-- DOCKER
require'lspconfig'.dockerls.setup{}

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- DEBUGGERS
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local dap = require('dap')
dap.adapters.coreclr = {
  type = 'executable',
  command = netcoredbgPath,
  args = {'--interpreter=vscode'}
}

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
        -- return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
        return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '', 'file')
    end,
  },
}

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- /DEBUGGERS
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- RANGE FORMATTING WITH A MOTION
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- FROM: https://github.com/neovim/nvim-lspconfig/wiki/User-contributed-tips#range-formatting-with-a-motion

-- function format_range_operator()
--   local old_func = vim.go.operatorfunc
--   _G.op_func_formatting = function()
--     local start = vim.api.nvim_buf_get_mark(0, '[')
--     local finish = vim.api.nvim_buf_get_mark(0, ']')
--     vim.lsp.buf.range_formatting({}, start, finish)
--     vim.go.operatorfunc = old_func
--     _G.op_func_formatting = nil
--   end
--   vim.go.operatorfunc = 'v:lua.op_func_formatting'
--   vim.api.nvim_feedkeys('g@', 'n', false)
-- end
-- vim.api.nvim_set_keymap("n", "gm", "<cmd>lua format_range_operator()<CR>", {noremap = true})
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- /RANGE FORMATTING WITH A MOTION
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- nvim-treesitter-textobjects
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
require'nvim-treesitter.configs'.setup {
	ensure_installed = { "c_sharp", "bash", "css", "html", "javascript", "json", "lua", "python", "regex", "scss", "tsx", "typescript", "vim", "yaml" },
	highlight = {
		enable = true,
	},
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
}
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- /nvim-treesitter-textobjects
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

require('goto-preview').setup {
 -- SEE: https://github.com/rmagatti/goto-preview#%EF%B8%8F-configuration
	width = 120; -- Width of the floating window
	height = 30; -- Height of the floating window
	border = {"↖", "─" ,"┐", "│", "┘", "─", "└", "│"}; -- Border characters of the floating window
	default_mappings = true; -- Bind default mappings
	debug = false; -- Print debug information
	opacity = nil; -- 0-100 opacity level of the floating window where 100 is fully transparent.
	-- resizing_mappings = true; -- Binds arrow keys to resizing the floating window.
	post_open_hook = nil; -- A function taking two arguments, a buffer and a window to be ran as a hook.
	references = { -- Configure the telescope UI for slowing the references cycling window.
		-- telescope = telescope.themes.get_dropdown({ hide_preview = false })
		-- telescope = require("telescope.themes").get_dropdown({ hide_preview = false, width = 0.75 })
	};
	-- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peak" functionality.
	focus_on_open = true; -- Focus the floating window when opening it.
	dismiss_on_move = false; -- Dismiss the floating window when moving the cursor.
	force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
	bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
}

-- require("cmp_dictionary").setup({
-- 		dic = {
-- 			["*"] = { "/usr/share/dict/words" },
-- 			["lua"] = "path/to/lua.dic",
-- 			["javascript,typescript"] = { "path/to/js.dic", "path/to/js2.dic" },
-- 			filename = {
-- 				["xmake.lua"] = { "path/to/xmake.dic", "path/to/lua.dic" },
-- 			},
-- 			filepath = {
-- 				["%.tmux.*%.conf"] = "path/to/tmux.dic"
-- 			},
-- 			spelllang = {
-- 				en = "path/to/english.dic",
-- 			},
-- 		},
-- 		-- The following are default values.
-- 		exact = 2,
-- 		first_case_insensitive = false,
-- 		document = false,
-- 		document_command = "wn %s -over",
-- 		async = false,
-- 		capacity = 5,
-- 		debug = false,
-- 	})
