-- local t = require('vim.treesitter')
-- nmap <localleader>ts :luafile ~/.config/nvim/lua/killerrat/treesitter-scratchpad/cs-public-methods.lua<CR>
local function i(value)
	print(vim.inspect(value))
end

local bufnr = vim.api.nvim_get_current_buf()
-- local lang = vim.api.nvim_buf_get_option(bufnr, 'filetype')
-- local lang = 'c_sharp'
-- get the treesitter language for the current buffer
local lang = 'typescript'

local lang_tree = vim.treesitter.get_parser(bufnr, lang)
local syntax_tree = lang_tree:parse()
local root = syntax_tree[1]:root()

-- local query = vim.treesitter.query.parse(lang, [[
--	(method_declaration
--		(modifier) @method-modifier (#eq? @method-modifier "public")
--		name: (identifier) @method-name
--	)
-- ]])

local query = vim.treesitter.query.parse(lang, [[
(jsx_self_closing_element
  name: (identifier) @component_name
  (#match? @component_name "TextField")
)

(jsx_opening_element
  name: (identifier) @component_name
  (#match? @component_name "TextField")
)
]])

-- (method_declaration (modifier) @modifier (#eq? @modifier "public"))

-- for _, captures, metadata in query:iter_matches(root, bufnr) do
--	i(captures)
--	i(captures[1])
--	i(captures[2])
--	-- q.get_node_text(captures.method_name, bufnr)
--	vim.treesitter.get_node_text(captures[2], bufnr)
--	-- i(vim.treesitter.get_node_text(captures[2], bufnr))
--	-- i(captures[2])
--
--	-- i(vim.treesitter.get_range(captures[2], bufnr))
--	-- i(metadata)
-- end

for pattern, match, metadata in query:iter_matches(root, bufnr) do
	print("The match: ")
	i(match)
	print ("The nodes: ")
	for id, nodes in pairs(match) do
		if id == 2 then
			i(vim.treesitter.get_node_text(nodes[1], bufnr))
		end
	end
end

