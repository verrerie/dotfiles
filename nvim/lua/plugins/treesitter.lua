return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master", -- legacy stable API; "main" is a newer, incompatible rewrite
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"go", "gomod", "gowork", "gosum",
					"typescript", "tsx", "javascript",
					"scala",
					"lua", "vim", "vimdoc",
					"markdown", "markdown_inline",
				},
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
}
