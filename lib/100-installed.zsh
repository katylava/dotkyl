export EDITOR=nvim

# Fixes for some brew/pip installs
export CFLAGS=-Qunused-arguments
export CPPFLAGS=-Qunused-arguments

export DEFAULT_CHEAT_DIR=~/Dropbox/CheatSheets
export CHEATCOLORS=true

export GIT_PAGER='less -m -X --quit-at-eof'

export HH_CONFIG=hicolor

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

pyenv() {
    eval "$(pyenv init -)"
    pyenv "$@"
}
j() {
    eval "$(jump shell zsh)"
    j "$@"
}
fuck() {
    eval $(thefuck --alias)
    fuck
}

# This is not worth the startup time
# [[ $(docker-machine status default) != 'Stopped' ]] && eval "$(docker-machine env default)"
