local p = "neorg"; if (not require('killerrat.plugins._lazy-nvim').LazyHasPlugin(p)) then return end

require(p).setup {
	load = {
		["core.defaults"] = {},
		["core.text-objects"] = {},
		["core.export"] = {},
		["core.export.markdown"] = {},
		["core.integrations.telescope"] = {},
		-- ["core.dirman"] = {
		-- 	config = {
		-- 		workspaces = {
		-- 			work = "~/notes/neorg/work"
		-- 			-- home = "~/notes/home",
		-- 		}
		-- 	}
		-- },
		["core.dirman"] = { -- https://github.com/nvim-neorg/neorg/wiki/Dirman
			config = {
				workspaces = {
					work = "~/notes/neorg/work", -- Format: <name_of_workspace> = <path_to_workspace_root>
					-- my_other_notes = "~/work/notes",
				},
				autochdir = true, -- Automatically change the directory to the current workspace's root every time
				index = "index.norg", -- The name of the main (root) .norg file
			}
		},
		["core.concealer"] = { config = {} },
		-- ["core.gtd.base"] = { -- https://github.com/nvim-neorg/neorg/wiki/Getting-Things-Done
		--	 config = {
		--		workspace = "work"
		--	 }
		-- },
		["core.completion"] = { -- https://github.com/nvim-neorg/neorg/wiki/Completion
			config = {
				engine = "nvim-cmp"
			},
		},
		-- NOT SURE IF I NEED THE BELOW WITH THE ABOVE CONFIGURED?
		["core.integrations.nvim-cmp"] = { -- https://github.com/nvim-neorg/neorg/wiki/Nvim-Cmp
			config = {}
		},
		["core.summary"] = { config = { strategy = "default" } },
		["core.neorgcmd"] = { config = {} },
		-- ["core.integrations.treesitter"] = {},
		-- ["core.ui"] = {},
		-- ["core.mode"] = {},
		-- ["core.queries.native"] = {},
		-- ["core.presenter"] = { config = { zen_mode = "zen-mode" } },

		-- https://github.com/nvim-neorg/neorg/wiki/Metagen
		['core.esupports.metagen'] = { config = { update_date = false } }, -- do not update date until https://github.com/nvim-neorg/neorg/issues/1579 fixed
	}
}


-- FROM : https://github.com/nvim-neorg/neorg-telescope
local neorg_callbacks = require("neorg.core.callbacks")
neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
	-- Map all the below keybinds only when the "norg" mode is active
	keybinds.map_event_to_mode("norg", {
		n = {
			-- { "<C-s>", "core.integrations.telescope.find_linkable" },
			{ "<localleader>ff", "core.integrations.telescope.find_linkable" },
		},

		i = {
			{ "<C-l>", "core.integrations.telescope.insert_link" },
		},
	}, {
			silent = true,
			noremap = true,
		})
	-- JUST USE CTRL+SPACE TO CYCLE, gtd, gtu, gtp, gtc, gti TO SET THE STATES
	-- keybinds.remap_event("norg", "n", "]d", "core.norg.qol.todo_items.todo.task_cycle")
	-- keybinds.remap_event("norg", "n", "[d", "core.norg.qol.todo_items.todo.task_cycle_reverse")
end)


-- FIND DEFAULT KEY BINDS HERE:
-- https://github.com/nvim-neorg/neorg/blob/main/lua/neorg/modules/core/keybinds/keybinds.lua

vim.keymap.set("n", "<leader>nw", "<cmd>Neorg workspace work<cr>")
vim.keymap.set("n", "<leader>nW", "<cmd>Neorg return<cr>")
-- vim.keymap.set("n", "<localleader>nc", "<cmd>Neorg toggle-concealer<cr>")

-- TEMP MAPPING FOR GTD BEFORE THEY RELEASE IT AGAIN
-- vim.keymap.set("n", "gtd", "0f[lrx")


-- vim.api.nvim_create_autocmd("FileType", {
--	pattern = "norg",
--	callback = function()
--		vim.schedule(function()
--			vim.keymap.set("n", "<localleader>ff", ":lua vim.lsp.buf.hover()<cr>")
--		end)
--	end,
--	group = vim.api.nvim_create_augroup("neorg.lua.telescope_find_linkable", { clear = true })
-- })


