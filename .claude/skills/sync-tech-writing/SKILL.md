---
name: sync-tech-writing
description: Port recent general tech-writing changes from the work skill (orm-claude-tech-writing) into this repo's copy of the tech-writing skill. Use when the user asks to sync, fold in, or apply recent tech-writing changes from work, update the tech-writing skill from the work one, or catch this repo's skill up to the work one.
---

# Sync tech-writing from work

The skill in this repo is the original; the work skill (orm-claude-tech-writing)
is a fork of it. In practice most general writing guidance gets authored in the
work skill first and periodically ported back here. This skill is the port
procedure so the user doesn't re-explain the file locations, the filter, and the
two skills' divergences every time.

## The two files

- **Source:** `~/code/Work/orm-claude-tech-writing/skills/tech-writing/SKILL.md`
  — a git repo. Where the changes you're porting were usually made first; you
  read from it, never write to it.
- **Target:** `~/.dotkyl/home/claude/skills/tech-writing--personal/SKILL.md`
  — the original skill, the file in *this* repo you edit.

If the work repo isn't present on this machine, stop and tell the user — the
sync can't run without it.

## What to port, what to skip

The work skill covers things this repo's skill intentionally doesn't. Port only
the **general tech-writing guidance**. Skip:

- **Devdocs content** — guidance specific to writing in the devdocs
  documentation repository: its conventions, structure, categorization scheme,
  site generator, the separate reference file the work skill keeps for it, or the
  handoff paragraph pointing readers at that file. This repo's skill delegates
  devdocs writing elsewhere and deliberately omits this content.
- **Plugin mechanics** — version bumps, the plugin's own `CLAUDE.md`, anything
  under `.claude-plugin/`. These don't touch `SKILL.md`, so scoping your git log
  to `-- skills/tech-writing/SKILL.md` already excludes them.

Everything else — new rules, sharpened examples, reworded guidance, scope
tweaks — ports.

## Known divergences

The two files have partly diverged. Where a hunk lands in a section that hasn't
diverged, port it verbatim. Only adapt wording where the hunk touches one of the
divergences below — don't reword a section that still matches. Ways this repo's
skill differs from the work skill:

- **Robot-voice / re-explain triggers** in the description ("explain it like a
  robot", "robotify that", re-explaining a confusing explanation in the same
  conversation) that the work skill doesn't have. Preserve them.
- **A "Re-explaining a confusing explanation" section** that the work skill
  removed. Preserve it.
- **No devdocs content** — the description, the intro, and the tutorial-warmth
  parenthetical don't reference the devdocs repo; they point at this skill's own
  scope instead. Keep it that way when a ported hunk touches those spots.

A hunk from the work skill may land in a paragraph this repo's skill has
reworded, or add a section this repo doesn't have yet. Match on meaning, not
exact text. A brand-new section of general guidance is still a port — add it,
placed sensibly. Skip a hunk only when its missing counterpart is a deliberate
divergence (e.g. it edits the devdocs handoff paragraph this repo dropped), never
just because the text is new here.

## Procedure

1. Find what's new in the work skill. Read the last-synced sha from
   `.claude/skills/sync-tech-writing/.last-synced` (a gitignored, per-machine
   file). If it exists, list work commits since it:

   ```
   git -C ~/code/Work/orm-claude-tech-writing log <sha>..HEAD --oneline -- skills/tech-writing/SKILL.md
   ```

   No `.last-synced` file (first run on this machine)? Diff the two files directly
   to find what this repo's skill is missing:

   ```
   diff ~/.dotkyl/home/claude/skills/tech-writing--personal/SKILL.md \
        ~/code/Work/orm-claude-tech-writing/skills/tech-writing/SKILL.md
   ```

2. Walk each new commit (or each diff region), `git show`ing it so you see the
   hunks. For each hunk, decide port-or-skip using the filter above.

3. Apply the ported hunks to the target, adapting wording only where they touch a
   divergence. Report per hunk what you ported, what you skipped, and why.

4. Record what you synced to. Write the work repo's current HEAD sha to
   `.claude/skills/sync-tech-writing/.last-synced` so the next run only looks at
   commits since. Get it with:

   ```
   git -C ~/code/Work/orm-claude-tech-writing rev-parse HEAD
   ```

   The file is gitignored — it's local sync state, not repo content, since the
   work repo (and thus this sync) only exists on the machine that has it.

## Commit

Use the `commit` skill. Area prefix `skills:`. Don't commit until the user has
reviewed the ported changes.

Write the commit message to describe the change itself — what the guidance now
says and why — not the fact that it was ported from the work skill. The message
records what changed here; where it came from is provenance the reader doesn't
need. Don't mention the work skill, the port, or "fold in" in the message.
