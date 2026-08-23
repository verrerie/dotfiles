# dotfiles

Personal Neovim config, built around [lazy.nvim](https://github.com/folke/lazy.nvim), with Go
development set up out of the box (`gopls` via mason.nvim, treesitter, completion, format-on-save).
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
- `<leader>rn` / `<leader>ca` — rename / code action (LSP)
- `<leader>g` / `<leader>t` — go run current file / go test ./... (Go buffers only)
- `<F5>` / `<F10>` / `<F11>` / `<F12>` — debug: continue / step over / step into / step out
- `<leader>db` / `<leader>du` — toggle breakpoint / toggle debug UI
- `<leader>dt` — debug the nearest Go test
- Go files: imports are organized (goimports) and gofmt'd automatically on save.

## Go development

- LSP: `gopls` (installed automatically via mason.nvim)
- Debugging: `nvim-dap` + `nvim-dap-go`, backed by `delve` (also via mason.nvim)
- Syntax: treesitter (`go`, `gomod`, `gowork`, `gosum`)

## yazi

`yazi/yazi.toml` makes `o`/`Enter` open text/code files (go, lua, toml, yaml,
json, md, ...) in nvim instead of the OS default app. On Windows it always
runs `nvim` directly; on macOS/Linux it runs `$EDITOR`, so set that in your
shell rc (`export EDITOR=nvim`) for it to take effect there.

## Updating

Pull on whichever machine, relaunch `nvim`, run `:Lazy sync` if plugin versions changed.
