local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = " "

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.ignorecase = true
opt.smartcase = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 8
opt.wrap = false
opt.swapfile = false
opt.undofile = true

-- default indentation; go files override this in ftplugin/go.lua
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4

-- LSP servers installed outside mason (metals via coursier, Go tools via
-- `go install`) live in dirs a GUI-launched nvim doesn't inherit on PATH
if vim.fn.has("mac") == 1 or vim.fn.has("unix") == 1 then
	local extra_path = {
		vim.fn.expand("~/go/bin"),
		vim.fn.expand("~/Library/Application Support/Coursier/bin"),
	}
	for _, dir in ipairs(extra_path) do
		if vim.fn.isdirectory(dir) == 1 then
			vim.env.PATH = dir .. ":" .. vim.env.PATH
		end
	end
end

-- diagnostics: show the source only when more than one server reports
vim.diagnostic.config({
	virtual_text = { prefix = "●", source = "if_many" },
	float = { source = "if_many", border = "rounded" },
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
})

-- use Git Bash for :terminal on Windows (macOS/Linux already default to a
-- posix shell, so this is a no-op there)
if vim.fn.has("win32") == 1 then
	opt.shell = "C:\\Program Files\\Git\\bin\\bash.exe"
	opt.shellcmdflag = "-c"
	opt.shellxquote = ""
end
