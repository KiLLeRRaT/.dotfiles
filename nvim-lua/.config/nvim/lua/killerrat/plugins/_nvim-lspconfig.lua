require'lspconfig'.bashls.setup{}

require'lspconfig'.dockerls.setup{}

-- ESLINT
--- npm i -g vscode-langservers-extracted
-- require'lspconfig'.eslint.setup {}
-- npm i -g eslint
-- local eslint_config = require("lspconfig.server_configurations.eslint")
require'lspconfig'.eslint.setup {
}

--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require'lspconfig'.cssls.setup {
	capabilities = capabilities,
}

require'lspconfig'.html.setup {
  capabilities = capabilities,
}

require'lspconfig'.jsonls.setup {
	capabilities = capabilities,
}

require'lspconfig'.pyright.setup{}

-- require'lspconfig'.tsserver.setup{}
require'lspconfig'.ts_ls.setup{}

require'lspconfig'.lua_ls.setup{
	settings = {
		Lua = {
			workspace = {
				checkThirdParty = false, -- Disable checking third-party libraries
				library = vim.api.nvim_get_runtime_file("", true), -- Include Neovim runtime files
			},
			diagnostics = {
				globals = { 'vim' }
			}
		}
	}
}

-- require'lspconfig'.marksman.setup{}

require'lspconfig'.lemminx.setup{}

-- ADD MODELINE TO FILES:
-- # yaml-language-server: $schema=<urlToTheSchema|relativeFilePath|absoluteFilePath}>
require'lspconfig'.yamlls.setup{
	settings = {
		yaml = {
			keyOrdering = false,
			schemas = {
						["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose.yaml",
						-- Get the file from: https://dev.azure.com/sandfield/_apis/distributedtask/yamlschema?api-version=5.1, can't just use the URL directly because it requires auth
						["https://raw.githubusercontent.com/KiLLeRRaT/.dotfiles/refs/heads/master/yaml-schema/yaml-schema-azure-pipelines.json"] = "azure-pipelines.yml",
						-- You can also add other schemas here, e.g., for Kubernetes
						-- ["kubernetes"] = "*.yaml",
					  },
		}
	}
}

-- POWERSHELL
-- TODO:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#powershell_es
if vim.fn.has('win32') == 1 then
	require'lspconfig'.powershell_es.setup{}
end

require'lspconfig'.tflint.setup{}
