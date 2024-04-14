require("silicon").setup({
	-- Configuration here, or leave empty to use defaults
	-- font = "VictorMono NF=34;Noto Emoji=34"
	font = "CaskaydiaCoveNerdFontMono=16",
	theme = "Dracula",
	to_clipboard = true,
	pad_horiz = 16,
	pad_vert = 16,
	-- if the shadow below the os window should have be blurred
	shadow_blur_radius = 12,
	-- the offset of the shadow in x and y directions
	shadow_offset_x = 6,
	shadow_offset_y = 6,
	no_window_controls = true,
	-- background_image = "/home/albert/.dotfiles/images/Img-2.png",
	output = function()
		return "~/Pictures/screenshots/" .. os.date("!%Y-%m-%dT%H-%M-%S") .. "_nvim-silicon.png"
	end
})
