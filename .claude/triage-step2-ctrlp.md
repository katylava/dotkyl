# Step 2 triage: ctrlp customizations

For each item, replace `[ ]` with one of:

- `[u]` use it — port to fzf.vim equivalent (same keymap)
- `[d]` don't use — drop; take fzf defaults
- `[?]` not sure — drop; revisit if missed during soak

Add free-text notes after items if helpful.

## Mappings

- [u] **`,f`** → `:CtrlP` (find files in project)
- [u] **`,m`** → `:CtrlPMRU` (most-recently-used files)
- [d] **`,g`** → `:CtrlPBuffer` (open buffer list)
- [u] **`,r`** → `:CtrlPClearCache` (refresh ctrlp's file cache)
- [d] **`<C-q>`** → invoke ctrlp (set via `g:ctrlp_map`)

## Options

Note from katy: these seem like things that just _are_, not things i use/don't
use. So I'm going to mark them as "use" since if it changes I'll probably be
confused.

- [u] **`match_window_bottom = 0`** — results window at top, not bottom
- [u] **`match_window_reversed = 0`** — best match at top of list
- [u] **`show_hidden = 1`** — include dotfiles in results
- [u] **`switch_buffer = 'Et'`** — opening a file already in a buffer jumps to
      that window/tab instead of reopening
- [u] **`custom_ignore = 'node_modules|DS_Store|coverage'`** — exclude these
- [?] **`root_markers = ['.ctrlp']`** — treat any dir with `.ctrlp` as project root
      note from katy: i haven't used this because i forgot about it, but it
      seems handy. however, if we are getting rid of ctrlp, the root marker
      should be something else (assuing root marker is even supported in
      whatever we are replacing ctrlp with).
- [?] **`dont_split = 'NERD'`** — don't open results in a nerdtree-adjacent split
      if we are about to replace nerdtree anyway, then we might as well drop
      it, right?

## Prompt mappings (keys inside the ctrlp picker)

- [u] **`<c-n>` / `<down>`** → next result
- [u] **`<c-p>` / `<up>`** → prev result
- [u] **`<c-j>`** → history back
- [u] **`<c-k>`** → history forward

note from katy: i'm not sure what the "history" ones are, but i think i use
them (it feels familiar). i probably don't think of it as "history".

## Notes from Claude (for context, not triage)

- **Item `,r` clear cache**: fzf re-runs the file command every time, so there
  is no cache to clear. If kept, it'd basically duplicate `,f`. Likely safe
  to drop unless you have a workflow that depends on it.
  note from katy: ok drop it. i marked it "u" above because i use it, but if
  it's not needed then i won't use it in the future.
- **Item `custom_ignore`**: fzf has no ignore mechanism of its own; it shells
  out to whatever `$FZF_DEFAULT_COMMAND` is (typically `ag`/`rg`). If you
  want this preserved, the port is setting that env var (in zshrc), not
  in nvim config. Note: `set wildignore` in options.vim already lists similar
  patterns for vim's own `wildmenu`.
  note from katy: i use `ag`, which i think uses .gitignore, so it should just
  work, i think. can you confirm?
- **Item `root_markers`**: fzf uses cwd by default. To replicate, you'd need
  a wrapper that walks up to find `.ctrlp` and runs fzf there. Probably more
  effort than it's worth unless this is core to your workflow.
  note from katy: ctrlp also uses cwd by default, but still offers a way to
  override it. so telling me "fzf uses cwd by default" doesn't tell me
  anything. find out if fzf supports something similar -- it might call it
  something else. if it doesn't support it then don't worry about it. but if it
  does then let's try to replicate the behavior, since it seems like a
  nice-to-have.
- **Prompt mappings**: fzf defaults — `<C-n>`/`<C-p>` and arrow keys all
  navigate results; `<C-j>`/`<C-k>` navigate history. Pretty close to your
  current setup already.
  note from katy: pretty close? or exactly? i want exactly. if the default are
  the same then we don't need to override. i don't think the `c` in mine vs the
  `C` (uppercase) in theirs make a difference (i think they are the same), but
  please confirm.
