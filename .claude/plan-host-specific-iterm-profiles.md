# Plan: Host-Specific iTerm Profiles via Symlinks

**Purpose:** Eliminate `SetProfile` escape sequence for the default (dark) palette by making
each host's default iTerm profile the correct one natively.

## Problem

`SetProfile` escape sequences cause iTerm to asynchronously reset tab titles on idle tabs.
This only happens when switching to a profile that differs from the tab's current profile.
On the personal machine (Air), the default profile is "Tomorrow Dark Mod" but the shell
needs "Tomorrow Dark Mod Air" (smaller font), so every new tab gets a `SetProfile` call.

## Approach

Use `manage-symlinks`'s existing host-specific symlink support. The existing profile
(e.g. "Tomorrow Dark Mod") becomes a base profile that host-specific profiles inherit from:

- `iterm/3.tomorrow-dark-mod--personal.json` — inherits Tomorrow Dark Mod, overrides font
  size for Air screen. Set as the default profile on the personal machine.
- `iterm/3.tomorrow-dark-mod--work.json` — inherits Tomorrow Dark Mod, explicit font size
  for work machine. Set as the default profile on the work machine.

The iterm symlinks are already set up in `symlinks.yml` the same as other host-specific
files, so no `manage-symlinks` changes are needed.

New tabs open with the correct profile natively. No `SetProfile` needed on shell init for
dark mode.

## Limitations

- Only solves the default palette (dark mode). Light mode still requires `SetProfile` to
  switch to a different profile, which still causes the title reset on idle tabs.

## Dependencies

- `setup/manage-symlinks` host-specific symlink support (already implemented)

## Status

Proposed. Not yet started.
