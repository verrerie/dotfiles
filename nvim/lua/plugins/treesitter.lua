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
			-- tree-sitter-cli's `build` shells out via Rust's `cc` crate, which
			-- defaults to cl.exe (MSVC) on Windows -- not installed here. zig
			-- doubles as a C compiler (`zig cc`); the cc crate honors CC as a
			-- command line, so this redirects it there instead.
			if vim.fn.has("win32") == 1 and vim.fn.executable("zig") == 1 then
				vim.env.CC = "zig cc"
			end

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
