---
name: write-script
description: Write or refactor shell scripts in this repo. Use when asked to create a new script in bin/, refactor an existing script, or review a script for style. Applies repo conventions and style principles.
---

# Write Script Skill for dotkyl

Follow these guidelines when writing or refactoring shell scripts in this repo.

## Language and tools

- Use `#!/usr/bin/env zsh` — this is a zsh-centric repo, no need for POSIX portability.
- Use `yq` for parsing TOML/YAML/JSON. Never use Python for parsing.
- Comment non-obvious zsh syntax (e.g., `${0:A:h}`, glob qualifiers, parameter expansion flags).

## Script structure

The user reads scripts top-down: scanning variables to understand what the script acts on, skipping past functions to the main logic to see how things are invoked, then reading individual functions on demand. Optimize for this reading path.

Organize scripts in this order:

1. **Shebang and header comment** — what the script does, briefly
2. **Constants** — `UPPER_CASE`, declared with `local`
3. **Global mutable state** — `lower_case`, declared with `local`
4. **Functions** — all functions defined before they're called
5. **Main logic** — the actual work, as short as possible; should read like pseudocode

The main logic section is the most important part — it's the reader's entry point. Function names must be clear enough that the main logic can be understood without scrolling up to read the function bodies.

## Style principles

### Functions should take explicit arguments
Don't rely on variables from an outer scope leaking into functions. Globals declared at the top are fine since they're clearly shared state, but loop variables or other locals should be passed as arguments.

### Extract loop bodies into functions
If a loop body is more than a few lines, extract it into a named function. This improves readability, naturally scopes variables, and makes the loop itself scannable.

### Earn your place
Don't add things that don't pull their weight — unnecessary counters, verbose inline output, early-exit checks for states that can't realistically happen. Every line should have a reason.

### DRY by composition
When two functions share logic, have one call the other. Don't duplicate code blocks.

### Locality of behavior
Single-use variables belong near where they're used, not grouped with globals at the top just for tidiness.

### Let the tool do the work
Push logic like filtering, defaulting, and transforming into tools like `yq` instead of reimplementing it in shell.

### No single-line functions
Always use multi-line format for functions, even short ones.

### Constants are UPPER_CASE
Variables that are set once and never modified should be `UPPER_CASE`. Avoid names that shadow common environment variables (e.g., use `DOTKYL_HOST` not `HOST`).

## Before finishing

- Read the final script top to bottom. Does the structure reveal intent? Can someone scan the main logic and understand what happens without reading every function body?
- Check that no loop variables leak into functions implicitly.
- Check that functions aren't duplicating each other's logic.
