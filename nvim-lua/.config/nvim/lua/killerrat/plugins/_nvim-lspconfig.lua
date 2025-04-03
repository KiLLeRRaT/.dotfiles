require'lspconfig'.bashls.setup{}

-- LOOK IN CURRENT DIRECTORY FOR csproj FILE using glob
-- IF NO FILE IN CURRENT DIRECTORY, LOOK IN PARENT DIRECTORY recursively
-- local function find_closest_csproj(directory)
-- 	-- print("currentFileDirectory: " .. directory)
-- 	local csproj = vim.fn.glob(directory .. "/*.csproj", true, false)
-- 	if csproj == "" then
-- 		csproj = vim.fn.glob(directory .. "/*.vbproj", true, false)
-- 	end
-- 	if csproj == "" then
-- 		-- IF NO FILE IN CURRENT DIRECTORY, LOOK IN PARENT DIRECTORY recursively
-- 		local parent_directory = vim.fn.fnamemodify(directory, ":h")
-- 		if parent_directory == directory then
-- 			return nil
-- 		end
-- 		return find_closest_csproj(parent_directory)
-- 	-- elseif there are multiple csproj files, then return the first one
-- 	elseif string.find(csproj, "\n") ~= nil then
-- 		local first_csproj = string.sub(csproj, 0, string.find(csproj, "\n") - 1)
-- 		print("Found multiple csproj files, using: " .. first_csproj)
-- 		return first_csproj
-- 	else
-- 		return csproj
-- 	end
-- end


-- CHECK CSPROJ FILE TO SEE IF ITS .NET CORE OR .NET FRAMEWORK
-- local function getFrameworkType()
-- 	local currentFileDirectory = vim.fn.expand("%:p:h")
-- 	-- print("currentFileDirectory file: " .. currentFileDirectory)
-- 	local csproj = find_closest_csproj(currentFileDirectory)
-- 	-- print("csproj file: " .. csproj)
-- 	if csproj == nil then
-- 		return false
-- 	end
-- 	local f = io.open(csproj, "rb")
-- 	local content = f:read("*all")
-- 	f:close()
-- 	-- return string.find(content, "<TargetFramework>netcoreapp") ~= nil
-- 	local frameworkType = ""
-- 	-- IF FILE CONTAINS <TargetFrameworkVersion> THEN IT'S .NET FRAMEWORK
-- 	if string.find(content, "<TargetFrameworkVersion>") ~= nil then
-- 		frameworkType = "netframework"
-- 	-- IF FILE CONTAINS <TargetFramework>net48 THEN IT'S .NET FRAMEWORK
-- 	elseif string.find(content, "<TargetFramework>net48") ~= nil then
-- 		frameworkType = "netframework"
-- 	-- ELSE IT'S .NET CORE
-- 	else
-- 		frameworkType = "netcore"
-- 	end
-- 	return frameworkType
-- end

