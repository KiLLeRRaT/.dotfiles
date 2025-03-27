local p = "copilot"; if (not require('killerrat.plugins._lazy-nvim').LazyHasPlugin(p)) then return end

require('copilot').setup({
  panel = {
    enabled = true,
    auto_refresh = false,
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept = "<CR>",
      refresh = "gr",
      open = "<M-CR>"
    },
    layout = {
      position = "bottom", -- | top | left | right | horizontal | vertical
      ratio = 0.4
    },
  },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    hide_during_completion = true,
    debounce = 75,
		-- IMPORTANT: THIS NEEDS TO BE SET UP IN nvim_cmp.lua!
    keymap = {
      -- accept = "<M-l>",
			-- accept = "<C-Y>",
      -- accept_word = false,
			-- accept_word = "<C-Y>",
      -- accept_line = false,
		-- IMPORTANT: THIS NEEDS TO BE SET UP IN nvim_cmp.lua!
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  },
  filetypes = {
    yaml = true,
    markdown = true,
    help = false,
    gitcommit = true,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ["."] = false,
  },
  copilot_node_command = 'node', -- Node.js version must be > 18.x
  server_opts_overrides = {},
})
