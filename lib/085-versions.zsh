function _set_versions {
    findup .node-version >/dev/null
    [ $? -eq 0 ] && { eval "$(nodenv init -)" }
    findup .python-version >/dev/null
    [ $? -eq 0 ] && { eval "$(pyenv init -)" }
}

precmd_functions+=(_set_versions)
