local map = vim.keymap.set

map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
map("n", "<leader>e", function()
	-- An explicit path resets a tree cached from a previously browsed directory.
	local dir = vim.bo.filetype == "netrw" and vim.b.netrw_curdir or vim.fn.expand("%:p:h")
	vim.cmd("Explore " .. vim.fn.fnameescape(dir))
	vim.cmd("Ntree " .. vim.fn.fnameescape(dir))
end, { desc = "File explorer" })

-- window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- diagnostics (hints, warnings, errors all use these; gl shows whichever
-- diagnostic is under the cursor, ]d/[d jump to the next/previous one)
map("n", "]d", function()
	vim.diagnostic.jump({ count = 1 })
end, { desc = "Next diagnostic" })
map("n", "[d", function()
	vim.diagnostic.jump({ count = -1 })
end, { desc = "Previous diagnostic" })
map("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostic at cursor" })

-- Keep directory navigation local to netrw; code retains normal h/l motions.
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("NetrwUX", { clear = true }),
	pattern = "netrw",
	callback = function(args)
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.cursorline = true
		vim.opt_local.signcolumn = "no"
		vim.keymap.set("n", "h", "-", {
			buffer = args.buf, remap = true, silent = true, nowait = true,
			desc = "Directory: parent",
		})
		vim.keymap.set("n", "l", "<CR>", {
			buffer = args.buf, remap = true, silent = true, nowait = true,
			desc = "Directory: expand or open",
		})
	end,
})

-- Keep the explorer width when temporary result windows open or close.
-- Restore the prior window option when the explorer is replaced by a file.
vim.api.nvim_create_autocmd({ "FileType", "BufWinEnter" }, {
	group = "NetrwUX",
	callback = function()
		local previous = vim.w.explorer_previous_winfixwidth
		if vim.bo.filetype == "netrw" then
			if previous == nil then
				vim.w.explorer_previous_winfixwidth = vim.wo.winfixwidth
			end
			vim.wo.winfixwidth = true
		elseif previous ~= nil then
			vim.wo.winfixwidth = previous
			vim.w.explorer_previous_winfixwidth = nil
		end
	end,
})
