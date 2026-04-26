# Plan: Migrate Neovim Config from Vimscript to Lua (v2)

Second attempt. The first attempt (`nvim-lua-wip` branch) is preserved as
reference; its post-mortem lives in `plan-nvim-lua-migration.md` (deprecated).

**Branch:** `nvim-lua-v2` (fresh, off current `main`)
**Rollback tag:** `pre-nvim-lua` (already exists from attempt 1)

## Session resumption

This work spans multiple sessions. At the start of every session working on
this plan, Claude must:

1. **Read this entire plan file.** The Progress checklist and Decisions log
   below are the source of truth for what's done and what was decided.
2. **Verify branch state.**
   - `git branch --show-current` — should be `nvim-lua-v2` (or create it if
     missing and Progress shows step 1 not done)
   - `git log --oneline main..HEAD` — confirms which step commits exist; cross-
     check against the Progress checklist
   - `git status` — must be clean before starting new work
3. **Sync with `main`.** Katy's other machine may have pushed new commits.
   - `git fetch origin`
   - `git log --oneline HEAD..origin/main` — list all new commits on main. If
     none, skip the rest of this step.
   - `git log --oneline HEAD..origin/main -- nvim/` — list specifically the
     nvim changes. These are the ones likely to need manual porting because
     `init.vim` is deleted on this branch.
   - `git merge origin/main` — always merge in any new main commits. Non-nvim
     changes flow in normally. Nvim conflicts (most likely in `init.vim`):
     for each, port the change to the appropriate file in the new layout
     (`init/mappings.vim`, `init/plugins.lua`, etc.) and record what was done
     in the Decisions log. **Never silently drop a change from main.**
4. **Confirm with Katy.** Before doing any new step, summarize in 2-3 lines:
   "Last completed step: X. Main has/hasn't moved. Next step: Y. About to do
   the triage / make the change." Wait for her go-ahead.

## Progress

Update the checkbox and add the commit SHA when a step lands. Add brief
notes inline if anything didn't go to plan.

- [x] **Step 1**: Base conversion — _commit:_ `c96221c`
- [ ] **Step 2**: ctrlp → fzf only — _commit:_
- [ ] **Step 3**: vim-signify → gitsigns.nvim — _commit:_
- [ ] **Step 4**: vim-indent-guides → indent-blankline.nvim — _commit:_
- [ ] **Step 5**: nerdtree → nvim-tree, devicons → nvim-web-devicons — _commit:_
- [ ] **Step 6**: vim-polyglot → nvim-treesitter — _commit:_
- [ ] **Step 7**: coc.nvim → nvim-lspconfig + nvim-cmp — _commit:_
- [ ] **Step 8**: Cleanup — _commit:_

## Decisions log

Persistent record of triage outcomes and merge-from-main reconciliations.
Each entry: date, context, decision. Append; don't rewrite.

### 2026-04-26 — Step 1 (base conversion) landed (`c96221c`)

- Smoke test on personal machine: status line, NERDTree+devicons, ctrlp,
  diffview, dark/light toggle, CoC, terminal splits all working.
- **New deferred issue:** can't select text in the lualine status line with
  the mouse. May be related to attempt-1's "mouse/cursor cmdline regression"
  noted in Out of scope. Revisit after step 7 (the LSP swap may incidentally
  fix mouse handling).
- `python3` → `python` correction: wip's options.vim had
  `exepath('python3')` but main's init.vim was already on `exepath('python')`
  (commit `dbdd396`). Used main's value.

## Guiding principles

### Preserve muscle memory
Every plugin swap is a *port*, not a replacement. The point is to modernize the
stack without forcing Katy to relearn her editor. Keymap names stay identical
wherever a customization is actually used.

### Don't port what isn't used
Many existing mappings/options were copy-pasted from plugin READMEs years ago
and never built into habits. Porting unused config creates clutter and — worse
— overrides new-plugin defaults with old conventions, so when Katy reads new
plugin docs, the default keybindings won't match her install.

The rule: **port what's in your fingers; let everything else default to the new
plugin's conventions.**

