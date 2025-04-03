require('roslyn').setup {
	args = {
		'--stdio',
		'--logLevel=Information',
		'--extensionLogDirectory=' .. vim.fs.dirname(vim.lsp.get_log_path()),
		'--razorSourceGenerator=' .. vim.fs.joinpath(
			vim.fn.stdpath 'data' --[[@as string]],
			'mason',
			'packages',
			'roslyn',
			'libexec',
			'Microsoft.CodeAnalysis.Razor.Compiler.dll'
		),
		'--razorDesignTimePath=' .. vim.fs.joinpath(
			vim.fn.stdpath 'data' --[[@as string]],
			'mason',
			'packages',
			'rzls',
			'libexec',
			'Targets',
			'Microsoft.NET.Sdk.Razor.DesignTime.targets'
		),
	},
	config = {
		--[[ the rest of your roslyn config ]]
		handlers = require 'rzls.roslyn_handlers',
		on_attach = function (client, bufnr)
			--- Guard against servers without the signatureHelper capability
			if client.server_capabilities.signatureHelpProvider then
				require('lsp-overloads').setup(client, { })
				vim.api.nvim_buf_set_keymap(0, "n", "<C-Space>", ":LspOverloadsSignature<CR>", { noremap = true, silent = true })
				-- ...
				-- keymaps = {
				-- 		next_signature = "<C-j>",
				-- 		previous_signature = "<C-k>",
				-- 		next_parameter = "<C-l>",
				-- 		previous_parameter = "<C-h>",
				-- 		close_signature = "<A-s>"
				-- 	},
				-- ...
			end
		end
	},
}
-- require("roslyn").setup({
-- 		config = {
-- 				-- Here you can pass in any options that that you would like to pass to `vim.lsp.start`.
-- 				-- Use `:h vim.lsp.ClientConfig` to see all possible options.
-- 				-- The only options that are overwritten and won't have any effect by setting here:
-- 				--     - `name`
-- 				--     - `cmd`
-- 				--     - `root_dir`
-- 		},
--
-- 		--[[
-- 		-- if you installed `roslyn-ls` by nix, use the following:
-- 			exe = 'Microsoft.CodeAnalysis.LanguageServer',
-- 		]]
-- 		exe = {
-- 				"dotnet",
-- 				vim.fs.joinpath(vim.fn.stdpath("data"), "roslyn", "Microsoft.CodeAnalysis.LanguageServer.dll"),
-- 		},
-- 		args = {
-- 				"--logLevel=Information", "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path())
-- 		},
-- 	--[[
-- 	-- args can be used to pass additional flags to the language server
-- 		]]
--
-- 		-- NOTE: Set `filewatching` to false if you experience performance problems.
-- 		-- Defaults to true, since turning it off is a hack.
-- 		-- If you notice that the server is _super_ slow, it is probably because of file watching
-- 		-- Neovim becomes super unresponsive on some large codebases, because it schedules the file watching on the event loop.
-- 		-- This issue goes away by disabling this capability, but roslyn will fallback to its own file watching,
-- 		-- which can make the server super slow to initialize.
-- 		-- Setting this option to false will indicate to the server that neovim will do the file watching.
-- 		-- However, in `hacks.lua` I will also just don't start off any watchers, which seems to make the server
-- 		-- a lot faster to initialize.
-- 		filewatching = true,
--
-- 		-- Optional function that takes an array of targets as the only argument. Return the target you
-- 		-- want to use. If it returns `nil`, then it falls back to guessing the target like normal
-- 		-- Example:
-- 		--
-- 		-- choose_target = function(target)
-- 		--     return vim.iter(target):find(function(item)
-- 		--         if string.match(item, "Foo.sln") then
-- 		--             return item
-- 		--         end
-- 		--     end)
-- 		-- end
-- 		choose_target = nil,
--
-- 		-- Optional function that takes the selected target as the only argument.
-- 		-- Returns a boolean of whether it should be ignored to attach to or not
-- 		--
-- 		-- I am for example using this to disable a solution with a lot of .NET Framework code on mac
-- 		-- Example:
-- 		--
-- 		-- ignore_target = function(target)
-- 		--     return string.match(target, "Foo.sln") ~= nil
-- 		-- end
-- 		ignore_target = nil,
--
-- 		-- Whether or not to look for solution files in the child of the (root).
-- 		-- Set this to true if you have some projects that are not a child of the
-- 		-- directory with the solution file
-- 		broad_search = false,
--
-- 		-- Whether or not to lock the solution target after the first attach.
-- 		-- This will always attach to the target in `vim.g.roslyn_nvim_selected_solution`.
-- 		-- NOTE: You can use `:Roslyn target` to change the target
-- 		lock_target = false,
-- })
