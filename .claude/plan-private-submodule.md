# Plan: Convert `private/` to a git submodule

Make the `private/` repo a real git submodule of the main `dotkyl` repo,
so that pulling the main repo reliably propagates private-only changes
(content **and** symlinks) to the other machine.

This file is the high-level case for the change. The implementation
details are deliberately left for a later session — see **Status**.

## Background

`private/` is currently an independent clone of `dotkyl-private`, sitting
inside the main repo and gitignored by it. It is pulled by the
`setup:private-repo` mise task, which runs from `mise run sync`, which
runs from the main repo's `post-merge` hook.

A previous session (`136f84a6-20ef-4612-8389-d41d3299e7d9`) surfaced a
propagation flaw that this arrangement cannot fix.

## The problem

Desired behavior: **when I run a plain `git pull` in the main repo on one
machine, that machine is fully synced — including changes I made only in
`private/` on the other machine, with their symlinks applied.** No cron,
no shell wrapper, no separate "pull everything" command.

That behavior is impossible with the current independent-clone setup. The
reason is a chain that has no first link for private-only changes:

1. The only pull-triggered git hook is `post-merge`, and it only fires
   when a real merge happens.
2. A real merge requires the main repo to have a new commit on the
   remote.
3. A private-only change, by definition, produces no main-repo commit.
4. Therefore a private-only change can never fire `post-merge` on the
   other machine's main pull. (There is no `post-fetch` / `post-pull`
   hook, and a no-op pull moves no refs, so `reference-transaction` stays
   silent too.)
5. Therefore, to make the main repo's `git pull` carry a private-only
   change, *something must create a main-repo commit every time private
   changes.*

Rejected workarounds, and why:

- **Cron pull + sync** — breaks the mental model that a manual `git pull`
  is what means "synced." Sync would happen on a timer, not on the pull.
- **A `git` shell wrapper** — shadows the global `git` function; a hack,
  and shell-only.
- **A separate `dotkyl-pull` command** — works, but it isn't a plain
  `git pull`, which is the whole requirement.
- **post-merge hook inside `private/`** — never fires, because this
  machine never pulls `private/` by hand; it's pulled by the main sync.
- **git subtree** — would inline private's content into the public main
  repo's tree and history, defeating the privacy split.

## Why a submodule is the solution

A submodule is the only native git construct that makes the main repo
record a commit *in lockstep with* every private change: the pointer-bump
(gitlink) commit. That commit is exactly the missing first link — it
makes the other machine's main `git pull` non-empty whenever private
moved, which fires `post-merge`, which runs sync, which applies symlinks.

This reframes an earlier decision. In a prior session we argued *against*
submodules, but on the **reproducibility** axis ("you never check out old
main to get the matching old private, so the pin is dead weight"). That is
still true. What that argument missed is the pointer-bump's *second*
function as a **propagation signal**. Under this requirement the
pointer-bump is not a cost — it is the load-bearing mechanism, and nothing
else native provides it.

Two earlier objections also weaken under this framing:

- "The other machine gets stale/pinned private" assumed you *forget* to
  bump the pointer. If "commit private, bump pointer, push" is one atomic
  unit, the other machine's pull lands exactly the intended private
  commit.
- The symlink race from the source session (symlink pass running before
  the private pull lands) goes away, because the submodule update happens
  during the pull's own checkout, before sync runs.

## Hard requirement for the implementation: make it easy to get right

The submodule's cost is the per-change ritual: commit in the submodule,
then bump and push the pointer in the main repo. If that ritual depends on
human memory, it will be forgotten, and a forgotten pointer-bump silently
recreates the exact propagation gap we are trying to close (private pushed,
main pointer not bumped, other machine never sees it).

So a core goal of the implementation — not an afterthought — is to **make
doing it correctly the path of least resistance, and make doing it wrong
hard or loud.** As much as is reasonably feasible, do not rely on the
human remembering the steps. Candidate mechanisms to evaluate later (not
yet decided):

- Folding the pointer-bump into the `/commit` skill, so committing in
  `private/` (or right after) also stages and commits the gitlink in main.
- `git config push.recurseSubmodules=on-demand` (and/or `check`) so one
  push sends both repos, or refuses to push main with an unpushed
  submodule commit.
- `git config submodule.recurse=true` so `git pull` / `checkout` move the
  submodule working tree automatically.
- A guard (hook, or the existing prompt indicator / sync check) that
  detects "submodule moved but main pointer not bumped" or "main points at
  an unpushed submodule commit" and surfaces it loudly.

The existing `dotkyl_status` starship prompt indicator is complementary:
it shows when `private/` is dirty / ahead / behind, but it does not make
`git pull` propagate anything. It stays useful after this change.

## Known costs to accept (eyes open)

- Two commits per private change (the private commit plus the main
  pointer-bump) — mitigated, not eliminated, by the automation above.
- The detached-HEAD footgun when committing inside a submodule —
  configurable away (`submodule.recurse`, checking out a branch).
- One-time conversion work: `.gitmodules`, reworking `setup:private-repo`
  from `git -C private pull` to a submodule update, deciding the
  auto-update config, and the re-clone choreography on both machines.

## Status

Not started. This is the next planned improvement to the repo, to be
tackled in a later session. The implementation plan (exact conversion
steps, the chosen ease-of-correctness mechanisms, mise/hook changes, and
the two-machine rollout order) will be fleshed out then.
