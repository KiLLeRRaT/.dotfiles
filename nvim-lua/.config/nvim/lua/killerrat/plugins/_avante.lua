local p = "avante.nvim"; if (not require('killerrat.plugins._lazy-nvim').LazyHasPlugin(p)) then return end

-- require('avante_lib').load()
local api_key_name = "cmd:secret-tool lookup xdg:schema com.google.gemini"
if vim.fn.has('win32') == 1 or vim.fn.executable("secret-tool") == 0 then
	--api_key_name = "cmd:$(Get-StoredCredential -Target com.google.gemini -AsCredentialObject).Password"
	api_key_name = ""
else
-- Use shell to run secret-tool lookup command, if error is returned, then set api_key_name to empty string.
	local handle = io.popen("secret-tool lookup xdg:schema com.google.gemini 2>/dev/null")
	local result = handle:read("*a")
	handle:close()
	if result == "" then
		api_key_name = ""
	end
end


require('avante').setup ({
	---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
	-- provider = "copilot", -- Recommend using Claude
	provider = "gemini", -- Recommend using Claude
	providers = {
		gemini = {
			api_key_name = api_key_name,
			endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
			-- model = "gemini-2.0-flash",
			model = "gemini-2.5-pro",
			timeout = 30000, -- Timeout in milliseconds
			extra_request_body = {
				temperature = 0,
				max_output_tokens = 8192,
			},
		},
	},
	-- WARNING: Since auto-suggestions are a high-frequency operation and therefore expensive,
	-- currently designating it as `copilot` provider is dangerous because: https://github.com/yetone/avante.nvim/issues/1048
	-- Of course, you can reduce the request frequency by increasing `suggestion.debounce`.
	-- auto_suggestions_provider = "claude",
	-- claude = {
	--   endpoint = "https://api.anthropic.com",
	--   model = "claude-3-5-sonnet-20241022",
	--   temperature = 0,
	--   max_tokens = 4096,
	-- },
	---Specify the special dual_boost mode
	---1. enabled: Whether to enable dual_boost mode. Default to false.
	---2. first_provider: The first provider to generate response. Default to "openai".
	---3. second_provider: The second provider to generate response. Default to "claude".
	---4. prompt: The prompt to generate response based on the two reference outputs.
	---5. timeout: Timeout in milliseconds. Default to 60000.
	---How it works:
	--- When dual_boost is enabled, avante will generate two responses from the first_provider and second_provider respectively. Then use the response from the first_provider as provider1_output and the response from the second_provider as provider2_output. Finally, avante will generate a response based on the prompt and the two reference outputs, with the default Provider as normal.
	---Note: This is an experimental feature and may not work as expected.
	dual_boost = {
		enabled = false,
		first_provider = "openai",
		second_provider = "claude",
		prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
		timeout = 60000, -- Timeout in milliseconds
	},
	behaviour = {
		auto_suggestions = false, -- Experimental stage
		auto_set_highlight_group = true,
		auto_set_keymaps = true,
		auto_apply_diff_after_generation = false,
		support_paste_from_clipboard = false,
		minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
		enable_token_counting = true, -- Whether to enable token counting. Default to true.
	},
	mappings = {
		--- @class AvanteConflictMappings
		diff = {
			ours = "co",
			theirs = "ct",
			all_theirs = "ca",
			both = "cb",
			cursor = "cc",
			next = "]x",
			prev = "[x",
		},
		suggestion = {
			accept = "<M-l>",
			next = "<M-]>",
			prev = "<M-[>",
			dismiss = "<C-]>",
		},
		jump = {
			next = "]]",
			prev = "[[",
		},
		submit = {
			normal = "<CR>",
			insert = "<C-s>",
		},
		sidebar = {
			apply_all = "A",
			apply_cursor = "a",
			switch_windows = "<Tab>",
			reverse_switch_windows = "<S-Tab>",
		},
	},
	hints = { enabled = true },
	windows = {
		---@type "right" | "left" | "top" | "bottom"
		position = "right", -- the position of the sidebar
		wrap = true, -- similar to vim.o.wrap
		width = 30, -- default % based on available width
		sidebar_header = {
			enabled = true, -- true, false to enable/disable the header
			align = "center", -- left, center, right for title
			rounded = true,
		},
		input = {
			prefix = "> ",
			height = 8, -- Height of the input window in vertical layout
		},
		edit = {
			border = "rounded",
			start_insert = true, -- Start insert mode when opening the edit window
		},
		ask = {
			floating = false, -- Open the 'AvanteAsk' prompt in a floating window
			start_insert = true, -- Start insert mode when opening the ask window
			border = "rounded",
			---@type "ours" | "theirs"
			focus_on_apply = "ours", -- which diff to focus after applying
		},
	},
	highlights = {
		---@type AvanteConflictHighlights
		diff = {
			current = "DiffText",
			incoming = "DiffAdd",
		},
	},
	--- @class AvanteConflictUserConfig
	diff = {
		autojump = true,
		---@type string | fun(): any
		list_opener = "copen",
		--- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen).
		--- Helps to avoid entering operator-pending mode with diff mappings starting with `c`.
		--- Disable by setting to -1.
		override_timeoutlen = 500,
	},
	suggestion = {
		debounce = 600,
		throttle = 600,
	},
})
