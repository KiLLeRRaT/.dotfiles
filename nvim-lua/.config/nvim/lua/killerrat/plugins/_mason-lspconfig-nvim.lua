local omnisharp_version = "@v1.39.11"
local lsp_installer_ensure_installed = {
	-- LSP
	"bashls",
	-- "omnisharp" .. omnisharp_version,
	-- "omnisharp-mono",
	"cssls",
	"dockerls",
	"eslint",
	"html",
	"jsonls",
	"pyright",
	-- "tsserver",
	"ts_ls",
	-- "sumneko_lua",
	"lua_ls",
	--"sqls", -- https://github.com/lighttiger2505/sqls
	"lemminx",
	"yamlls",
	"azure_pipelines_ls",

	-- DAP
	-- "netcoredbg",

	-- LINTERS
	"tflint",

	-- FORMATTERS
	-- "csharpier",
	-- "jq",
	-- "markdownlint",
	-- "prettier"


	-- These guys error, since they are in a custom registry, but we do want them so install them
	-- manually using `:MasonInstall roslyn` and `:MasonInstall rzls`
	-- "roslyn",
	-- "rzls",
}

if vim.fn.has("win32") == 1 then
	table.insert(lsp_installer_ensure_installed, "powershell_es")
elseif vim.fn.has("unix") == 1 then
	-- table.insert(lsp_installer_ensure_installed, "omnisharp_mono" .. omnisharp_version)
end


require("mason-lspconfig").setup({
	ensure_installed = lsp_installer_ensure_installed
})
