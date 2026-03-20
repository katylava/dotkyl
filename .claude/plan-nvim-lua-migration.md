# Plan: Migrate Neovim Config from Vimscript to Lua — COMPLETED

**Status:** Done (2026-03-16)

**Execute after:** plan-single-branch-dotfiles.md, plan-remove-old-version-managers.md

**If plan-remove-old-version-managers.md is complete, skip:**
- Phase 2: `vim.g.python3_host_prog` fix — asdf refs already removed
- `lib/085-versions.zsh` references — file already deleted

**If plan-nvim-zshrc.md is also complete (optional), skip:**
- Phase 4 optional step: terminal mapping change from `term://zsh -f` → `term://zsh` — already done

## Inventory of Current Config

### Files

- `nvim/init.vim` — main config (655 lines); the only entry point
- `nvim/after/ftplugin/javascript.vim` — sets `fo=cql` for JS buffers
- `nvim/colors/my-monokai.vim` — custom monokai colorscheme (not currently active; catppuccin used)
- `nvim/pcthemes/kyl.vim` — PaperColor theme overrides (not currently active)
- `nvim/syntax/apex.vim`, `ejs.vim`, `tinytower.vim`, `visualforce.vim` — custom syntax files

### Plugin Manager

vim-plug, installed at `nvim/autoload/plug.vim` (tracked in repo). Plugins install to `nvim/plugged/`.

### Notable Plugins (28 total)

| Plugin | Type |
|---|---|
| catppuccin/nvim, coder/claudecode.nvim, dlyongemallo/diffview.nvim, folke/snacks.nvim, nvim-tree/nvim-web-devicons | lua-native |
| All tpope plugins, lightline, fzf, ctrlp, nerdtree, coc.nvim, copilot.vim, signify, rainbow, etc. | vimscript |

Note: `ctrlp.vim` is configured but fzf is also present — ctrlp is a candidate for removal.

Three `lua << EOF` heredocs already exist in `init.vim` for catppuccin, diffview, and snacks/claudecode setup.

### Key Vimscript Functions in init.vim

- `FileDir()` — path abbreviation using vim-specific lookbehind `\(\<\)\@<!` — cannot be naively ported to Lua patterns; must use `vim.fn.substitute()` for that line
- Lightline component functions (9 total) — must remain globally accessible (called by name from vimscript)
- `DoWindowSwap()` / `WindowSwapping()` — two-step window buffer swap

## Migration Strategy: Incremental (Recommended)

A big-bang rewrite is high risk. `init.lua` can source existing `.vim` files via `vim.cmd("source ...")`, allowing section-by-section migration with a working config at each step.

### Plugin Manager: Switch to lazy.nvim

vim-plug has no native Lua configuration. lazy.nvim is the current standard, supports lazy-loading and lockfiles, and lets plugin `setup()` calls live next to their declarations. Switch during Phase 6.

Optional lua-native replacements to consider during migration:
- `lightline.vim` → `lualine.nvim`
- `vim-signify` → `gitsigns.nvim`
- `vim-indent-guides` → `indent-blankline.nvim`
- `nerdtree` → `nvim-tree.lua`
- `ctrlp.vim` → remove (fzf.vim already present)
- `coc.nvim` → native LSP — largest change; keep coc initially

## Phase-by-Phase Migration

### Phase 1: Switch Entry Point (zero-regression)

Create `nvim/init.lua`:
```lua
vim.cmd("source " .. vim.fn.stdpath("config") .. "/init.vim")
```
Test everything works identically. Commit.

### Phase 2: Migrate Options and Settings

Create `nvim/lua/options.lua`. Translate all `set` / `let g:` to `vim.opt.*` / `vim.g.*`.

```lua
vim.g.mapleader = "\\"
vim.opt.number = true
vim.opt.wrap = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.colorcolumn = { "80", "100" }
vim.opt.listchars = { space = "⋅", tab = "→ " }
vim.g.python3_host_prog = vim.fn.exepath("python3")  -- replace asdf shim ref
```

Replace the options section of `init.vim` with `lua require('options')`. Commit.

### Phase 3: Migrate Mappings

Create `nvim/lua/mappings.lua`. Use `vim.keymap.set()`.

Key patterns:
```lua
-- noremap (default behavior)
vim.keymap.set("n", "<C-j>", "<cmd>wincmd j<CR>", { silent = true })
vim.keymap.set("i", "jk", "<Esc>")
-- <Plug> maps need remap = true
vim.keymap.set("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true, remap = true })
-- user commands
vim.api.nvim_create_user_command("Q", "quit", {})
```

### Phase 4: Migrate Autocommands

Create `nvim/lua/autocommands.lua`.

```lua
local autocmd = vim.api.nvim_create_autocmd
autocmd("BufRead", { pattern = "*.gs", command = "set filetype=javascript" })
autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.foldmethod = "indent"
  end,
})
```

Note: trailing whitespace `match` calls have no direct Lua API — use `vim.cmd(...)` inside callbacks or keep in a sourced vimscript file.

### Phase 5: Migrate Functions

Create `nvim/lua/functions.lua`.

