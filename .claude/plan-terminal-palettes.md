# Plan: Terminal Color Palettes

**Execute after:** plan-single-branch-dotfiles.md (uses per-host config conventions)

## Current State (as of 2026-03-14)

Light/dark switching is already implemented:
- `palette light|dark|status` command in `lib/002-colors.zsh`
- Switches: iTerm profile, bat theme, vivid LS_COLORS, delta features, starship palette
- State persists via `~/.local/state/terminal-palette`
- Per-host iTerm profile names via `ITERM_DARK_PROFILE` / `ITERM_LIGHT_PROFILE` vars
- `bin/set-iterm-profile` sends escape sequence to switch iTerm profiles
- Starship uses `[palettes.dark]` and `[palettes.light]` with semantic color names
- Nvim reads `$TERM_PALETTE` and has `:Light` / `:Dark` commands

**iTerm profiles** (`iterm/`): Dynamic Profile JSON files. `0.base.json` ("Base") is the root.
Other profiles inherit from Base (or Tomorrow Dark Mod) and override only what differs:
- Base — dark near-black background with custom ANSI colors
- NoBlur — inherits Base, tweaks blur/transparency only
- Tomorrow Dark Mod — inherits Base, replaces all colors with a Tomorrow Night variant
- Tomorrow Dark Mod Air — inherits Tomorrow Dark Mod, font size for Air screen
- Tomorrow Light Mod — inherits Base, Tomorrow Light colors
- Tomorrow Light Mod Air — inherits Tomorrow Light Mod, font size for Air screen
- Opaque — inherits Tomorrow Dark Mod, removes transparency
- Solarized Light Mod — inherits Base, replaces all colors with a light Solarized variant

What's limited:
- Hardcoded to exactly two modes (light/dark)
- Palette config is scattered across `002-colors.zsh`, `starship.toml`, and `nvim/init.vim`
- No way to preview or compare palettes without switching

## What "Alternate Colors" Means

A terminal color scheme has two layers:
1. The 8 ANSI accent colors (0–7) plus brights (8–15)
2. Semantic/UI colors — background, foreground, cursor, selection, bold — designed to look good
   against those accent colors

A "palette" is a complete pairing of both layers. The existing profiles already model this: Tomorrow
Dark Mod and Solarized Light Mod each replace all 16 ANSI colors plus all UI colors together.

## Palette Definition Format

A single `palettes.toml` defines all palettes. Each palette entry specifies:

```toml
[palettes.tomorrow-dark]
display_name = "Tomorrow Dark"
background = "dark"                        # "dark" or "light" — drives nvim, delta, starship base
iterm_profile = "Tomorrow Dark Mod"        # base profile name (host-specific variants resolved at runtime)
vivid_theme = "jellybeans"
bat_theme = "Dracula"
# ANSI colors for preview (hex) — used by `palette list` and `palette show`
fg = "#c5c8c6"
bg = "#1d1f21"
black = "#282a2e"
red = "#cc6666"
green = "#b5bd68"
yellow = "#f0c674"
blue = "#81a2be"
magenta = "#b294bb"
cyan = "#8abeb7"
white = "#c5c8c6"

[palettes.tomorrow-light]
display_name = "Tomorrow Light"
background = "light"
iterm_profile = "Tomorrow Light Mod"
vivid_theme = "catppuccin-latte"
bat_theme = "OneHalfLight"
fg = "#4d4d4c"
bg = "#ffffff"
black = "#000000"
red = "#c82829"
green = "#718c00"
yellow = "#f5871f"
blue = "#4271ae"
magenta = "#8959a8"
cyan = "#3e999f"
white = "#d6d6d6"

[palettes.solarized-light]
display_name = "Solarized Light"
background = "light"
iterm_profile = "Solarized Light Mod"
vivid_theme = "solarized-light"
bat_theme = "Solarized (light)"
fg = "#657b83"
bg = "#fdf6e3"
# ... etc
```