-- CREATE AUTOCMD FOR CSHARP FILES
-- vim.api.nvim_create_autocmd("FileType",{
-- 	-- pattern = 'cs',
-- 	pattern = { 'cs', 'cshtml', 'vb' },
-- 	callback = function()
-- 		-- print("FileType: cs, cshtml, vb")
-- 		if vim.g.dotnetlsp then
-- 			-- print("dotnetlsp is already set: " .. vim.g.dotnetlsp)
-- 			return
-- 		end
--
-- 		-- MOVED TO _roslyn-nvim.lua
-- 		-- local on_attach = function (client, bufnr)
-- 		-- 	--- Guard against servers without the signatureHelper capability
-- 		-- 	if client.server_capabilities.signatureHelpProvider then
-- 		-- 		require('lsp-overloads').setup(client, { })
-- 		-- 		-- ...
-- 		-- 		-- keymaps = {
-- 		-- 		-- 		next_signature = "<C-j>",
-- 		-- 		-- 		previous_signature = "<C-k>",
-- 		-- 		-- 		next_parameter = "<C-l>",
-- 		-- 		-- 		previous_parameter = "<C-h>",
-- 		-- 		-- 		close_signature = "<A-s>"
-- 		-- 		-- 	},
-- 		-- 		-- ...
-- 		-- 	end
-- 		-- end
--
-- 		-- SEE: https://github.com/omnisharp/omnisharp-roslyn
-- 		-- local settings = {
-- 		-- 	FormattingOptions = {
-- 		-- 		-- Enables support for reading code style, naming convention and analyzer
-- 		-- 		-- settings from .editorconfig.
-- 		-- 		EnableEditorConfigSupport = true,
-- 		-- 		-- Specifies whether 'using' directives should be grouped and sorted during
-- 		-- 		-- document formatting.
-- 		-- 		OrganizeImports = true,
-- 		-- 	},
-- 		-- 	MsBuild = {
-- 		-- 		-- If true, MSBuild project system will only load projects for files that
-- 		-- 		-- were opened in the editor. This setting is useful for big C# codebases
-- 		-- 		-- and allows for faster initialization of code navigation features only
-- 		-- 		-- for projects that are relevant to code that is being edited. With this
-- 		-- 		-- setting enabled OmniSharp may load fewer projects and may thus display
-- 		-- 		-- incomplete reference lists for symbols.
-- 		-- 		LoadProjectsOnDemand = nil,
-- 		-- 	},
-- 		-- 	RoslynExtensionsOptions = {
-- 		-- 		-- Enables support for roslyn analyzers, code fixes and rulesets.
-- 		-- 		EnableAnalyzersSupport = false, -- THIS ADED FIX FORMATTING ON EVERY SINGLE LINE IN CS FILES!
-- 		-- 		-- Enables support for showing unimported types and unimported extension
-- 		-- 		-- methods in completion lists. When committed, the appropriate using
-- 		-- 		-- directive will be added at the top of the current file. This option can
-- 		-- 		-- have a negative impact on initial completion responsiveness,
-- 		-- 		-- particularly for the first few completion sessions after opening a
-- 		-- 		-- solution.
-- 		-- 		EnableImportCompletion = nil,
-- 		-- 		-- Only run analyzers against open files when 'enableRoslynAnalyzers' is
-- 		-- 		-- true
-- 		-- 		AnalyzeOpenDocumentsOnly = nil,
-- 		-- 		enableDecompilationSupport = true,
-- 		-- 	},
-- 		-- 	Sdk = {
-- 		-- 		-- Specifies whether to include preview versions of the .NET SDK when
-- 		-- 		-- determining which version to use for project loading.
-- 		-- 		IncludePrereleases = true,
-- 		-- 	},
-- 		-- }
--
--
-- 		-- -- CHECK THE CSPROJ OR SOMETHING ELSE TO CONFIRM IT'S .NET FRAMEWORK OR .NET CORE PROJECT
-- 		-- local frameworkType = getFrameworkType()
-- 		--
-- 		-- -- NASTY HACK TO GET WIN32 WORKING
-- 		-- if vim.fn.has('win32') then
-- 		-- 	frameworkType = "netcore"
-- 		-- end
-- 		--
-- 		-- if frameworkType == "netframework" then
-- 		-- 	print("Found a .NET Framework project, starting .NET Framework OmniSharp")
-- 		-- 	require'lspconfig'.omnisharp_mono.setup {
-- 		-- 		-- enable_decompilation_support = true,
-- 		-- 		handlers = {
-- 		-- 			["textDocument/definition"] = require('omnisharp_extended').handler,
-- 		-- 		},
-- 		-- 		-- organize_imports_on_format = true,
-- 		-- 		settings = settings,
-- 		-- 		on_attach = on_attach,
-- 		-- 	}
-- 		-- 	vim.g.dotnetlsp = "omnisharp_mono"
-- 		-- 	vim.cmd('LspStart omnisharp_mono')
-- 		-- elseif frameworkType == "netcore" then
-- 		-- 	print("Found a .NET Core project, starting .NET Core OmniSharp")
-- 		-- 	require'lspconfig'.omnisharp.setup {
-- 		-- 		-- enable_decompilation_support = true,
-- 		-- 		handlers = {
-- 		-- 			["textDocument/definition"] = require('omnisharp_extended').handler,
-- 		-- 		},
-- 		-- 		-- organize_imports_on_format = true,
-- 		-- 		settings = settings,
-- 		-- 		on_attach = on_attach,
-- 		-- 	}
-- 		-- 	vim.g.dotnetlsp = "omnisharp"
-- 		-- 	vim.cmd('LspStart omnisharp')
-- 		-- else
-- 		-- 	return
-- 		-- end
-- 	end,
-- 	group = vim.api.nvim_create_augroup("_nvim-lspconfig.lua.filetype.csharp", { clear = true })
-- })


-- OLD MANUAL WAY TO DETECT FRAMEWORK TYPE
-- -- print("Current working directory: " .. vim.fn.getcwd())
-- local current_working_directory = vim.fn.getcwd()
-- local use_mono = false
-- local mono_projects = {
-- 	'/mnt/c/Projects.Git/AA',
-- 	'/mnt/c/Projects.Git/SW.API',
-- 	'/mnt/whiskey.agouws.gouws.org/c/Projects.Git/SW.API'
-- }

-- for index, value in ipairs(mono_projects) do
--     -- print(index, ". ", value)
-- 		-- print("Current working directory: " .. current_working_directory .. " value: " .. value)
-- 		if string.find(current_working_directory, value) then
-- 			-- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/server_configurations/omnisharp/README.md
-- 			require'lspconfig'.omnisharp_mono.setup {
-- 				organize_imports_on_format = true,
-- 			}
-- 			use_mono = true
-- 			print("Found a mono project, starting .NET Framework OmniSharp")
-- 			break
-- 		end
-- end

-- if use_mono == false then
-- 	print("Not a mono project, starting .NET Core OmniSharp")
-- 	-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#omnisharp
-- 	require'lspconfig'.omnisharp.setup {
-- 		organize_imports_on_format = true,
-- 	}
-- end
-- /OLD MANUAL WAY TO DETECT FRAMEWORK TYPE


require'lspconfig'.dockerls.setup{}

-- ESLINT
--- npm i -g vscode-langservers-extracted
-- require'lspconfig'.eslint.setup {}
-- npm i -g eslint
-- local eslint_config = require("lspconfig.server_configurations.eslint")
require'lspconfig'.eslint.setup {
    -- opts.cmd = { "yarn", "exec", unpack(eslint_config.default_config.cmd) }
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
			keyOrdering = false
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
