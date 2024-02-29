-- require("gx").setup {
-- 	open_browser_app = "os_specific", -- specify your browser app; default for macOS is "open", Linux "xdg-open" and Windows "powershell.exe"
-- 	open_browser_args = { "--background" }, -- specify any arguments, such as --background for macOS' "open".
-- 	handlers = {
-- 		plugin = true, -- open plugin links in lua (e.g. packer, lazy, ..)
-- 		github = true, -- open github issues
-- 		brewfile = true, -- open Homebrew formulaes and casks
-- 		package_json = true, -- open dependencies from package.json
-- 		search = true, -- search the web/selection on the web if nothing else is found
-- 	},
-- 	handler_options = {
-- 		search_engine = "google", -- you can select between google, bing, duckduckgo, and ecosia
-- 		-- search_engine = "https://search.brave.com/search?q=", -- or you can pass in a custom search engine
-- 	},
-- }

vim.keymap.set({"n", "x"}, "gx", "<cmd>Browse<cr>")