## Starship Integration

Starship palette sections in `starship.toml` use semantic names (`separator`, `frame`, `lang`,
etc.) that are independent of the underlying colors. Each palette in `palettes.toml` can optionally
define starship overrides, or the system can map `background = "dark"` / `"light"` to the existing
`[palettes.dark]` and `[palettes.light]` starship sections. If a palette needs custom starship
colors beyond the dark/light defaults, it can specify them in `palettes.toml` and the switching
script writes them to the starship state file.

## Host-Specific Profile Resolution

`palettes.toml` specifies the base iTerm profile name. Host-specific overrides can be added
per palette:

```toml
[palettes.tomorrow-dark.host_profiles]
personal = "Tomorrow Dark Mod Air"
work = "Tomorrow Dark Mod"
```

This depends on `bin/get-host` from plan-single-branch-dotfiles.md. Until that plan is done,
the current `ITERM_DARK_PROFILE` / `ITERM_LIGHT_PROFILE` approach works as a bridge.

## Commands

### `palette <name>`
Switch to a named palette. Updates iTerm profile, env vars (BAT_THEME, VIVID_THEME, LS_COLORS,
DELTA_FEATURES, TERM_PALETTE), starship config, and persists state.

### `palette status`
Show current palette name and all env var values (as it works now).

### `palette list`
Show all available palette names with a compact color preview. For each palette, print the
display name and a row of true-color (24-bit escape sequence) blocks using the hex values from
`palettes.toml` — background, foreground, and the 8 ANSI accent colors. This lets you compare
palettes visually without switching.

### `palette show [name]`
Show the full color grid for a palette — similar to `bin/print_colors` but using 24-bit
true-color escape sequences from the hex values in `palettes.toml`. Can preview any palette by
name without switching to it. With no argument, shows the currently active palette. Replaces
`bin/print_colors`.

## Implementation Steps

**1. Create `palettes.toml`** with entries for the existing palettes (Tomorrow
Dark, Tomorrow Light, and Solarized Light at minimum).

**2. Move palette logic from `lib/002-colors.zsh` to `bin/palette`** as a standalone shell
script. `lib/002-colors.zsh` reduces to sourcing the current palette state on shell init.
Use `yq` to read values from `palettes.toml`.

**3. Implement `palette list`** — reads all palette entries from `palettes.toml`, prints each
with true-color (24-bit) escape sequences: `\e[48;2;R;G;Bm` for background blocks,
`\e[38;2;R;G;Bm` for foreground text. This displays correctly in any true-color terminal
regardless of the current ANSI palette.

**4. Implement `palette show [name]`** — renders the full color grid (like `bin/print_colors`)
using 24-bit true-color escape sequences from the hex values in `palettes.toml`. Works for
any palette by name, not just the active one. With no argument, shows the currently active
palette. Replaces `bin/print_colors`.

**5. Update nvim** — instead of checking `$TERM_PALETTE` for "light", check for the
`background` value from the active palette. If keeping it simple, `TERM_PALETTE` can continue
to be set to the background value ("dark"/"light") since that's what nvim and delta care about.

**6. Add new palette JSON files** as desired — each new palette needs an iTerm profile JSON in
`iterm/` and an entry in `palettes.toml`.

**7. (Optional) `bin/iterm-colors`** — utility to extract hex color values from an iTerm Dynamic
Profile JSON (the float-RGB format is hard to read). Useful when creating new palette entries
in `palettes.toml`.

## Notes

- `palette <name>` only affects the current terminal session + future shells (via state file).
- `set-iterm-profile` only works in iTerm2. On other terminals, skip the profile switch but still
  set env vars so bat, vivid, delta, and starship adapt.
- `palette dark` and `palette light` with no prior palette selection should default to a
  reasonable palette (e.g., "tomorrow-dark" / "tomorrow-light").
