# dotfiles

Personal Neovim config, built around [lazy.nvim](https://github.com/folke/lazy.nvim), with Go
development set up out of the box (`gopls` via mason.nvim, treesitter, completion, format-on-save),
plus TypeScript and Scala language servers.
Shared between machines (Windows desktop + Mac mini) via this repo.

## Layout

```
nvim/
  init.lua
  lua/config/     -- options, keymaps, lazy.nvim bootstrap
  lua/plugins/     -- one file per plugin/plugin-group
  ftplugin/go.lua  -- Go uses tabs, not spaces
```

## Install

Clone this repo, then link the `nvim/` folder into Neovim's config location.

**macOS / Linux:**

```bash
git clone https://github.com/<your-username>/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

**Windows (PowerShell):**

```powershell
git clone https://github.com/<your-username>/dotfiles.git $HOME\dotfiles
& "$HOME\dotfiles\install.ps1"
```

Then launch `nvim` — lazy.nvim will bootstrap itself and install all plugins on first run, and
mason.nvim will install `gopls` automatically.

## Keymaps

- Leader is `<Space>`
- `<leader>ff` / `<leader>fg` / `<leader>fb` — find files / live grep / buffers (Telescope)
- `gd` / `gr` / `K` — go to definition / references / hover (LSP)
- `<leader>rn` / `<leader>ca` — rename / code action (i.e. autofix a hint/warning/error, LSP)
- `]d` / `[d` — jump to next / previous diagnostic (hint, warning, or error)
- `gl` — show the diagnostic under the cursor in a float
- `<leader>g` / `<leader>t` — go run current file / go test ./... (Go buffers only)
- `<F5>` / `<F10>` / `<F11>` / `<F12>` — debug: continue / step over / step into / step out
- `<leader>db` / `<leader>du` — toggle breakpoint / toggle debug UI
- `<leader>dt` — debug the nearest Go test
- `]c` / `[c` — jump to next / previous git hunk (gitsigns)
- `<leader>hs` / `<leader>hr` / `<leader>hp` / `<leader>hb` — stage / reset / preview hunk, blame line
- Go files: imports are organized (goimports) and gofmt'd automatically on save.

## Language servers

| Language | Server | Installed via |
|---|---|---|
| Go | `gopls` | mason.nvim (automatic) |
| TypeScript / JavaScript | `ts_ls` | mason.nvim (automatic) |
| Scala | `metals` | coursier — `cs install metals` (**not** mason) |

`metals` needs JDK 17 even when your default JDK is newer; the config picks the highest
`~/.sdkman/candidates/java/17.*` it finds and falls back to the ambient `JAVA_HOME` if there
is none. `~/go/bin` and the coursier bin dir are prepended to `PATH` on unix so a
GUI-launched nvim still finds these binaries.

## Go development

- LSP: `gopls` (installed automatically via mason.nvim)
- Debugging: `nvim-dap` + `nvim-dap-go`, backed by `delve` (also via mason.nvim)
- Syntax: treesitter (`go`, `gomod`, `gowork`, `gosum`)

## Other plugins

- `gitsigns.nvim` — hunk signs in the gutter, stage/reset/preview/blame
- `lualine.nvim` — statusline (catppuccin theme, matches the colorscheme)

## yazi

`yazi/yazi.toml` makes `o`/`Enter` open text/code files (go, lua, toml, yaml,
json, md, ...) in nvim instead of the OS default app. On Windows it always
runs `nvim` directly; on macOS/Linux it runs `$EDITOR`, so set that in your
shell rc (`export EDITOR=nvim`) for it to take effect there.

`yazi/keymap.toml` rebinds `<Enter>` to descend into the highlighted directory.

## Updating

Pull on whichever machine, relaunch `nvim`, run `:Lazy sync` if plugin versions changed.
