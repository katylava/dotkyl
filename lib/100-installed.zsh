export EDITOR=nvim

# Fixes for some brew/pip installs
export CFLAGS=-Qunused-arguments
export CPPFLAGS=-Qunused-arguments

export DEFAULT_CHEAT_DIR=~/Dropbox/CheatSheets
export CHEATCOLORS=true

export GIT_PAGER='less -m -X --quit-at-eof'

export HH_CONFIG=hicolor

export LINESCH_AUTHOR=katy
export LINESCH_PATHS=~/Code/Work/:$GOPATH/src/github.com/oreillymedia/:$GOPATH/src/github.com/safarijv/

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# https://github.com/zsh-users/zsh-syntax-highlighting/issues/411#issuecomment-317109904
zle -N history-substring-search-up; zle -N history-substring-search-down

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# must come after zsh-syntax-highlighting
source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh

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
