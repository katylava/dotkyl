# ---------------------
# Palette switching
# ---------------------

_PALETTE_STATE="$HOME/.local/state/terminal-palette"

function _apply_palette {
    local mode="${1:-dark}"
    if [[ "$mode" == "light" ]]; then
        export TERM_PALETTE=light
        export BAT_THEME="OneHalfLight"
        export VIVID_THEME="catppuccin-latte"
        export DELTA_FEATURES="light-mode"
        sed -i '' 's/^palette = "dark"/palette = "light"/' ~/.dotkyl/home/config/starship.toml
    else
        export TERM_PALETTE=dark
        export BAT_THEME="Dracula"
        export VIVID_THEME="jellybeans"
        unset DELTA_FEATURES
        sed -i '' 's/^palette = "light"/palette = "dark"/' ~/.dotkyl/home/config/starship.toml
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
    local mode="${1:-dark}"
    if [[ "$mode" != "light" && "$mode" != "dark" ]]; then
        echo "Usage: palette [light|dark]"
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
