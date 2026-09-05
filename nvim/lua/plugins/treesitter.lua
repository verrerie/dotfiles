local filetypes = {
	"go", "gomod", "gowork", "gosum",
	"typescript", "tsx", "javascript",
	"scala",
	"lua", "vim", "vimdoc",
	"markdown", "markdown_inline",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main", -- "master" is archived/frozen and drifted out of sync
		-- with current Neovim core (broke K's hover float via a stale
		-- conceal query predicate); "main" is the actively maintained rewrite.
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter").setup({
				install_dir = vim.fn.stdpath("data") .. "/site",
			})
			-- install() is async; without :wait() the FileType autocmd below
			-- can fire vim.treesitter.start() before a parser finishes
			-- downloading/compiling on first run, and start() hard-errors.
			require("nvim-treesitter").install(filetypes):wait(300000)
		end,
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = filetypes,
				callback = function()
					vim.treesitter.start()
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},
}
