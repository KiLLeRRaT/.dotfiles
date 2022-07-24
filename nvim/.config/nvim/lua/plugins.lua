-- autocomplete config
-- local cmp = require 'cmp'
-- cmp.setup {
--   mapping = {
--     ['<Tab>'] = cmp.mapping.select_next_item(),
--     ['<S-Tab>'] = cmp.mapping.select_prev_item(),
--     ['<CR>'] = cmp.mapping.confirm({
--       behavior = cmp.ConfirmBehavior.Replace,
--       select = true,
--     })
--   },
--   sources = {
--     { name = 'nvim_lsp' },
--   }
-- }

-- OMNISHARP LSP CONFIG
-- local pid = vim.fn.getpid()
-- local omniSharpPath

-- if vim.fn.has('win32') == 1 then
-- 	-- omniSharpPath = 'C:/GBox/Applications/Tools/Applications/Neovim/nvim-win64/lsp-instance/omnisharp-win-x64-net6.0-1.38.2/OmniSharp.exe'
-- 	omniSharpPath = 'C:/GBox/Applications/Tools/Applications/Neovim/nvim-win64/lsp-instance/omnisharp-win-x64-1.38.2/OmniSharp.exe'
-- elseif vim.fn.has('mac') == 1 then
-- 	omniSharpPath = vim.fn.expand('~/Applications/omnisharp-osx-x64-net6.0/OmniSharp')
-- elseif vim.fn.has('linux') == 1 then
-- 	-- omniSharpPath = vim.fn.expand('~/.omnisharp/OmniSharp')
-- 	omniSharpPath = vim.fn.expand('~/.omnisharp/omnisharp')
-- end
-- -- print( "Features: " .. vim.fn.has('win32') .. vim.fn.has('mac') .. vim.fn.has('linux'))
-- require'lspconfig'.omnisharp.setup {
--   capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
--   on_attach = function(_, bufnr)
--     vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
--   end,
-- 	on_new_config = function(new_config, new_root_dir)
-- 		if new_root_dir then
-- 			table.insert(new_config.cmd, '-s')
-- 			table.insert(new_config.cmd, new_root_dir)
-- 			-- table.insert(new_config.cmd, new_root_dir .. '/Sandfield.TIL.Orca.sln')
-- 			-- table.insert(new_config.cmd, new_root_dir .. '/Sandfield.POR.Portal.sln')
-- 		end
-- 	end,
-- 	cmd = { omniSharpPath, '--languageserver', '--hostPID', tostring(pid), '--loglevel', 'debug' },

--   -- cmd = { "C:\\ProgramData\\chocolatey\\lib\\omnisharp\\tools\\OmniSharp.exe", "--languageserver" , "--hostPID", tostring(pid) },

-- 	-- Windows
--   -- cmd = { "C:/GBox/Applications/Tools/Applications/Neovim/nvim-win64/lsp-instance/omnisharp-win-x64-net6.0-1.38.2/OmniSharp.exe", "--languageserver" , "--hostPID", tostring(pid) },

-- 	-- MacOS
--   -- cmd = { "/Users/albert/Applications/omnisharp-osx-x64-net6.0/OmniSharp", "--languageserver" , "--hostPID", tostring(pid) },

-- 	-- Linux
--   -- cmd = { "/home/albert/.omnisharp/OmniSharp", "--languageserver" , "--hostPID", tostring(pid) },
-- }
-- /OMNISHARP LSP CONFIG

-- csharp_ls
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#csharp_ls
-- https://github.com/razzmatazz/csharp-language-server/blob/master/src/CSharpLanguageServer/Options.fs
-- THIS DOESNT EVEN WORK IN THE POR PROJECT...
-- require'lspconfig'.csharp_ls.setup{}

-- LUA LINES, https://github.com/nvim-lualine/lualine.nvim#default-configuration
require('lualine').setup {
	options = {
		-- theme = 'gruvbox'
		theme = 'palenight'
	}
}
require("bufferline").setup {
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
