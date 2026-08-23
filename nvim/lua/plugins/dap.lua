return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"leoluz/nvim-dap-go",
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"jay-babu/mason-nvim-dap.nvim",
		},
		config = function()
			require("mason-nvim-dap").setup({
				ensure_installed = { "delve" },
				automatic_installation = true,
			})
			require("dap-go").setup()

			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup()

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			local map = vim.keymap.set
			map("n", "<F5>", dap.continue, { desc = "Debug: continue" })
			map("n", "<F10>", dap.step_over, { desc = "Debug: step over" })
			map("n", "<F11>", dap.step_into, { desc = "Debug: step into" })
			map("n", "<F12>", dap.step_out, { desc = "Debug: step out" })
			map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: toggle breakpoint" })
			map("n", "<leader>du", dapui.toggle, { desc = "Debug: toggle UI" })
			map("n", "<leader>dt", function()
				require("dap-go").debug_test()
			end, { desc = "Debug: nearest Go test" })
		end,
	},
}
