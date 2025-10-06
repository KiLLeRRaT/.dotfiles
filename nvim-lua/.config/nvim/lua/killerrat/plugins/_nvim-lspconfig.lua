-- require'lspconfig'.bashls.setup{}
vim.lsp.config('bashls', {})


-- require'lspconfig'.dockerls.setup{}
vim.lsp.config('dockerls', {})


-- ESLINT
--- npm i -g vscode-langservers-extracted
-- require'lspconfig'.eslint.setup {}
-- npm i -g eslint
-- local eslint_config = require("lspconfig.server_configurations.eslint")
-- require'lspconfig'.eslint.setup{}
vim.lsp.config('eslint', {})

--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- require'lspconfig'.cssls.setup {
-- 	capabilities = capabilities,
-- }
vim.lsp.config('cssls', { capabilities = capabilities })

-- require'lspconfig'.html.setup {
--   capabilities = capabilities,
-- }
vim.lsp.config('html', { capabilities = capabilities })

-- require'lspconfig'.jsonls.setup {
-- 	capabilities = capabilities,
-- }
vim.lsp.config('jsonls', { capabilities = capabilities })

-- require'lspconfig'.pyright.setup{}
vim.lsp.config('pyright', {})

-- require'lspconfig'.tsserver.setup{}
-- require'lspconfig'.ts_ls.setup{}
vim.lsp.config('ts_ls', {})

-- require'lspconfig'.lua_ls.setup{
-- 	settings = {
-- 		Lua = {
-- 			workspace = {
-- 				checkThirdParty = false, -- Disable checking third-party libraries
-- 				library = vim.api.nvim_get_runtime_file("", true), -- Include Neovim runtime files
-- 			},
-- 			diagnostics = {
-- 				globals = { 'vim' }
-- 			}
-- 		}
-- 	}
-- }
vim.lsp.config('lua_ls', {
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
})

-- require'lspconfig'.marksman.setup{}

-- require'lspconfig'.lemminx.setup{}
vim.lsp.config('lemminx', {})

-- ADD MODELINE TO FILES:
-- # yaml-language-server: $schema=<urlToTheSchema|relativeFilePath|absoluteFilePath}>

-- SEE: https://github.com/redhat-developer/yaml-language-server/issues/912
-- local capabilitiesyamlls = vim.lsp.protocol.make_client_capabilities()
-- capabilitiesyamlls.textDocument.foldingRange = {
-- 	dynamicRegistration = false,
-- 	lineFoldingOnly = true
-- }

-- require'lspconfig'.yamlls.setup{
-- 	-- capabilities = capabilitiesyamlls,
-- 	capabilities = capabilities,
-- 	settings = {
-- 		yaml = {
-- 			keyOrdering = false,
-- 			schemas = {
-- 				["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "**/docker-compose.*",
-- 				-- Get the file from: https://dev.azure.com/sandfield/_apis/distributedtask/yamlschema?api-version=5.1, can't just use the URL directly because it requires auth
-- 				-- ["https://raw.githubusercontent.com/KiLLeRRaT/.dotfiles/refs/heads/master/yaml-schema/yaml-schema-azure-pipelines.json"] = "azure-pipelines.*",
-- 				-- You can also add other schemas here, e.g., for Kubernetes
-- 				-- ["kubernetes"] = "*.yaml",
-- 				["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
-- 					"/azure-pipeline*.y*l",
-- 					"azure-pipelines/**/*.y*l",
-- 				},
-- 					  },
-- 		}
-- 	}
-- }
vim.lsp.config('yamlls', {
	-- capabilities = capabilitiesyamlls,
	capabilities = capabilities,
	settings = {
		yaml = {
			keyOrdering = false,
			schemas = {
				["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "**/docker-compose.*",
				-- Get the file from: https://dev.azure.com/sandfield/_apis/distributedtask/yamlschema?api-version=5.1, can't just use the URL directly because it requires auth
				-- ["https://raw.githubusercontent.com/KiLLeRRaT/.dotfiles/refs/heads/master/yaml-schema/yaml-schema-azure-pipelines.json"] = "azure-pipelines.*",
				-- You can also add other schemas here, e.g., for Kubernetes
				-- ["kubernetes"] = "*.yaml",
				["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
					"/azure-pipeline*.y*l",
					"azure-pipelines/**/*.y*l",
				},
					  },
		}
	}
})

-- require'lspconfig'.azure_pipelines_ls.setup{
-- 	-- capabilities = capabilitiesyamlls,
-- 	capabilities = capabilities,
-- 	settings = {
-- 		yaml = {
-- 			schemas = {
-- 				["https://raw.githubusercontent.com/microsoft/azure-pipelines-vscode/master/service-schema.json"] = {
-- 					"/azure-pipeline*.y*l",
-- 					"/*.azure*",
-- 					"Azure-Pipelines/**/*.y*l",
-- 					"Pipelines/*.y*l",
-- 				},
-- 			}
-- 		}
-- 	}
-- }
	-- POWERSHELL
	-- TODO:
	-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#powershell_es
if vim.fn.has('win32') == 1 then
	-- require'lspconfig'.powershell_es.setup{}
	vim.lsp.config('powershell_es', {})
end

-- require'lspconfig'.tflint.setup{}
vim.lsp.config('tflint', {})
