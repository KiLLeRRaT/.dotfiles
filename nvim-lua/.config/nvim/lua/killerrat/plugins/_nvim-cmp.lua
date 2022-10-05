if not _G.plugin_loaded("nvim-cmp") then
	do return end
end

local lsp_symbols = {
	Text = " 	(Text) ",
	Method = " 	(Method)",
	Function = " 	(Function)",
	Constructor = "   (Constructor)",
	Field = " ﴲ  (Field)",
	Variable = "[] (Variable)",
	Class = "   (Class)",
	Interface = " ﰮ  (Interface)",
	Module = " 	(Module)",
	Property = " 襁 (Property)",
	Unit = " 	(Unit)",
	Value = "   (Value)",
	Enum = " 練 (Enum)",
	Keyword = "   (Keyword)",
	Snippet = "   (Snippet)",
	Color = "   (Color)",
	File = " 	(File)",
	Reference = "   (Reference)",
	Folder = " 	(Folder)",
	EnumMember = " 	(EnumMember)",
	Constant = " ﲀ	(Constant)",
	Struct = " ﳤ	(Struct)",
	Event = "   (Event)",
	Operator = " 	(Operator)",
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
		-- { name = "buffer" }, -- CURRENT BUFFER ONLY
		{ -- ALL BUFFERS
			name = 'buffer',
			option = {
				get_bufnrs = function()
					return vim.api.nvim_list_bufs()
				end
			}
		},
		-- { -- VISIBLE BUFFERS
		-- 			name = 'buffer',
		-- 			option = {
		-- 				get_bufnrs = function()
		-- 					local bufs = {}
		-- 					for _, win in ipairs(vim.api.nvim_list_wins()) do
		-- 						bufs[vim.api.nvim_win_get_buf(win)] = true
		-- 					end
		-- 					return vim.tbl_keys(bufs)
		-- 				end
		-- 			}
		-- 		}
		{ name = 'nvim_lsp_signature_help' },
		-- { name = 'vim-dadbod-completion' },
		{ name = 'calc' },
		{ name = 'emoji' },
		{ name = 'neorg' },
		-- { name = 'spell' },
		-- { name = 'dictionary', keyword_length = 2 },
	},
	snippet = {
		expand = function(args)
			require'luasnip'.lsp_expand(args.body)
		end
	},
	formatting = {
		format = function(entry, item)
			item.kind = lsp_symbols[item.kind]
			item.menu = ({
				buffer = "[B]",
				nvim_lsp = "[L]",
				path = "[P]",
				sql = "[DB]",
				luasnip = "[Snippet]",
				-- neorg = "[Neorg]",
			})[entry.source.name]

			return item
		end,
	},
}

