-- autocomplete config
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
  }
}

-- omnisharp lsp config
local pid = vim.fn.getpid()
local omniSharpPath

if vim.fn.has('win32') == 1 then
	-- omniSharpPath = vim.fn.expand('C:/GBox/Applications/Tools/Applications/Neovim/nvim-win64/lsp-instance/omnisharp-win-x64-net6.0-1.38.2/OmniSharp.exe')
	omniSharpPath = 'C:/GBox/Applications/Tools/Applications/Neovim/nvim-win64/lsp-instance/omnisharp-win-x64-net6.0-1.38.2/OmniSharp.exe'
elseif vim.fn.has('mac') == 1 then
	omniSharpPath = vim.fn.expand('~/Applications/omnisharp-osx-x64-net6.0/OmniSharp')
elseif vim.fn.has('linux') == 1 then
	omniSharpPath = vim.fn.expand('~/.omnisharp/OmniSharp')
end
-- omniSharpPath = "ABC" .. vim.fn.has('win32') .. vim.fn.has('mac') .. vim.fn.has('linux')
-- print( "Features: " .. vim.fn.has('win32') .. vim.fn.has('mac') .. vim.fn.has('linux'))
require'lspconfig'.omnisharp.setup {
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
  on_attach = function(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  end,
	on_new_config = function(new_config, new_root_dir)
		if new_root_dir then
			table.insert(new_config.cmd, '-s')
			-- table.insert(new_config.cmd, new_root_dir)
			table.insert(new_config.cmd, new_root_dir .. '/Sandfield.TIL.Orca.sln')
			-- table.insert(new_config.cmd, new_root_dir .. '/Sandfield.TIL.Orca.Internet.Web.2.0/Sandfield.TIL.Orca.Internet.Web.2.0.csproj')
		end
	end,
	cmd = { omniSharpPath, '--languageserver', '--hostPID', tostring(pid), '--verbose'},

  -- cmd = { "C:\\ProgramData\\chocolatey\\lib\\omnisharp\\tools\\OmniSharp.exe", "--languageserver" , "--hostPID", tostring(pid) },

	-- Windows
  -- cmd = { "C:/GBox/Applications/Tools/Applications/Neovim/nvim-win64/lsp-instance/omnisharp-win-x64-net6.0-1.38.2/OmniSharp.exe", "--languageserver" , "--hostPID", tostring(pid) },

	-- MacOS
  -- cmd = { "/Users/albert/Applications/omnisharp-osx-x64-net6.0/OmniSharp", "--languageserver" , "--hostPID", tostring(pid) },

	-- Linux
  -- cmd = { "/home/albert/.omnisharp/OmniSharp", "--languageserver" , "--hostPID", tostring(pid) },
}

-- csharp_ls
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#csharp_ls
-- https://github.com/razzmatazz/csharp-language-server/blob/master/src/CSharpLanguageServer/Options.fs
-- THIS DOESNT EVEN WORK IN THE POR PROJECT...
-- require'lspconfig'.csharp_ls.setup{}
