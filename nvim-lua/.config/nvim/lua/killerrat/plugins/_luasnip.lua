local ls = require("luasnip")
local extras = require("luasnip.extras")
-- local s = ls.snippet
-- local sn = ls.snippet_node
-- local t = ls.text_node
-- local i = ls.insert_node
-- local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
-- local l = require("luasnip.extras").lambda
-- local rep = require("luasnip.extras").rep
-- local p = require("luasnip.extras").partial
-- local m = require("luasnip.extras").match
-- local n = require("luasnip.extras").nonempty
-- local dl = require("luasnip.extras").dynamic_lambda
-- local fmt = require("luasnip.extras.fmt").fmt
-- local fmta = require("luasnip.extras.fmt").fmta
-- local types = require("luasnip.util.types")
-- local conds = require("luasnip.extras.conditions")
-- local conds_expand = require("luasnip.extras.conditions.expand")

-- FROM: https://github.com/mawkler/nvim/blob/06cde9dbaedab2bb36c06025c07589c93d2c6d6b/lua/configs/luasnip.lua#L37-L50
local function uuid()
	local id, _ = vim.fn.system('uuidgen'):gsub('\n', '')
	return id
end

-- local function clipboad_oneline_node()
-- 	local clipboard, _ = vim.fn.getreg('+'):gsub('\n', ' ')
-- 	return clipboard
-- end

-- local luasnip_clipboard = function()
-- 	return ls.snippet(nil, ls.insert_node(1, clipboad_oneline_node()))
-- end




ls.setup{}
ls.add_snippets("all", {
	-- today time friendly
	ls.snippet("2dtf", { extras.partial(os.date, "%a %-d %b %Y %H:%M") }),
	-- today timestamp
	ls.snippet("2dt", { extras.partial(os.date, "%Y%m%d%H%M") }),
	-- today
	ls.snippet("2d", { extras.partial(os.date, "%-d %b %Y") }),
	ls.snippet("uuidgen", {
		ls.dynamic_node(1, function()
			return ls.snippet_node(nil,
				ls.text_node(uuid()))
		end)
	}),

	ls.snippet("meta-meet", {
		ls.text_node("* Meeting with "),
		ls.insert_node(1, "PERSON"),
		ls.text_node(" on "), extras.partial(os.date, "%a %-d %b %Y"),
		ls.text_node({"", "\t@meeting.meta"}),
		ls.text_node({"", "\tstarted: "}), extras.partial(os.date, "%a %-d %b %Y %H:%M"),
		ls.text_node({"", "\tend: END"}),
		ls.text_node({"", "\tattendees: "}), ls.insert_node(2, "ATTENDEES"),
		-- ls.text_node({"", "\tattendees: "}), extras.rep(1), ls.insert_node(2, ", "),
		-- ls.text_node({"", "\tattendees: "}), extras.rep(1), ls.insert_node(2, ", "),
		-- ls.insert_node(1, "PERSON"),
		ls.text_node({
			"",
			"\tsalnet task: ",
			"\t@end",
			"",
			"\t*Action Items:*",
			"\t- ( ) ",
			"",
			"\t*Notes:*",
			"  ",
		}),
		-- ls.insert_node(3, "NOTES"),
		ls.insert_node(3, "\t"),
		-- c(3, {
		-- 			t("public "),
		-- 			t("private "),
		-- 		}),
	}),
})

-- ls.add_snippets('markdown', {
-- 	ls.snippet({
-- 		trig = 'link',
-- 		name = 'hyperlink',
-- 		dscr = 'Hyperlink with the content in the clipboard'
-- 	}, {
-- 			ls.text_node '[', ls.insert_node(1, 'text'), ls.text_node ']',
-- 			ls.text_node '(', ls.dynamic_node(2, luasnip_clipboard), ls.text_node ') ',
-- 		})
-- })


-- FROM: https://www.reddit.com/r/neovim/comments/tbtiy9/comment/i0bje36/?utm_source=share&utm_medium=web2x&context=3
vim.keymap.set({ "i", "s" }, "<C-l>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end)
vim.keymap.set({ "i", "s" }, "<C-h>", function()
	if ls.choice_active() then
 ls.change_choice(-1)
 end
end)

