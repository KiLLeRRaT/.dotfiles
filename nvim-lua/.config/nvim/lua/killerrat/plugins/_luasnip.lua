if not _G.plugin_loaded("LuaSnip") then
	print("LuaSnip not loaded")
	do return end
end

local ls = require("luasnip")
local s = ls.snippet
-- local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
-- local f = ls.function_node
local c = ls.choice_node
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

ls.setup{}

ls.add_snippets("all", {
	s("2dt", {
		t(os.date("%Y%m%d%H%M")),
	}),

	s("2d", {
		t(os.date("%-d %b %Y")),
	}),

	s("meta-meet", {
		t("** Meeting with "),
		i(1, "John Doe"),
		t(" on " .. os.date("%a %-d %b %Y")),
		t({
			"",
			"\t@meeting.meta",
			"\tstart: " .. os.date("%a %-d %b %Y %H:%M"),
			"\tend: " .. os.date("%a %-d %b %Y "),
			"\tattendees: ",
		}),
		i(2, "John Doe"),
		t({
			"",
			"\tsalnet task: ",
			"\t@end",
			"",
			"\tAction Items:",
			"",
		}),
		-- c(3, {
		-- 			t("public "),
		-- 			t("private "),
		-- 		}),
	}),
})

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

