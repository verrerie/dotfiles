return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master", -- legacy stable API; "main" is a newer, incompatible rewrite
		build = ":TSUpdate",
		config = function()
			-- markdown/markdown_inline deliberately excluded: their only job
			-- here was prettier hover-doc floats (bold/italic via conceal),
			-- but that's exactly the query that crashes K with "conceal_line
			-- ... attempt to call method 'range' (a nil value)" -- a legacy
			-- master-branch predicate bug against current Neovim. Without the
			-- parser, hover floats just render as plain text; no crash.
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"go", "gomod", "gowork", "gosum",
					"typescript", "tsx", "javascript",
					"scala",
					"lua", "vim", "vimdoc",
				},
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
}
