---
name: markdown-conventions
description: Conventions for writing or editing markdown. Use whenever you are writing or editing a .md or .markdown file.
---

# Markdown conventions

Rules for writing and editing markdown in any repo.

## Blank line before lists

Always include a blank line before a list (ordered or unordered). Some
renderers won't recognize the list otherwise.

## No two tildes on one line

In markdown prose, don't put two `~` characters on the same line. Some
renderers I use pair them into strikethrough. A single `~` (e.g. `~100ms`) is
fine; two on one line (e.g. "takes ~100ms and ~3 retries") is not. Rewrite one
or both as "about" or "roughly". Tildes inside backtick code spans are fine.

## Don't renumber numbered lists item-by-item

If an insertion or deletion shifts numbers in a numbered list, do **not** fix
it with sequential Edit calls — that's slow and easy to get wrong. Pick one:

- Use `sed` to renumber in one shot.
- Leave gaps in the numbering (markdown renderers don't care).
- Switch to an unordered list.

## Wrapping markdown

When asked to wrap a markdown file, use:

```
prettier --prose-wrap always --print-width 80 --write <file.md> 2>&1
```
