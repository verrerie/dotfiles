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

			-- The master branch is frozen at Neovim 0.11's query API, where a
			-- directive got `match[id]` as a single node. Neovim 0.12 always
			-- passes a *list* of nodes, so the old handler calls `node:range()`
			-- on a plain table -- which is the error that fires on the first `K`
			-- (hover docs are markdown, and markdown's injection query uses this
			-- directive for fenced code blocks):
			--   Decoration provider "conceal_line" ...
			--   treesitter.lua:197: attempt to call method 'range' (a nil value)
			-- Re-register it, unwrapping the list. Same body as upstream otherwise.
			require("nvim-treesitter.query_predicates")
			local aliases = { ex = "elixir", pl = "perl", sh = "bash", uxn = "uxntal", ts = "typescript" }
			require("vim.treesitter.query").add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
				local node = match[pred[2]]
				if type(node) == "table" then
					node = node[#node]
				end
				if not node then
					return
				end
				local alias = vim.treesitter.get_node_text(node, bufnr):lower()
				metadata["injection.language"] = vim.filetype.match({ filename = "a." .. alias })
					or aliases[alias]
					or alias
			end, { force = true })
		end,
	},
}
