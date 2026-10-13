return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		opts = {
			flavour = "mocha",
			-- On nvim 0.12 auto-detection calls vim.pack.get(), which creates an
			-- empty site/pack/core and makes lazy's checkhealth warn. List the
			-- integrations for the plugins in lua/plugins instead.
			auto_integrations = false,
			integrations = {
				cmp = true,
				dap = true,
				dap_ui = true,
				gitsigns = true,
				mason = true,
				telescope = true,
			},
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
