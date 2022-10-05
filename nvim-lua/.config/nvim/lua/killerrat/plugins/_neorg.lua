if not _G.plugin_loaded("neorg") then
	print("neorg not loaded")
	do return end
end

require('neorg').setup {
		load = {
				["core.defaults"] = {},
				["core.norg.dirman"] = {
						config = {
								workspaces = {
										work = "~/GBox/Notes/neorg/work"
										-- home = "~/notes/home",
								}
						}
				},
				["core.norg.concealer"] = {
					 config = { -- Note that this table is optional and doesn't need to be provided
							 -- Configuration here
					 }
				},
				["core.gtd.base"] = { -- https://github.com/nvim-neorg/neorg/wiki/Getting-Things-Done
					 config = { -- Note that this table is optional and doesn't need to be provided
					 	workspace = "work"
							 -- Configuration here
					 }
				},
				["core.norg.completion"] = { -- https://github.com/nvim-neorg/neorg/wiki/Completion
					config = { -- Note that this table is optional and doesn't need to be provided
						engine = "nvim-cmp"
					-- Configuration here
				},
				-- NOT SURE IF I NEED THE BELOW WITH THE ABOVE CONFIGURED?
				["core.integrations.nvim-cmp"] = { -- https://github.com/nvim-neorg/neorg/wiki/Nvim-Cmp
					 config = { -- Note that this table is optional and doesn't need to be provided
							 -- Configuration here
					 }
				},
				["core.norg.dirman"] = { -- https://github.com/nvim-neorg/neorg/wiki/Dirman
					config = {
						workspaces = {
							work = "~/GBox/Notes/neorg/work", -- Format: <name_of_workspace> = <path_to_workspace_root>
							-- my_other_notes = "~/work/notes",
						},
						autochdir = true, -- Automatically change the directory to the current workspace's root every time
						index = "index.norg", -- The name of the main (root) .norg file
					}
				}
			}
		}
}
