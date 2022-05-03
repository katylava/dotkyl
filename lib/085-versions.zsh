function _set_versions {
    [ -z $NODENV_SHELL ] && {
        findup .node-version >/dev/null
        [ $? -eq 0 ] && { eval "$(nodenv init -)" }
    }
    # don't need the pyenv version because i'm using it globally
    # [ -z $PYENV_SHELL ] && {
    #     findup .python-version >/dev/null
    #     [ $? -eq 0 ] && { eval "$(pyenv init -)" }
    # }
}

precmd_functions+=(_set_versions)
