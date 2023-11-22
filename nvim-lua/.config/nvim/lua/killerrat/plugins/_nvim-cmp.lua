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

-- FROM: https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local luasnip = require("luasnip")
local cmp = require 'cmp'

cmp.setup {
	mapping = {
		['<Esc>'] = cmp.mapping.abort(),

		-- FROM: https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
		-- ['<Tab>'] = cmp.mapping.select_next_item(),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				print("nvim-cmp: cmd.visible() is true")
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				print("nvim-cmp: luasnip.expand_or_jumpable() is true")
				luasnip.expand_or_jump()
			elseif has_words_before() then
				print("nvim-cmp: has_words_before() is true")
				cmp.complete()
			else
				print("nvim-cmp: fallback() is true")
				fallback()
			end
		end, { "i", "s" }),

		-- FROM: https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
		-- ['<S-Tab>'] = cmp.mapping.select_prev_item(),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),

		['<CR>'] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		-- FROM: https://github.com/community/community/discussions/29817#discussioncomment-3583667
		-- ALSO SEE the copilot lua config file!
		['<C-Y>'] = cmp.mapping(function(fallback)
			vim.api.nvim_feedkeys(vim.fn['copilot#Accept'](vim.api.nvim_replace_termcodes('<Tab>', true, true, true)), 'n', true)
		end)
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
		--			name = 'buffer',
		--			option = {
		--				get_bufnrs = function()
		--					local bufs = {}
		--					for _, win in ipairs(vim.api.nvim_list_wins()) do
		--						bufs[vim.api.nvim_win_get_buf(win)] = true
		--					end
		--					return vim.tbl_keys(bufs)
		--				end
		--			}
		--		}
		-- { name = 'nvim_lsp_signature_help' }, -- DISABLED ON 14 Sep 2023 in favor of lsp-overload
		-- { name = 'vim-dadbod-completion' },
		{ name = 'calc' },
		{ name = 'emoji' },
		{ name = 'neorg' },
		-- { name = 'spell' },
		-- { name = 'dictionary', keyword_length = 2 },
		{ name = 'luasnip' },
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

