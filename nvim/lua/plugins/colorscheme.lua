return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		opts = {
			flavour = "mocha",
			-- darker than stock mocha, so splits and floats read as distinct
			color_overrides = {
				mocha = {
					base = "#11111b",
					mantle = "#0b0b12",
					crust = "#050509",
				},
			},
		},
		config = function(_, opts)
			require("catppuccin").setup(opts)
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
