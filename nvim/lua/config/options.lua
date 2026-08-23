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

-- use Git Bash for :terminal on Windows (macOS/Linux already default to a
-- posix shell, so this is a no-op there)
if vim.fn.has("win32") == 1 then
	opt.shell = "C:\\Program Files\\Git\\bin\\bash.exe"
	opt.shellcmdflag = "-c"
	opt.shellxquote = ""
end
