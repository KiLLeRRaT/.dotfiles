require("better_escape").setup {
		timeout = vim.o.timeoutlen,
		default_mappings = false,
		mappings = {
				i = {
						j = {
								-- These can all also be functions
								k = "<Esc>",
								j = "<Esc>",
						},
				},
				c = {
						j = {
								k = "<Esc>",
								j = "<Esc>",
						},
				},
				t = {
						j = {
								k = "<Esc>",
								j = "<Esc>",
						},
				},
				-- v = {
				-- 		j = {
				-- 				k = "<Esc>",
				-- 		},
				-- },
				s = {
						j = {
								k = "<Esc>",
						},
				},
		},
}
