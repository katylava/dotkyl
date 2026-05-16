# Plan: extract common install scaffolding via sourced hooks

## Status

In progress.

- [x] Chunk 1 — write `setup/apply-manifest.zsh` + a temporary test task; verify in isolation
- [x] Chunk 2 — convert `install:claude-plugins`; remove the test task
- [ ] Chunk 3 — convert `install:brew`, `install:pip`, `install:npm` (combined)

## Problem

`install:brew`, `install:pip`, `install:npm`, `install:claude-plugins` in
`mise.toml` each hand-roll the same scaffolding: resolve `setup/<Stem>.shared`
+ `setup/<Stem>.$DOTKYL_HOST`, iterate, detect what's missing, install, clear
the `.<marker>-outdated` marker. ~110 lines of near-duplicate control flow
around a small core of genuinely tool-specific logic.

## Design

A sourced zsh file, **`setup/apply-manifest.zsh`**.

It provides:

1. No-op defaults for all hooks, so the helper runs a fixed sequence without
   inspecting which task it serves:

   ```zsh
   check_line()   { return 0 }   # 0 = present / nothing missing
   install_file() { : }
   install_line() { : }
   post_install() { : }
   ```

2. `apply_manifest <Stem> <marker>` — a fixed, per-file linear flow:

   ```zsh
   resolve setup/<Stem>.shared, setup/<Stem>.$DOTKYL_HOST   # skip absent
   for f in files:
     install_file "$f"
     missing_lines=()
     while IFS= read -r line; do
       [[ -z "$line" || "$line" == \#* ]] && continue
       check_line "$line" || missing_lines+=$line
     done < "$f"
     (( ${#missing_lines} )) && install_line "${missing_lines[@]}"
   post_install
   rm -f .<marker>-outdated
   ```

Each task in `mise.toml` sources the file, redefines only the hooks it needs
(unique logic stays inline in the task), and calls `apply_manifest`.

### Design rules

- The helper always calls all four hooks at fixed points. A task makes
  unused hooks no-ops by not redefining them; the lib's defaults stand.
  Line-vs-file granularity lives entirely inside the task's hook functions.
- There is no check-before-install gate. `install_file` runs unconditionally
  per file — every install command here is idempotent, and the
  `.<marker>-outdated` reminder is the change signal, so running it when
  nothing changed is harmless.
- `install_line` is called once per file with that file's missing lines as
  `"$@"`, only when the per-line `check_line` found any. Tasks that install
  per-item loop `"$@"` internally.
- The helper prints one generic `✅ done` status line (mise already prefixes
  output with the task label, so the marker name would be redundant).
  Item-level detail (which plugin/package) comes from the
  `install_line`/`install_file` hooks; no-op defaults are silent.
- `post_install` runs once, after all files.
- The helper reads each file directly (`done < "$f"`, not a pipe) so loop
  variables persist; the comment/blank skip is inline in that loop.
- `setup/apply-manifest.zsh` is zsh. mise runs task `run` blocks under `sh`
  by default, so every task that sources it must set `shell = "zsh -c"`.

## Hook values per task

### brew

- `install_file`: `brew bundle --file "$1"` (idempotent — installs only
  what's missing)

### pip

- `install_file`: `mise exec python -- pip install -q -r "$1"` (idempotent —
  no-ops satisfied requirements; `check_line` is unnecessary with no gate)
- `post_install`: `mise reshim`

### npm

- `check_line`: `mise exec node -- npm ls -g --depth=0 "$1" >/dev/null 2>&1`
- `install_line`: `mise exec node -- npm install -g --silent "$@"`, then echo
  each installed package
- `post_install`: `mise reshim`

### claude-plugins

Line is `source plugin marketplace`.

- `check_line`: missing if the plugin is not installed. Match the spec
  anchored with a leading space and end-of-line `$` so it cannot match a
  substring of a different plugin:
  `claude plugin list 2>/dev/null | ag " $p@$m$"`.
- `install_line`: loop `"$@"`; per line, run
  `claude plugin marketplace add "$s"` unconditionally (idempotent — fine if
  another line already added it), then `claude plugin install "$p@$m"`; echo
  each.

## Behavior

- Output comes from the install hooks, not a batch status line. A line is
  printed per plugin/package actually installed; file-based installs
  (brew/pip) print per file installed.
- Each resolved file is processed in its own loop iteration: `install_file`
  runs on it unconditionally (idempotent), and `install_line` runs only for
  that file's missing lines.

## Rollout

Chunked, one commit each, stop for review between, on `main`. Each chunk
leaves the repo working — untouched tasks keep their old inline blocks until
their chunk lands.

1. Write `setup/apply-manifest.zsh` and a temporary `_manifest-test` task
   (no `install:`/`sync:` prefix, so the `install:**` wildcard does not sweep
   it) with trivial `check_line`/`install_line` hooks over fixture files.
   Verify the helper's flow (`install_file` always runs, `install_line` only
   for missing lines, `post_install` once after all files) by running the
   test task.
2. Convert `install:claude-plugins` (`check_line` + `install_line`); delete
   its old block; remove the test task. Verify `mise run
   install:claude-plugins`.
3. Convert `install:brew` (`install_file`), `install:pip` (`install_file` +
   `post_install`), and `install:npm` (`check_line` + `install_line` +
   `post_install`) together. Verify each with `mise run install:<task>`.
