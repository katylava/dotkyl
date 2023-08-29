function _set_versions {
    [ -z $NODENV_SHELL ] && {
        findup .node-version >/dev/null
        [ $? -eq 0 ] && { eval "$(nodenv init -)" }
    }
    # commented out while i'm trying out asdf instead
    # [ -z $PYENV_SHELL ] && {
    #     findup .python-version >/dev/null
    #     [ $? -eq 0 ] && { eval "$(pyenv init -)" }
    # }
}

precmd_functions+=(_set_versions)
