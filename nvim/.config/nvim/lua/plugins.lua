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

-- PATH SETUP BASED ON OS
local omniSharpPath
local netcoredbgPath

if vim.fn.has('win32') == 1 then
	-- omniSharpPath = 'C:/GBox/Applications/Tools/Applications/Neovim/nvim-win64/lsp-instance/omnisharp-win-x64-net6.0-1.38.2/OmniSharp.exe'
	omniSharpPath = 'C:/GBox/Applications/Tools/Applications/Neovim/nvim-win64/lsp-instance/omnisharp-win-x64-1.38.2/OmniSharp.exe'
	netcoredbgPath = 'C:/GBox/Applications/Tools/Applications/Neovim/nvim-win64/lsp-instance/netcoredbf-win64-2.0.0-895/netcoredbg.exe'
elseif vim.fn.has('mac') == 1 then
	omniSharpPath = vim.fn.expand('~/Applications/omnisharp-osx-x64-net6.0/OmniSharp')
elseif vim.fn.has('linux') == 1 then
	-- omniSharpPath = vim.fn.expand('~/.omnisharp/OmniSharp')
	omniSharpPath = vim.fn.expand('~/.omnisharp/run')
end
-- print( "Features: " .. vim.fn.has('win32') .. vim.fn.has('mac') .. vim.fn.has('linux'))
-- /PATH SETUP BASED ON OS

-- OMNISHARP LSP CONFIG
local pid = vim.fn.getpid()
require'lspconfig'.omnisharp.setup {
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
  on_attach = function(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  end,
	on_new_config = function(new_config, new_root_dir)
		if new_root_dir then
			table.insert(new_config.cmd, '-s')
			table.insert(new_config.cmd, new_root_dir)
			-- table.insert(new_config.cmd, new_root_dir .. '/Sandfield.TIL.Orca.sln')
			-- table.insert(new_config.cmd, new_root_dir .. '/Sandfield.POR.Portal.sln')
		end
	end,
	cmd = { omniSharpPath, '--languageserver', '--hostPID', tostring(pid), '--loglevel', 'debug' },
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
require'lspconfig'.eslint.setup {}

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

-- TSSERVER
-- npm install -g typescript typescript-language-server
require'lspconfig'.tsserver.setup{}

-- YAMLLS
-- npm install -g yaml-language-server
-- ADD MODELINE TO FILES:
-- # yaml-language-server: $schema=<urlToTheSchema|relativeFilePath|absoluteFilePath}>
require'lspconfig'.yamlls.setup{}


-- DEBUGGERS
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
        return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
    end,
  },
}
-- /DEBUGGERS

