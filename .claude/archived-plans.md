# Archived Plans

Completed or abandoned plan files removed from `.claude/` to keep it lean. Full
content stays in git history.

To read an archived plan:

```sh
git show <commit>:.claude/<file>
```

The listed commit is the last one that changed that file's content (not the
commit that deleted it). Each entry has a **Topics** line so a future session
can grep this index to judge relevance before pulling the full file.

## Completed

### plan-install-task-hooks.md

`1012403` · 2026-05-15

Refactor the duplicated install scaffolding in `mise.toml` into one shared,
sourced zsh helper. Done — all four `install:*` tasks use
`setup/apply-manifest.zsh`.

Topics: mise.toml task structure; `install:brew` / `install:pip` /
`install:npm` / `install:claude-plugins`; `setup/apply-manifest.zsh`;
`setup/<Stem>.shared` + `setup/<Stem>.$DOTKYL_HOST` manifest resolution;
hook functions `check_line` / `install_file` / `install_line` /
`post_install`; `.<marker>-outdated` reminder marker; idempotent install
pattern; `shell = "zsh -c"` (mise runs `run` under `sh` by default); `brew
bundle`, `pip install -r`, `npm ls -g`/`npm install -g`, `claude plugin
marketplace add`/`install`, `mise reshim`. Relevant to: anything touching
mise install tasks or the apply-manifest helper.

### plan-nvim-lua-migration-v2.md

`6e936dc` · 2026-04-29 (squash-merged via PR #5)

Full vimscript→Lua neovim migration plus plugin-stack modernization. All 8
steps done.

Topics: `nvim/init.lua` entry point; `nvim/init/` layout
(`options.vim`, `functions.lua`, `plugins.lua`, `autocommands.lua`,
`mappings.vim`, `lsp.lua`); lazy.nvim (replaced vim-plug); lualine (replaced
lightline); catppuccin theme. Plugin swaps: ctrlp→fzf, vim-signify→
gitsigns.nvim, vim-indent-guides→indent-blankline.nvim, nerdtree→
nvim-tree.lua, vim-devicons→nvim-web-devicons, vim-polyglot→nvim-treesitter
(v1 rewrite; needs `tree-sitter-cli`, added to `setup/Brewfile.shared`),
coc.nvim→nvim-lspconfig + nvim-cmp + mason.nvim/mason-lspconfig/
mason-tool-installer + conform.nvim + nvim-lint + LuaSnip. LSP servers
pyright/ts_ls; tools black/flake8/prettier/eslint_d; nvim 0.11+
`vim.lsp.config`/`vim.lsp.enable` API; nvim-cmp keymaps
(`<C-n>`/`<C-p>`/`<C-y>`/`<C-e>`); copilot accept remap `<C-n>`→`<C-j>`;
nvim-tree in-tree keymap overrides; rainbow/diffview plugins; per-plugin
triage + Decisions log workflow. Relevant to: any neovim config work, any of
these plugins, the LSP/completion/format/lint setup, the `init/` file split.

## Superseded

### plan-nvim-lua-migration.md

`246b465` · 2026-04-26

Attempt-1 post-mortem (the `nvim-lua-wip` branch). Kept for its
lessons-learned section, which the v2 plan referenced.

Topics: rollback tag `pre-nvim-lua`; branch `nvim-lua-wip`; why options &
mappings stay vimscript but functions & autocommands stay Lua; lazy.nvim
load-order pitfalls (devicons + nerdtree bracket-conceal,
`after/syntax/nerdtree.vim` workaround); catppuccin dropped lightline →
lualine `theme = "auto"`; `lazy-lock.json` gitignored for single-user;
`vim.cmd("source ...")` vs `luafile` vs avoiding `require()`/`lua/`.
Relevant to: understanding *why* v2 made its structural choices; debugging
lazy.nvim plugin load order.

## Abandoned

### plan-gstack-ideas.md

`70191aa` · 2026-04-17

Catalog of 19 capabilities to potentially steal from the gstack repo
(`github.com/garrytan/gstack`). Idea backlog; never acted on.

Topics: headless browser with accessibility-tree snapshots; "diff the page
since last snapshot"; handoff to visible browser; Chrome cookie import;
untrusted-external-content markers; anti-bot stealth browser config;
PreToolUse hook warning before destructive bash; PreToolUse hook restricting
Edit/Write to a directory; root-cause-first debugging with scope lock;
product/idea interrogation skill; completion-status protocol; manual "what
did I learn?" skill; plan-mode-safe operations list; architecture & test
plan review; UI plan review with 0–10 per-dimension ratings; build a design
system from scratch; iterative AI mockup exploration; mockup→production
HTML/CSS; post-ship visual audit with atomic fixes. Relevant to: ideas for
new skills/hooks, browser automation, planning-review or design workflows.

### plan-nvim-zshrc.md

`6e936dc` · 2026-04-29

A minimal alternate zshrc for neovim terminal buffers. Abandoned — its core
terminal-mapping step was made moot by the Lua migration (the
`term://zsh -f`→`term://zsh` change shipped there instead).

Topics: `$NVIM` / `$NVIM_LISTEN_ADDRESS` detection; proposed
`lib/nvim-zshrc.zsh` + early-return guard in `home/zshrc`; rationale for
skipping heavy `lib/*.zsh` files in nvim splits — `002-colors` (vivid
subprocess), `015-completion` (compinit/gcloud), `020-keybindings` (vi-mode
cursor escapes), `040-titles` (OSC), `080-bookmarks` (ZLE widget),
`085-versions` (nodenv precmd), `090-prompt` (starship git status),
`095-run` (ssh-add), `100-installed` (`brew --prefix` + 4 zsh plugins);
`term://zsh -f` vs `term://zsh` nvim mappings. Relevant to: zshrc load
performance, nvim terminal shell behavior, `lib/*.zsh` load order.
