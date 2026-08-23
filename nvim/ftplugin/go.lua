vim.opt_local.expandtab = false
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4

local opts = { buffer = true }
vim.keymap.set("n", "<leader>g", "<cmd>vsplit | terminal go run %<cr>", vim.tbl_extend("force", opts, { desc = "Go: run file" }))
vim.keymap.set("n", "<leader>t", "<cmd>vsplit | terminal go test ./...<cr>", vim.tbl_extend("force", opts, { desc = "Go: test package" }))
