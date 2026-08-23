return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "gopls" },
			})

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- nvim-lspconfig just ships the default gopls config; nvim's
			-- native vim.lsp.config/enable (0.11+) does the actual setup.
			vim.lsp.config("gopls", {
				capabilities = capabilities,
				settings = {
					gopls = {
						gofumpt = true,
						staticcheck = true,
					},
				},
			})
			vim.lsp.enable("gopls")

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local opts = { buffer = args.buf }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				end,
			})

			-- goimports (organize imports) + gofmt on save
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.go",
				callback = function()
					local params = vim.lsp.util.make_range_params(0, "utf-8")
					params.context = { only = { "source.organizeImports" } }
					local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
					for _, res in pairs(result or {}) do
						for _, action in pairs(res.result or {}) do
							if action.edit then
								vim.lsp.util.apply_workspace_edit(action.edit, "utf-8")
							end
						end
					end
					vim.lsp.buf.format({ async = false })
				end,
			})
		end,
	},
}
