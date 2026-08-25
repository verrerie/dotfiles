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
				-- metals is intentionally absent: it ships via coursier, not mason
				ensure_installed = { "gopls", "ts_ls" },
			})

			vim.lsp.config("*", {
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
			})

			-- nvim-lspconfig just ships the default gopls config; nvim's
			-- native vim.lsp.config/enable (0.11+) does the actual setup.
			vim.lsp.config("gopls", {
				-- drop "gotmpl" from nvim-lspconfig's defaults: nvim has no
				-- built-in detector for it, which trips a checkhealth warning
				filetypes = { "go", "gomod", "gowork", "gosum" },
				settings = {
					gopls = {
						gofumpt = true,
						staticcheck = true,
					},
				},
			})
			-- metals requires JDK 17 even when the default JDK is newer. Resolve it
			-- from sdkman rather than pinning a patch version, and leave cmd_env
			-- unset when there is no match so metals uses the ambient JAVA_HOME.
			local metals_env = nil
			local jdk17 = vim.fn.glob(vim.fn.expand("~/.sdkman/candidates/java/17.*"), false, true)
			if #jdk17 > 0 then
				table.sort(jdk17)
				metals_env = { JAVA_HOME = jdk17[#jdk17] }
			end

			vim.lsp.config("metals", {
				cmd = { "metals" },
				cmd_env = metals_env,
			})

			vim.lsp.enable({ "gopls", "ts_ls", "metals" })

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
					-- gopls reports utf-16; hardcoding utf-8 misplaces edits on any
					-- line containing non-ASCII before the edit point.
					local client = vim.lsp.get_clients({ bufnr = 0, name = "gopls" })[1]
					if not client then
						return
					end
					local enc = client.offset_encoding
					local params = vim.lsp.util.make_range_params(0, enc)
					params.context = { only = { "source.organizeImports" } }
					local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
					for _, res in pairs(result or {}) do
						for _, action in pairs(res.result or {}) do
							if action.edit then
								vim.lsp.util.apply_workspace_edit(action.edit, enc)
							end
						end
					end
					vim.lsp.buf.format({ async = false })
				end,
			})
		end,
	},
}
