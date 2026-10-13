return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			{
				"L3MON4D3/LuaSnip",
				-- jsregexp powers snippet variable/placeholder transformations;
				-- without it luasnip loads but silently skips them. Built from the
				-- vendored copy in deps/ with cc, so it needs no luarocks. No make
				-- on Windows, where the transformations are simply unavailable.
				build = vim.fn.has("win32") == 0 and "make install_jsregexp" or nil,
			},
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				-- gopls marks an item as "preselect"; without this cmp highlights it
				-- automatically and <CR> accepts it even though you never chose it.
				-- None = nothing is selected until you press <Tab>.
				preselect = cmp.PreselectMode.None,
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					-- select = false: <CR> stays a newline unless you deliberately
					-- <Tab>'d onto an item. With `true`, every newline typed while the
					-- popup happens to be open silently accepts the first suggestion.
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<Tab>"] = cmp.mapping.select_next_item(),
					["<S-Tab>"] = cmp.mapping.select_prev_item(),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}),
			})
		end,
	},
}