`FileDir()` — the `\(\<\)\@<!` lookbehind line must use `vim.fn.substitute()`:
```lua
function FileDir()
  local d = vim.fn.expand("%:p:h")
  d = d:gsub("/Users/kyl/", "")
  d = d:gsub("Library/Mobile Documents/com~apple~CloudDocs", "icloud")
  d = d:gsub("code/", ""):gsub("Work/", "")
  d = vim.fn.substitute(d, [[\(\<\)\@<![aeiou]], "", "g")  -- vim regex required here
  d = d:gsub("([a-zA-Z])%1", "%1")
  return d
end
```

Lightline functions must remain global (lightline calls them by name from vimscript). Either define as globals in Lua or keep the lightline block in vimscript until lightline is replaced.

Window swap — use module-local state:
```lua
local marked_win_num = -1
function WindowSwapping() ... end  -- global for keymap
```

### Phase 6: Switch Plugin Manager to lazy.nvim

1. Delete `nvim/autoload/plug.vim` from repo.
2. Remove `nvim/plugged/` from repo (`git rm -r nvim/plugged/`).
3. Create `nvim/lua/plugins.lua` with lazy.nvim bootstrap + plugin specs:

```lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- colorscheme first (high priority)
  { "catppuccin/nvim", name = "catppuccin", priority = 1000, config = function()
      require("catppuccin").setup({ transparent_background = true })
      vim.cmd.colorscheme("catppuccin-frappe")
  end },

  -- lazy-loaded by filetype
  { "chrisbra/csv.vim", ft = "csv" },

  -- vimscript plugin with g: config goes in init = function()
  { "kien/ctrlp.vim", init = function()
      vim.g.ctrlp_show_hidden = 1
      vim.g.ctrlp_custom_ignore = "node_modules|DS_Store|coverage"
  end },

  -- lua-native with inline setup
  { "dlyongemallo/diffview.nvim", config = function()
      require("diffview").setup({ enhanced_diff_hl = true })
  end },
  -- ... all other plugins
})
```

Run `:Lazy install` on first launch. Commit per plugin group.

### Phase 7: Consolidate Plugin Config

Move remaining `g:` plugin config out of `options.lua` and into each plugin's `init`/`config`
function in `plugins.lua`. Purely organizational.

### Phase 8: Cleanup

1. `init.vim` should now be empty — delete it.
2. `after/ftplugin/javascript.vim` → `after/ftplugin/javascript.lua`:
   `vim.opt_local.formatoptions = "cql"`
3. `colors/my-monokai.vim`, `pcthemes/kyl.vim` — unused, leave as vimscript.
4. `syntax/*.vim` — leave as vimscript; colorscheme/syntax files don't need to be Lua.
5. Remove remaining asdf references (see `plan-remove-old-version-managers.md`).

## Vimscript → Lua Quick Reference

| Vimscript | Lua |
|---|---|
| `set number` | `vim.opt.number = true` |
| `set nowrap` | `vim.opt.wrap = false` |
| `set ts=4 sw=4 expandtab ai` | `vim.opt.tabstop = 4; vim.opt.shiftwidth = 4; vim.opt.expandtab = true; vim.opt.autoindent = true` |
| `let g:foo = 1` | `vim.g.foo = 1` |
| `let s:foo = 1` | `local foo = 1` |
| `let mapleader='\'` | `vim.g.mapleader = "\\"` |
| `let $VAR='val'` | `vim.env.VAR = "val"` |
| `setlocal ts=2` | `vim.opt_local.tabstop = 2` |
| `nnoremap <silent> x y` | `vim.keymap.set("n", "x", "y", { silent = true })` |
| `nmap x <Plug>y` | `vim.keymap.set("n", "x", "<Plug>y", { remap = true })` |
| `command! Foo bar` | `vim.api.nvim_create_user_command("Foo", "bar", {})` |
| `autocmd BufRead *.x cmd` | `vim.api.nvim_create_autocmd("BufRead", { pattern = "*.x", command = "cmd" })` |
| `augroup x / autocmd! / augroup end` | `vim.api.nvim_create_augroup("x", { clear = true })` |
| `expand("%:p:h")` | `vim.fn.expand("%:p:h")` |
| `strftime('%H:%M')` | `os.date("%H:%M")` |
| `&filetype` | `vim.bo.filetype` |
| `&modified` | `vim.bo.modified` |
| `execute 'hi Foo guibg=' . var` | `vim.cmd("hi Foo guibg=" .. var)` |

**Lua pattern note:** Lua patterns use `%` as escape (not `\`), have no alternation, and no
lookahead/lookbehind. For complex vim regexes, use `vim.fn.substitute()`.

## Branch Strategy

All changes go on the single branch (see plan-single-branch-dotfiles.md).

## Recommended Commit Order

1. Phase 1 — init.lua sources init.vim (smoke test)
2. Phase 2 — options.lua (includes python provider fix + asdf removal)
3. Phase 4 — autocommands.lua
4. Phase 3 — mappings.lua
5. Phase 5 — functions.lua
6. Phase 6 — switch to lazy.nvim (largest; commit per plugin group)
7. Phase 7 — consolidate plugin config
8. Phase 8 — cleanup, delete init.vim
