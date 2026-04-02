# Plan: Migrate Neovim Config from Vimscript to Lua

**Branch:** `nvim-lua-wip` (based on main + first attempt at migration)
**Rollback tag:** `pre-nvim-lua` (main before any lua changes)

## What's Done (on nvim-lua-wip)

- Switched entry point to `init.lua`
- Switched plugin manager from vim-plug to lazy.nvim
- Replaced lightline with lualine (catppuccin dropped lightline support)
- Converted all config to Lua, then moved options and mappings back to vimscript
- Added `.gitignore` for `lazy-lock.json`
- Fixed git-cleanup script for multi-level branch names (cherry-picked to main)

## Current File Layout (on nvim-lua-wip)

```
nvim/init.lua                    -- entry point, sources everything below
nvim/init/options.vim            -- vim options (vimscript)
nvim/init/functions.lua          -- FileDir, ApplyDark/Light, WindowSwapping, ConflictsHighlight
nvim/init/plugins.lua            -- lazy.nvim bootstrap + all plugin specs
nvim/init/autocommands.lua       -- filetype detection, filetype settings, whitespace, CoC
nvim/init/mappings.vim           -- key mappings + CoC mappings (vimscript)
nvim/after/syntax/nerdtree.vim   -- workaround for devicons bracket concealment
nvim/after/ftplugin/javascript.lua
```

## Lessons Learned

### Keep options and mappings as vimscript
Vimscript is far more concise for `set` commands and mappings. Compare:
```vim
autocmd FileType markdown   set tw=79 ts=2 sw=2 comments=n:> wrap
```
vs 8 lines of Lua with `vim.opt_local`. Not worth converting.

### Keep functions as Lua
Converting functions.lua to vimscript broke things because plugins.lua calls
functions like `ApplyDark()`, `ApplyLight()`, and `FileDir()` as Lua globals.
Wrapping every call with `vim.fn.FunctionName()` is fragile and we lost nerdtree
icons in the process. Functions that are called from Lua should stay in Lua.

### Autocommands: keep as Lua for now
Converting autocommands.lua to vimscript also broke nerdtree icons through an
unknown mechanism. The vimscript version was functionally identical but something
about loading it differently caused issues. Not worth debugging — keep as Lua.

### catppuccin dropped lightline support
The catppuccin plugin no longer ships a lightline colorscheme file. Replaced
lightline with lualine. Use `theme = "auto"` (not `theme = "catppuccin"` — that
name doesn't exist; flavour-specific names like `catppuccin-frappe` do).

### lualine's fileformat icon for "unix" is Tux (the Linux penguin)
Not a bug, just surprising.

### lazy.nvim load order causes issues with vimscript plugins
- **devicons + nerdtree:** devicons registers `FileType nerdtree` autocmds to
  conceal brackets around icons. With lazy.nvim, nerdtree can trigger that
  FileType event before devicons registers its autocmds, so the conceal rules
  never fire. Fixed with `after/syntax/nerdtree.vim` that applies the rules
  directly.
- **catppuccin + lualine:** catppuccin's `config` runs before lualine loads, so
  `ApplyDark()`/`ApplyLight()` can't refresh lualine. Not an issue — lualine
  picks up `background` changes automatically.

### lazy-lock.json not worth syncing
For a single-user setup, the lockfile adds friction (must run `:Lazy sync` after
pulling) with little benefit. `.gitignore` it.

### Loading files from init.lua
Use `vim.cmd("source ...")` for `.vim` files and `vim.cmd("luafile ...")` for
`.lua` files. All config files live in `nvim/init/`, not `nvim/lua/`. Don't use
`require()` — it only works with `lua/` and we don't want that directory.

## Remaining Work (must complete before merging)

- [ ] **nerdtree → nvim-tree.lua** (+ vim-devicons → nvim-web-devicons).
      This eliminates the bracket conceal workaround entirely.
- [ ] **ctrlp → telescope.nvim** (or remove, since fzf is already present)
- [ ] **vim-signify → gitsigns.nvim**
- [ ] **vim-indent-guides → indent-blankline.nvim**
- [ ] **vim-polyglot → nvim-treesitter**
- [ ] **coc.nvim → nvim-lspconfig + nvim-cmp** (largest change)
- [ ] Mouse/cursor behavior in neovim command area changed — couldn't select
      error messages or copy text from the command line. Need to investigate.
- [ ] Remove old `nvim/autoload/` directory (contains `plug.vim.old`, never tracked)
- [ ] Decide if `nvim/lua/` directory is still needed (currently empty)
- [ ] Update plan-nvim-zshrc.md reference (terminal mappings are in mappings.vim now)
