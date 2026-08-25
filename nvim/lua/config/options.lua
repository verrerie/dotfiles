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
-- `go install`) live in dirs a GUI-launched nvim doesn't inherit on PATH.
-- Windows needs this too: Device Guard blocks mason's downloaded binaries
-- there, so `go install`-built tools in ~/go/bin are the working ones.
do
	local extra_path, sep
	if vim.fn.has("win32") == 1 then
		extra_path = { vim.fn.expand("~/go/bin") }
		sep = ";"
	else
		extra_path = {
			vim.fn.expand("~/go/bin"),
			vim.fn.expand("~/Library/Application Support/Coursier/bin"),
		}
		sep = ":"
	end
	for _, dir in ipairs(extra_path) do
		if vim.fn.isdirectory(dir) == 1 then
			vim.env.PATH = dir .. sep .. vim.env.PATH
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

-- use Git Bash for :terminal and :! on Windows (macOS/Linux already default to
-- a posix shell, so this whole block is skipped there)
--
-- Two things this has to get right:
--
--  1. Vim splits 'shell' on spaces to build the argv, so the bare path
--     C:\Program Files\Git\bin\bash.exe is read as the program "C:\Program"
--     with an argument "Files\Git\bin\bash.exe" -- hence "shell failed to
--     start: no such file or directory: C:\Program". The value must be quoted.
--
--  2. Only set it if the binary is actually there. Pointing 'shell' at a
--     missing path breaks *every* shell command in nvim with no fallback;
--     leaving it unset just means cmd.exe, which works.
if vim.fn.has("win32") == 1 then
	local candidates = {
		"C:\\Program Files\\Git\\bin\\bash.exe",
		"C:\\Program Files (x86)\\Git\\bin\\bash.exe",
		vim.fn.expand("$LOCALAPPDATA\\Programs\\Git\\bin\\bash.exe"),
	}
	-- deliberately not vim.fn.exepath("bash"): on Windows that usually resolves
	-- to C:\Windows\System32\bash.exe, which launches WSL, not Git Bash.
	for _, path in ipairs(candidates) do
		if vim.fn.executable(path) == 1 then
			vim.o.shell = '"' .. path .. '"'
			vim.o.shellcmdflag = "-c"
			vim.o.shellxquote = ""
			vim.o.shellquote = ""
			break
		end
	end
end
