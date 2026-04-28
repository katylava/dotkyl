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
- [x] **Step 2**: ctrlp → fzf only — _commit:_ `4fd7d6c`
- [x] **Step 3**: vim-signify → gitsigns.nvim — _commit:_ `88bf7e1`
- [x] **Step 4**: vim-indent-guides → indent-blankline.nvim — _commit:_ `19883da`
- [x] **Step 5**: nerdtree → nvim-tree, devicons → nvim-web-devicons — _commit:_ `9315211`
- [x] **Step 6**: vim-polyglot → nvim-treesitter — _commit:_ `9146216`
- [x] **Step 7**: coc.nvim → nvim-lspconfig + nvim-cmp — _commit:_ `9c263f2`
- [x] **Step 8**: Cleanup — _commit:_ `7738bc9`

## Decisions log

Persistent record of triage outcomes and merge-from-main reconciliations.
Each entry: date, context, decision. Append; don't rewrite.

### 2026-04-28 — Step 8 (cleanup) landed (`7738bc9`)

- **Deleted** `nvim/syntax/{apex,ejs,tinytower,visualforce}.vim` —
  filetypes dropped in step 6.
- **Deleted** `nvim/autoload/plug.vim.old` and removed the now-empty
  `nvim/autoload/` directory (was untracked; vim-plug long gone).
- **`nvim/lua/`** wasn't present — nothing to remove.
- **Updated** `plan-nvim-zshrc.md` `init.vim` reference to
  `init/mappings.vim` to match the new layout.
- **Note (not changed):** `plan-nvim-zshrc.md` step 4 references `,tv`/
  `,tx` terminal mappings, which were removed in step 2. The whole
  step is moot now but left as-is for the user to review.
- **No TODO/FIXME** left in `nvim/init/*` files.

### 2026-04-28 — Step 7 (coc → native LSP stack) landed (`9c263f2`)

- **Replacement stack:** mason.nvim + mason-lspconfig + mason-tool-installer
  for tool installation; nvim-lspconfig for bundled server configs;
  nvim-cmp + cmp-nvim-lsp + cmp-buffer + cmp-path for completion;
  LuaSnip + cmp_luasnip for the snippet engine cmp requires;
  conform.nvim for formatters; nvim-lint for linters.
- **API:** uses nvim 0.11+ `vim.lsp.config` / `vim.lsp.enable` (avoids the
  deprecated `require("lspconfig").<server>.setup({})` framework — the
  bundled server configs in nvim-lspconfig are still picked up via
  runtimepath).
- **Servers installed:** pyright, ts_ls (via mason).
- **Tools installed:** black (Python formatter), flake8 (Python linter),
  prettier (JS/TS/JSON/CSS/HTML/MD/YAML formatter), eslint_d (JS/TS linter).
- **Mappings ported (from triage):**
  - `gd` → `vim.lsp.buf.definition` (LspAttach buffer-local)
  - `gr` → `vim.lsp.buf.references` (LspAttach buffer-local)
  - `,n` → `:lua require("conform").format(...)` (format buffer)
- **Completion keys: switched to nvim-cmp defaults** (deviation from
  port-faithful muscle-memory rule, accepted as worth relearning).
  Initial port mirrored coc's Tab/S-Tab nav, but Tab+Enter overlap with
  copilot's accept-suggestion needs and other defaults made overrides
  fragile. Final binding: `<C-n>`/`<C-p>` navigate menu, `<C-y>` confirms,
  `<C-e>` aborts, `<C-b>`/`<C-f>` scroll docs, no `<CR>` binding (Enter
  always inserts a newline). `preselect = none` keeps "no auto-pick"
  behavior from old `suggest.noselect`.
- **Copilot accept remapped:** `<C-n>` → `<C-j>` to free `<C-n>` for cmp
  menu nav. Was the only insert-mode mapping change required by the swap.
- **Mappings dropped (Katy "don't use"):** `<C-space>` refresh, `[g`/`]g`
  diagnostics nav, `gy`/`gi` type/impl, `K` hover, `<leader>rn` rename,
  `<leader>a`/`<leader>ac`/`<leader>qf`/`<leader>cl` code actions,
  `<leader>f` format-selection, `if`/`af`/`ic`/`ac` text objects, `<C-f>`
  /`<C-b>` float scroll, `<C-s>` range select, `:Format`/`:Fold`/`:OR`,
  all `<space>*` CocList mappings, CursorHold symbol highlight.
