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
require'lspconfig'.omnisharp.setup {
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
  on_attach = function(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  end,
  cmd = { "C:/GBox/Applications/Tools/Applications/Neovim/nvim-win64/lsp-instance/omnisharp-win-x64-net6.0-1.38.2/OmniSharp.exe", "--languageserver" , "--hostPID", tostring(pid) },
  -- cmd = { "C:\\ProgramData\\chocolatey\\lib\\omnisharp\\tools\\OmniSharp.exe", "--languageserver" , "--hostPID", tostring(pid) },
}

-- csharp_ls
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#csharp_ls
-- https://github.com/razzmatazz/csharp-language-server/blob/master/src/CSharpLanguageServer/Options.fs
-- THIS DOESNT EVEN WORK IN THE POR PROJECT...
-- require'lspconfig'.csharp_ls.setup{}
