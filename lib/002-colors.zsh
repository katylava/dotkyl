# ---------------------
# Palette switching
# ---------------------

_PALETTE_STATE="$HOME/.local/state/terminal-palette"
_STARSHIP_LIGHT="$HOME/.local/state/starship-light.toml"

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
    export LS_COLORS="$(vivid generate $VIVID_THEME)"
    if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
        if [[ "$mode" == "light" ]]; then
            set-iterm-profile "Tomorrow Light Mod"
        else
            set-iterm-profile "Tomorrow Dark Mod"
        fi
    fi
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

# ---------------------
# Other colors
# ---------------------


autoload -U colors && colors
