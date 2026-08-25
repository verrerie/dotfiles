return {
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				-- catppuccin ships per-flavour lualine themes (catppuccin-mocha etc),
				-- not a plain "catppuccin" -- asking for that warns on every startup.
				-- "auto" derives the palette from the active colorscheme.
				theme = "auto",
				component_separators = "|",
				section_separators = "",
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		},
	},
}
