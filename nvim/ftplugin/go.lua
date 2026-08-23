vim.opt_local.expandtab = false
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4

local opts = { buffer = true }
vim.keymap.set("n", "<leader>gr", "<cmd>vsplit | terminal go run %<cr>", vim.tbl_extend("force", opts, { desc = "Go: run file" }))
vim.keymap.set("n", "<leader>gt", "<cmd>vsplit | terminal go test ./...<cr>", vim.tbl_extend("force", opts, { desc = "Go: test package" }))
