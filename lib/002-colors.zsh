# ---------------------
# Palette switching
# ---------------------

_PALETTE_STATE="$HOME/.local/state/terminal-palette"
_STARSHIP_LIGHT="$HOME/.local/state/starship-light.toml"
ITERM_DARK_PROFILE="Tomorrow Dark Mod"
ITERM_LIGHT_PROFILE="Tomorrow Light Mod"

function _apply_palette {
    local mode="${1:-dark}"
    if [[ "$mode" == "light" ]]; then
        export TERM_PALETTE=light
        export BAT_THEME="OneHalfLight"
        export VIVID_THEME="catppuccin-latte"
        export DELTA_FEATURES="light-mode"
        cp ~/.dotkyl/home/config/starship.toml "$_STARSHIP_LIGHT"
        STARSHIP_CONFIG="$_STARSHIP_LIGHT" starship config palette light
        export STARSHIP_CONFIG="$_STARSHIP_LIGHT"
    else
        export TERM_PALETTE=dark
        export BAT_THEME="Dracula"
        export VIVID_THEME="jellybeans"
        unset DELTA_FEATURES
        unset STARSHIP_CONFIG
    fi
    local cache_file="$HOME/.local/state/ls-colors-${VIVID_THEME}"
    if [[ ! -f "$cache_file" ]]; then
        mkdir -p "$HOME/.local/state"
        vivid generate "$VIVID_THEME" > "$cache_file"
    fi
    export LS_COLORS="$(<$cache_file)"
}

function palette {
    if [[ "$1" == "status" ]]; then
        echo "TERM_PALETTE:    ${TERM_PALETTE:-default}"
        echo "BAT_THEME:       ${BAT_THEME:-default}"
        echo "VIVID_THEME:     ${VIVID_THEME:-default}"
        echo "DELTA_FEATURES:  ${DELTA_FEATURES:-default}"
        echo "STARSHIP_CONFIG: ${STARSHIP_CONFIG:-default}"
        echo "State file:      $(test -f $_PALETTE_STATE && echo 'present (light)' || echo 'absent (dark)')"
        return 0
    fi
    local mode="${1:-dark}"
    if [[ "$mode" != "light" && "$mode" != "dark" ]]; then
        echo "Usage: palette [light|dark|status]"
        return 1
    fi
    _apply_palette "$mode"
    if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
        if [[ "$mode" == "light" ]]; then
            set-iterm-profile "$ITERM_LIGHT_PROFILE"
        else
            set-iterm-profile "$ITERM_DARK_PROFILE"
        fi
        # Re-assert tab title after profile switch, since iTerm resets it to the profile name
        title $ZSH_THEME_TERM_TAB_TITLE_IDLE $ZSH_THEME_TERM_TITLE_IDLE
    fi
    mkdir -p "$(dirname $_PALETTE_STATE)"
    if [[ "$mode" == "light" ]]; then
        touch "$_PALETTE_STATE"
    else
        rm -f "$_PALETTE_STATE"
    fi
}

# Apply palette from state file on shell init
if [[ -f "$_PALETTE_STATE" ]]; then
    _apply_palette light
else
    _apply_palette dark
fi

# Defer iTerm profile switch to first prompt so it happens after 040-titles.zsh
# loads. The title hook then immediately overwrites the profile name iTerm sets.
if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    function _palette_init_profile {
        if [[ "$TERM_PALETTE" == "light" ]]; then
            set-iterm-profile "$ITERM_LIGHT_PROFILE"
        else
            set-iterm-profile "$ITERM_DARK_PROFILE"
        fi
        precmd_functions=("${(@)precmd_functions:#_palette_init_profile}")
        unfunction _palette_init_profile
    }
    precmd_functions+=(_palette_init_profile)
fi

# ---------------------
# Other colors
# ---------------------


autoload -U colors && colors