- **Settings ported automatically (no triage):** pyright inlay hints
  disabled (settings → vim.lsp.config); black/flake8 wired via
  conform/nvim-lint; `suggest.noselect: true` → cmp `preselect = none`.
- **Plugin set changes:**
  - `neoclide/coc.nvim` removed
  - 12 plugins added: mason.nvim, mason-lspconfig.nvim,
    mason-tool-installer.nvim, nvim-lspconfig, nvim-cmp,
    cmp-nvim-lsp, cmp-buffer, cmp-path, LuaSnip, cmp_luasnip,
    conform.nvim, nvim-lint
- **Files changed:**
  - `nvim/init/lsp.lua` created (entire LSP/completion/format/lint config)
  - `nvim/init.lua` sources lsp.lua between plugins.lua and autocommands.lua
  - `nvim/init/mappings.vim`: stripped CoC section
  - `nvim/init/autocommands.lua`: removed CursorHold and `mygroup`
    (formatexpr, CocJumpPlaceholder) autocmds
  - `nvim/coc-settings.json`: deleted
- **Skipped from earlier proposal:** telescope.nvim (no `<space>*` mappings
  kept); nvim-treesitter-textobjects (no `if`/`af`/`ic`/`ac` kept);
  Trouble.nvim (no diagnostics list use case); null-ls (chose
  conform+nvim-lint instead — recommended modern split, lower
  maintenance overhead).

### 2026-04-28 — Step 6 (polyglot → nvim-treesitter) landed (`9146216`)

- No triage needed — polyglot had zero customizations.
- Used **nvim-treesitter v1** (the rewrite). Different API from v0.x:
  the plugin is now a tiny scope (just installs/manages parsers).
  Highlight is enabled per-filetype via an autocmd that calls
  `vim.treesitter.start()`. Indentation/folding intentionally not
  enabled (treesitter indent is still experimental; can opt in later).
- v1 requires `tree-sitter` CLI installed locally (it builds parsers
  with the system toolchain instead of shipping prebuilt binaries).
  Added `tree-sitter-cli` to `setup/Brewfile.shared`. Picks up
  automatically via `mise run brew`.
- **Parsers installed for actively-edited languages:** bash, comment,
  css, html, javascript, json, json5, lua, markdown, markdown_inline,
  python, query, regex, sql, toml, tsx, typescript, vim, vimdoc, yaml.
- **Languages dropped** (not actively used anymore): apex, ejs,
  tinytower, visualforce. Their `nvim/syntax/*.vim` files remain on
  disk but won't be loaded since those filetypes are never opened.
  Cleanup deferred to step 8.
- Visual difference: treesitter highlight is more granular than
  polyglot (function names, parameters, etc. get distinct colors).
  catppuccin handles treesitter groups out of the box.

### 2026-04-28 — Step 5 (nerdtree → nvim-tree, vim-devicons → nvim-web-devicons) landed (`9315211`)

- **Outside-tree mappings ported:** `,d` → `:NvimTreeToggle`,
  `,e` → `:NvimTreeFindFile`.
- **Tree options ported:**
  - `NERDTreeIgnore = ['\.pyc$']` → `filters.custom = { ".*%.pyc$" }`
  - `NERDTreeWinSize = 45` → `view.width = 40` (45 felt too wide in
    nvim-tree, dropped to 40 during testing)
  - `NERDTreeShowHidden = 1` → `filters.dotfiles = false`
