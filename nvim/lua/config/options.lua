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