### Hybrid Lua/vimscript layout (settled in attempt 1)
- Options & mappings stay vimscript (more concise, doesn't break things)
- Functions, autocommands, and plugin specs are Lua

## Branch strategy

Replay the work fresh on `nvim-lua-v2` off current `main`. Don't try to rebase
`nvim-lua-wip` — the plug.vim removal-vs-upgrade conflict and init.vim
deletion-vs-edit conflicts (diffview keymaps, gx unmap) add friction with no
upside. The wip branch's commits and lessons are good documentation of *what*
to do; replaying is less work than reconciling.

## Merging to main

Out of scope for the migration session. After step 8 lands, Katy will use the
branch for real work for 1-5 days on both machines, then merge to main herself.
**Claude does not merge to main during this work.**

## Execution model

Each step is one commit on `nvim-lua-v2`. Steps 2-7 (plugin swaps) require a
**checkpoint conversation** before code changes:

1. Claude lists every current customization for the plugin (mappings, `let g:*`
   options, highlight groups, autocmds, commands).
2. Katy tags each as: **use it** / **don't use it** / **not sure**.
3. Disposition:
   - **don't use** → drop; take new plugin defaults
   - **use** → port faithfully to new plugin equivalent (same keymap)
   - **not sure** → drop; note it; revisit if missed during soak
4. Claude makes the change.
5. Commit message body lists what was ported and what was dropped.

Step 1 (base conversion) does not need a checkpoint — it just moves existing
config into the new file structure. Customizations get triaged when their
plugin is up for swap.

## Steps

### 1. Base conversion (no behavior changes)

Mirrors what `nvim-lua-wip` did, plus the three nvim commits on main since the
wip branch diverged.

- Add `init.lua` as entry point
- Add `init/options.vim`, `init/mappings.vim` (move existing options/mappings
  verbatim from `init.vim`)
- Add `init/functions.lua` (FileDir, ApplyDark/Light, WindowSwapping,
  ConflictsHighlight)
- Add `init/autocommands.lua` (filetype detection, filetype settings,
  whitespace, CoC autocmds)
- Add `init/plugins.lua` with lazy.nvim bootstrap and all current plugin specs
  ported 1:1 (including diffview from main)
- lightline → lualine (catppuccin no longer ships lightline support)
- Port main-only changes: diffview plugin spec + keymaps, unmap gx in markdown
- `.gitignore` for `lazy-lock.json`
- Add `after/syntax/nerdtree.vim` workaround for devicons bracket conceal
  (will be deleted in step 5)
- Delete `init.vim`, `nvim/autoload/plug.vim`
- After this step: nvim works exactly as it does on main, just from Lua

### 2. ctrlp → fzf.vim only (remove ctrlp)

fzf.vim is already installed. Eliminate ctrlp; port only the customizations
Katy actually uses.

Current ctrlp customizations (to triage):
- `,f` → `:CtrlP`
- `,m` → `:CtrlPMRU`
- `,g` → `:CtrlPBuffer`
- `,r` → `:CtrlPClearCache`
- `<C-q>` → ctrlp invoke
- `g:ctrlp_match_window_bottom = 0`
- `g:ctrlp_match_window_reversed = 0`
- `g:ctrlp_show_hidden = 1`
- `g:ctrlp_switch_buffer = 'Et'`
- `g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|coverage'`
- `g:ctrlp_root_markers = ['.ctrlp']`
- `g:ctrlp_dont_split = 'NERD'`
- `g:ctrlp_prompt_mappings` (custom prompt mappings)

### 3. vim-signify → gitsigns.nvim

Current signify customizations (to triage):
- `<Leader>s` → `:SignifyFold<CR>`
- (sign column is set globally via `signcolumn=yes`, not signify-specific)

Defaults likely fine for the rest.

### 4. vim-indent-guides → indent-blankline.nvim

Current indent-guides customizations (to triage):
- Dark theme colors: `#233046` (odd), `#2F3648` (even), wired into `ApplyDark()`
- Light theme colors: `#C3D0C6` (odd), `#CFD6C8` (even), wired into `ApplyLight()`
- `g:indent_guides_exclude_filetypes = ['help', 'nerdtree']`

Need to replicate dark/light color swap in `functions.lua` integration with
indent-blankline highlight groups.

### 5. nerdtree → nvim-tree.lua, vim-devicons → nvim-web-devicons

Current nerdtree customizations (to triage):
- `,d` → `:NERDTreeToggle`
- `,e` → `:NERDTreeFind`
- `NERDTreeIgnore = ['\.pyc$']`
- `NERDTreeWinSize = 45`
- `NERDTreeShowHidden = 1`
- `g:WebDevIconsNerdTreeBeforeGlyphPadding = ''` (devicons workaround)

Removes `after/syntax/nerdtree.vim` workaround entirely. (`nvim-web-devicons`
is already in plugin list — used by diffview — so it's not a new dependency.)

### 6. vim-polyglot → nvim-treesitter

polyglot has no per-plugin customizations in current config beyond inclusion.
Triage: which languages do you edit often enough to want treesitter parsers?

Default suggestion: Python, JS/TS, Lua, Bash, JSON, YAML, Markdown, TOML.
Plus filetypes from `nvim/syntax/*.vim` and `nvim/after/ftplugin/*` that
indicate active use (apex, visualforce, ejs, tinytower, javascript, markdown).

### 7. coc.nvim → nvim-lspconfig + nvim-cmp + (null-ls or conform/lint)

Largest swap. Current coc state:

**Servers (from coc-settings.json + installed extensions):**
- pyright (Python LSP)
- tsserver (TS/JS, via coc-tsserver)

**Python tooling (from coc-settings.json):**
- black formatter (`python.formatting.provider`)
- flake8 linter (`python.linting.flake8Enabled`)
- pyright inlay hints disabled (`pyright.inlayHints.*`)

**Completion behavior:**
- `suggest.noselect: true` (don't preselect first item)

**Recommended editor options (set globally, not coc-specific — keep):**
- `cmdheight=2`, `hidden`, `shortmess+=c`, `signcolumn=yes`, `updatetime=300`

**Mappings to triage:**
- Completion: Tab/S-Tab navigate, `<C-space>` refresh, Enter behavior
- Float scroll: `<C-f>`/`<C-b>` (n/i/v modes)
- Diagnostics nav: `[g`, `]g`
- Definitions: `gd`, `gy`, `gi`, `gr`
- Hover: `K` (custom function: showDocumentation)
- Symbol highlight on CursorHold
- Rename: `<leader>rn`
- Format selection: `<leader>f` (n/x)
- Format buffer: `,n`
- Format autocmds: typescript, json
- Code action: `<leader>a` (n/x)
- Code action current line: `<leader>ac`
- Quickfix: `<leader>qf`
- Codelens: `<leader>cl`
- Range select: `<C-s>` (n/x)
- Text objects: `if`/`af`/`ic`/`ac`
- Commands: `:Format`, `:Fold`, `:OR`
- CocList: `<space>a` (diagnostics), `<space>e` (extensions — N/A in lsp),
  `<space>c` (commands), `<space>o` (outline), `<space>s` (symbols),
  `<space>j`/`<space>k` (next/prev), `<space>p` (resume)

**Replacement stack (proposed, subject to step 7 checkpoint):**
- `nvim-lspconfig` for pyright + tsserver
- `nvim-cmp` + `cmp-nvim-lsp` + `cmp-buffer` + `cmp-path` for completion
- `null-ls` (or `conform.nvim` + `nvim-lint`) for black + flake8
- `nvim-treesitter-textobjects` for `if`/`af`/`ic`/`ac` (already pulled in by
  step 6)
- `telescope.nvim` for `<space>*` list-style commands (diagnostics, symbols,
  commands) — only added if you use those CocList mappings
- `Trouble.nvim` (optional) for diagnostics list

### 8. Cleanup

- Remove empty `nvim/lua/` directory if present
- Remove stale `nvim/autoload/` directory (after plug.vim is gone)
- Update `plan-nvim-zshrc.md` reference to `mappings.vim` instead of `init.vim`
- Final pass: any TODO/FIXME left in init/* files

## Out of scope

- **Merging to main** — Katy's call after the soak
- **Mouse/cursor cmdline regression** (couldn't select cmdline text in attempt
  1) — investigate after step 8 if still present; plugin swaps may incidentally
  fix it
- **Lualine mouse text-select** (noted in step 1 smoke test; can't select
  status line text with mouse) — same investigation window
- **Changing mappings Katy currently uses** — would ask first; this plan only
  *moves* existing mappings or *retires* unused ones

## Reference: lessons from attempt 1

See `plan-nvim-lua-migration.md` for the full post-mortem. Key takeaways
already baked into this plan:

- Hybrid Lua/vimscript layout (options & mappings vimscript, rest Lua)
- `vim.cmd("source ...")` and `vim.cmd("luafile ...")` from `init.lua`; don't
  use `require()` (would force a `lua/` directory we don't want)
- lazy-lock.json gitignored
- catppuccin lualine theme name: `"auto"` or `"catppuccin-frappe"`, not
  `"catppuccin"`
- lazy.nvim load-order quirks with vimscript plugins (devicons + nerdtree
  conceal) — the nerdtree→nvim-tree swap eliminates this class of issue
