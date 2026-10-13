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

-- Marksman supports MDX through this compound Markdown filetype.
vim.filetype.add({ extension = { mdx = "markdown.mdx" } })

-- Treesitter folds; a high foldlevel keeps every fold open when a file opens.
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

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

-- Use an existing JDK when GUI sessions only find macOS's Java launcher.
if vim.fn.has("macunix") == 1 and not vim.env.JAVA_HOME then
	local candidates = {
		vim.fn.expand("~/.sdkman/candidates/java/current"),
		"/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home",
		"/usr/local/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home",
	}
	for _, dir in ipairs(candidates) do
		if vim.fn.executable(dir .. "/bin/java") == 1 then
			vim.env.JAVA_HOME = dir
			vim.env.PATH = dir .. "/bin:" .. vim.env.PATH
			break
		end
	end
end

-- Mason installs npm-based servers (ts_ls, some dap adapters) with a plain
-- `npm install` and offers no registry setting, so it inherits ~/.npmrc.
-- When that file points the *default* registry at a private proxy behind a
-- short-lived token, every expiry turns into "failed to install ts_ls" (E401).
-- Pin nvim's npm to the public registry. Env beats both project and user
-- .npmrc in npm's config precedence, and scoped registries in a repo's own
-- .npmrc still win for their scopes.
vim.env.npm_config_registry = "https://registry.npmjs.org/"

-- Remote-plugin providers for languages nothing here uses. Unset, each one
-- reports a missing host package in :checkhealth; the hosts are only needed by
-- plugins written in those languages, and every plugin in lua/plugins is Lua.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

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

-- Directory browsing: a clean tree with a preview to its right.
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_preview = 1
vim.g.netrw_alto = 0
vim.g.netrw_winsize = 30
