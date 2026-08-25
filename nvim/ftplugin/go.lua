vim.opt_local.expandtab = false
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4

-- `go build` errors into the quickfix list with jump-to-line. Discard the
-- binary so <leader>b doesn't drop one in the cwd every time -- go only
-- recognises the platform's own null device (os.DevNull), so "/dev/null" on
-- Windows is read as a real path and the build fails.
vim.cmd("compiler go")
local devnull = vim.fn.has("win32") == 1 and "NUL" or "/dev/null"
vim.bo.makeprg = "go build -o " .. devnull .. " ./..."

-- Runs `cmd` in a split rooted at the current file's directory. `./...` and `.`
-- resolve against nvim's cwd otherwise, which is not always the package dir.
local function run(cmd)
	-- If we're already in the terminal split (the normal re-run loop), hop back
	-- to the code window: `%` would otherwise expand to a term:// name.
	if vim.bo.buftype ~= "" then
		vim.cmd("wincmd p")
		if vim.bo.buftype ~= "" then
			vim.notify("No file window to run from", vim.log.levels.WARN)
			return
		end
	end
	if vim.bo.modified then
		vim.cmd("silent write")
	end
	local dir = vim.fn.expand("%:p:h")
	vim.cmd("vsplit | terminal cd " .. vim.fn.shellescape(dir) .. " && " .. cmd)
	vim.cmd("startinsert")
end

local opts = { buffer = true }
local function map(lhs, fn, desc)
	vim.keymap.set("n", lhs, fn, vim.tbl_extend("force", opts, { desc = desc }))
end

-- `go run .` builds the whole package. `go run %` compiles one file and fails
-- with "undefined: X" as soon as the package spans more than main.go.
map("<leader>g", function() run("go run .") end, "Go: run package")
map("<leader>T", function() run("go test -v -race ./...") end, "Go: test verbose + race")
map("<leader>t", function() run("go test ./...") end, "Go: test package")
map("<leader>b", function()
	if vim.bo.modified then
		vim.cmd("silent write")
	end
	vim.cmd("silent make")
	vim.cmd("copen")
end, "Go: build -> quickfix")
