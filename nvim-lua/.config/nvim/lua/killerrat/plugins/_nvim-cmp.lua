
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
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-u>'] = cmp.mapping.scroll_docs(4),
		['<C-n>'] = cmp.mapping(function(_)
			if cmp.visible() then
				-- Do not replace word under cursor
				cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			end
		end, { 'i', 's' }),
		['<C-p>'] = cmp.mapping(function(_)
			if cmp.visible() then
				-- Do not replace word under cursor
				cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
			elseif luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			end
		end, { 'i', 's' }),




		-- THIS SEEMS TO TRIP OUT TELESCOPES TAB KEY SOMEHOW..... JUST TESTING TO SEE IF ITS TRUE, 11
		-- Jan 2025
		-- -- FROM: https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
		-- -- ['<Tab>'] = cmp.mapping.select_next_item(),
		-- ["<Tab>"] = cmp.mapping(function(fallback)
		-- 	if cmp.visible() then
		-- 		print("nvim-cmp: cmd.visible() is true")
		-- 		cmp.select_next_item()
		-- 	elseif luasnip.expand_or_jumpable() then
		-- 		print("nvim-cmp: luasnip.expand_or_jumpable() is true")
		-- 		luasnip.expand_or_jump()
		-- 	elseif has_words_before() then
		-- 		print("nvim-cmp: has_words_before() is true")
		-- 		cmp.complete()
		-- 	else
		-- 		print("nvim-cmp: fallback() is true")
		-- 		fallback()
		-- 	end
		-- end, { "i", "s" }),
-- THIS SEEMS TO TRIP OUT TELESCOPES TAB KEY SOMEHOW..... JUST TESTING TO SEE IF ITS TRUE, 11
-- Jan 2025

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
			-- Copilot.vim
			-- vim.api.nvim_feedkeys(vim.fn['copilot#Accept'](vim.api.nvim_replace_termcodes('<Tab>', true, true, true)), 'n', true)

			-- Copilot.lua
			-- FROM: https://github.com/zbirenbaum/copilot.lua/issues/91#issuecomment-1345190310
			require("copilot.suggestion").accept()
		end),
		['<C-L>'] = cmp.mapping(function(fallback)
			require("copilot.suggestion").accept_word()
		end)
	},
	sources = {
		-- https://www.reddit.com/r/neovim/comments/zkj1d8/comment/j011kdn
		-- { name = 'nvim_lsp', keyword_length = 6, group_index = 1, max_item_count = 30 }
		-- { name = 'nvim_lsp', keyword_length = 3, max_item_count = 30 },
		{ name = 'nvim_lsp', keyword_length = 3 },
		{ name = 'path', keyword_length = 3, max_item_count = 30 },
		-- { name = "buffer" }, -- CURRENT BUFFER ONLY
		{ -- ALL BUFFERS
			name = 'buffer', keyword_length = 4, max_item_count = 30,
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
		{ name = 'emoji', keyword_length = 2 },
		{ name = 'neorg', keyword_length = 3, max_item_count = 30},
		-- { name = 'spell' },
		-- { name = 'dictionary', keyword_length = 1, max_item_count = 30 },
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
				luasnip = "[SNIP]",
				-- dictionary = "[DICT]"
				-- neorg = "[Neorg]",
			})[entry.source.name]

			return item
		end,
	},
}

-- require("cmp_dictionary").setup({
-- 	paths = { "/usr/share/dict/words" },
-- 	exact_length = 2,
-- 	first_case_insensitive = true,
-- 	-- document = {
-- 	-- 	enable = true,
-- 	-- 	command = { "wn", "${label}", "-over" },
-- 	-- },
-- })

-- Setup up vim-dadbod
cmp.setup.filetype({ "sql" }, {
	sources = {
		{ name = "vim-dadbod-completion" },
		{ name = "buffer" },
	}
})
