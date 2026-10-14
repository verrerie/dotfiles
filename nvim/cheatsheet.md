# Neovim cheatsheet

The leader key is `<Space>`. An edit has the form verb + object: learn the objects once, and they work with every verb.

## Edit with operators and text objects

| Keys | Action |
|---|---|
| `ci"` / `ca(` / `cit` | Change the text in quotes / the parentheses and their content / the text in an HTML tag |
| `dap` / `yip` | Delete a paragraph / yank the text of a paragraph |
| `.` | Repeat the last change |
| `*` then `cgn` then `.` | Change the next match of the word under the cursor, one match at a time |
| `<C-v>` … `I` / `A` | Visual block: insert at the start / append at the end of many lines |
| `gv` | Select the last selection again |
| `o` (visual) | Move to the other end of the selection |
| `g<C-a>` (visual) | Change a column of `0`s into the sequence 1, 2, 3 … |

## Move

| Keys | Action |
|---|---|
| `<C-o>` / `<C-i>` | Go back / forward in the jump list, across files |
| `g;` / `g,` | Go to the previous / next change location |
| `gi` | Go to the last insert location and start insert mode |
| `mA` … `'A` | Set / go to a global mark (a capital letter works from any file) |
| `%` | Go to the matching bracket |
| `gf` / `gx` | Open the file path / the URL under the cursor |

## Act on many lines and files

| Command | Action |
|---|---|
| `:g/pat/d` | Delete every line that matches `pat` |
| `:g/pat/norm A;` | Append `;` to every line that matches |
| `:v/pat/d` | Delete every line that does not match |
| `:%s//new/g` | Replace the last search pattern (from `*` or `/`) |
| `qa` … `q` | Record a macro in register `a` |
| `@a` / `@@` | Run macro `a` / run the last macro again |
| `:'<,'>norm @a` | Run macro `a` on every selected line |

Replace in many files:

1. Search with `<leader>fg`.
2. Push `<C-q>` to send all results to the quickfix list.
3. Run `:cdo s/old/new/g | update`.

`]q` / `[q` go to the next / previous quickfix entry.

## Registers

`clipboard=unnamedplus` is on, so a delete overwrites the last yank.

| Keys | Action |
|---|---|
| `"0p` | Paste the last yank. A delete does not change register `0`. |
| `<C-r>"` (insert or command line) | Paste the unnamed register |
| `<C-r><C-w>` (command line) | Insert the word under the cursor, e.g. `:%s/<C-r><C-w>/new/g` |

## LSP

Built in since Neovim 0.11:

| Keys | Action |
|---|---|
| `grr` | References |
| `gri` | Implementation |
| `grt` | Type definition |
| `grn` / `<leader>rn` | Rename |
| `gra` / `<leader>ca` | Code action |
| `gO` | Document symbols |
| `K` | Hover |
| `<C-s>` (insert) | Signature help |
| `]d` / `[d` / `gl` | Next / previous diagnostic, show the diagnostic at the cursor |

## Telescope

| Keys | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fw` | Grep the word under the cursor |
| `<leader>fb` | Buffers |
| `<leader>fr` | Open the last picker again, with its query |
| `<leader>fh` | Help tags |
| `<C-q>` (in a picker) | Send all results to the quickfix list |

## Folds (Treesitter)

| Keys | Action |
|---|---|
| `zc` / `zo` / `za` | Close / open / toggle the fold at the cursor |
| `zM` / `zR` | Close / open all folds |

## Files and netrw

| Keys | Action |
|---|---|
| `<leader>e` / `<leader>E` | Open the file tree at the current folder / at a folder you type |
| `h` / `l` (netrw) | Go to the parent folder / expand a folder or open a file |
| `<leader>yp` | Copy the path of the netrw entry under the cursor, or of the current file |
| `:let @+ = b:netrw_curdir` (netrw) | Copy the path of the folder that netrw shows |

## Windows

| Keys | Action |
|---|---|
| `<C-h/j/k/l>` | Go to the window on the left / below / above / on the right |
| `<C-w>o` | Close all other windows |
| `<C-w>=` | Make all windows equal |
| `<C-w>T` | Move the window to a new tab |

## Undo and diagnosis

| Command | Action |
|---|---|
| `u` / `<C-r>` | Undo / redo |
| `:earlier 10m` / `:later 5m` | Move the file back / forward in time. `undofile` keeps this after a restart. |
| `:verbose map <leader>e` | Show which file sets a key map |
| `:checkhealth` | Find problems in the setup |
| `:Tutor` | Run the built-in tutorial |

## How to practise

- Learn 2 new commands each week. Use only those 2 until they become automatic.
- When you push `j` or `x` many times, stop. Look for a motion or a text object that does the same work.