- **In-tree overrides** (preserve nerdtree muscle memory). nvim-tree's
  defaults put file-open actions on Ctrl-letters; we override single
  letters to match nerdtree:
  - `i` → horizontal split (was unbound)
  - `s` → vertical split (was `system_open` — Katy doesn't use it)
  - `t` → new tab (was unbound)
  - `?` → help (default was `g?`)
  - `C` → change tree root (was `toggle_git_clean` — Katy doesn't use it)
  - `R` left as default (same key as nerdtree, no override needed)
  - Dropped `cd` override (Katy uses `C` only)
- **In-tree behaviors NOT ported** (Katy "never" / "no" in triage):
  open-in-current-window via `<CR>`/`o` (still works as nvim-tree
  default; she just doesn't use it), toggle dotfiles `Shift-I`,
  create/delete/rename/move, bookmarks. `u` (parent dir, "rarely") also
  dropped — nvim-tree's `-` works if needed.
- **Plugin set changes:**
  - `scrooloose/nerdtree` removed
  - `ryanoasis/vim-devicons` removed
  - `nvim-tree/nvim-tree.lua` added
  - `nvim-tree/nvim-web-devicons` already present (diffview dep), now
    also a dep of nvim-tree and lualine
  - `lualine.nvim` deps updated: `vim-devicons` → `nvim-web-devicons`
  - `rainbow` `separately = { nerdtree = 0 }` → `{ NvimTree = 0 }`
- **Files deleted:** `nvim/after/syntax/nerdtree.vim` (bracket-conceal
  workaround was specific to nerdtree+vim-devicons, no longer needed).
- **Stale dir cleanup:** `nvim/plugged/` (vim-plug's old install dir)
  deleted locally because fzf's `,f` was surfacing it. Already
  gitignored. Other machine: delete it during the soak transition.
- **nvim-tree-only features surfaced** (Katy didn't enable any, but
  noting them for reference): live filter (`f`/`F`), git-ignored toggle
  (`I`), dotfiles toggle (`H`), buffer-only filter (`B`), path copies
  (`gy`/`Y`/`y`/`ge`), git-change navigation (`[c`/`]c`), diagnostic
  navigation (`[e`/`]e`), tab preview.

### 2026-04-26 — Step 4 (indent-guides → indent-blankline) landed (`19883da`)

- **All customizations ported.** Alternating IblOdd/IblEven highlights
  (with `char = " "` plus `guibg`) reproduce vim-indent-guides' column-fill
  visual. `start_level=2` and `guide_size=1` were vim-indent-guides
  internals; indent-blankline's defaults are close.
- **Colors revisited.** Original colors didn't translate well — the dark
  even and both light shades were too dark or off-hue.
  Final palette:
  - Dark odd: `#233046` (kept from original)
  - Dark even: `#383C52`
  - Light odd: `#E2E7DD`
  - Light even: `#DDE2D8`
- **`exclude_filetypes`** initially ported as `exclude.filetypes = { "help",
  "nerdtree" }`, then dropped entirely in follow-up (`aeb9e92`) — Katy
  isn't using the editor for real work until the migration is done, so
  guides showing in nerdtree mid-migration is fine.
- **ColorScheme handling rewrite.** `set background=...` triggers a
  colorscheme reload that clears non-builtin highlight groups (including
  IblOdd/IblEven), and ibl's own ColorScheme autocmd panics if those
  groups don't exist. Fix: re-apply ibl colors via a ColorScheme
  autocmd registered in `functions.lua` (which loads before
  `plugins.lua`, so our autocmd runs before ibl's).
- **Level-1 guide resolved in follow-up** (`aeb9e92`): ibl v3 ships
  built-in WHITESPACE hooks `hide_first_space_indent_level` and
  `hide_first_tab_indent_level`. Registering both restores the
  `start_level=2` behavior from vim-indent-guides.

### 2026-04-26 — Step 3 (signify → gitsigns) landed (`88bf7e1`)

- **Mapping ported:** `<Leader>s` → `:GitsignsFold`. The new command toggles
  on second press (restores prior foldmethod/foldexpr/foldenable/foldlevel
  via window-local saved state) — improvement over signify's one-way fold.
- **Option dropped:** `g:signify_vcs_list = ['git']` (gitsigns is git-only;
  the option's purpose is N/A).
- gitsigns ships with extras (hunk preview, stage/unstage, blame line, hunk
  text objects, `]c`/`[c` navigation) but none were enabled — defaults only.

### 2026-04-26 — Step 2 (ctrlp → fzf) landed (`4fd7d6c`)

Triage outcome:

- **Mappings ported:** `,f` → `:FzfFiles`, `,m` → `:FzfHistory`.
- **Mappings dropped:** `,g` (CtrlPBuffer), `,r` (CtrlPClearCache — fzf has
  no cache to clear), `<C-q>` (ctrlp invoke).
- **Options dropped, with rationale:**
  - `match_window_*` → covered by `g:fzf_layout = { up = '~40%' }`
  - `show_hidden` → covered by ag's `--hidden` flag
  - `switch_buffer = 'Et'` → fzf default behavior already does this
  - `custom_ignore` → set via ag's `--ignore` flags (and `-U` so
    `.gitignored` files are still findable, which Katy needs)
  - `root_markers = ['.ctrlp']` → no fzf equivalent; dropped (`:GFiles`
    handles git-root scope but Katy explicitly didn't want git-root)
  - `dont_split = 'NERD'` → moot (fzf opens in a panel, not a split)
- **Prompt mappings dropped:** fzf defaults (`<C-n>`/`<C-p>` and arrow
  keys for next/prev) match Katy's current bindings exactly; history
  mappings not needed since `,m` covers the recent-files use case.

Beyond the pure port:

- `--reverse` layout (best match at top, prompt at top), top panel.
- ag with `-U` + explicit excludes for `node_modules`/`coverage`/`.DS_Store`
  so `.gitignored` files are findable but noise is excluded.
- `<C-e>` / `<C-y>` scroll the fzf preview (mirrors vim scroll keys).
- `BAT_STYLE=plain` removes line-number gutter from previews.

Other decisions in this session:

- **All terminal-mode mappings removed** (`jk`, `<C-h/j/k/l>` window-nav,
  `,tv` / `,tx` terminal openers). Katy hadn't built a habit of using
  terminal mode, and the global `tnoremap` was kicking her out of fzf
  via key collision.
- **mouse=a kept**; use Option-click in iTerm to bypass mouse reporting
  when selecting text. Comment added to `nvim/init/options.vim`.
  Resolves the lualine + fzf "can't select with mouse" deferred items.

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
branch for real work for 1-5 days on both machines, then merge to main herself
via a **squash-merged GitHub PR**. GitHub's squash-merge collapses to one
commit but preserves each per-step commit message as a bullet in the merge
commit body, so the per-step messages survive on main. **Claude does not
merge to main during this work.**

## Execution model

Each step is one commit on `nvim-lua-v2`. Steps 2-7 (plugin swaps) require a
**checkpoint conversation** before code changes:

1. Claude writes a triage file at `.claude/triage-step<N>-<plugin>.md` listing
   every current customization for the plugin (mappings, `let g:*` options,
   highlight groups, autocmds, commands). Katy fills it in directly so she
   can mark items inline. **This file is gitignored — never commit it.** When
   the step lands, the *outcomes* are inlined into the plan's Decisions log
   and the triage file is deleted locally.
2. Katy tags each item as: **use it** / **don't use it** / **not sure**.
3. Disposition:
   - **don't use** → drop; take new plugin defaults
   - **use** → port faithfully to new plugin equivalent (same keymap)
   - **not sure** → drop; note it; revisit if missed during soak
4. Conversation continues — Katy may have follow-up questions or change
   her mind on items as she learns more about the new plugin.
5. Claude makes the change and runs the headless smoke test
   (`nvim --headless +qa`) to catch syntax errors and lazy.nvim install
   issues.
6. **Claude gives Katy a short list of concrete things to try in nvim**
   that exercise the new behavior (port of each kept mapping, any
   noteworthy new behavior, edge cases relevant to the swap). Wait for
   her to test and report back before committing — she catches UX
   regressions Claude can't see headless.
7. Iterate on any issues she finds. The change is done when she says it
   works.
8. Final triage outcomes (mappings ported / dropped, options handled, plus
   any decisions that emerged in conversation) are written into the
   Decisions log entry for the step. The triage file is deleted.
9. Commit message body summarizes what was ported and what was dropped.

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
- ~~**Mouse/cursor cmdline regression** / **Lualine mouse text-select**~~ —
  resolved as a decision, not a bug: keep `mouse=a`, use Option-click in iTerm
  to bypass mouse reporting (see step 2 decisions log entry)
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
