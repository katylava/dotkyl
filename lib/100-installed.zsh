brew_prefix=`brew --prefix`

export EDITOR=nvim

# Fixes for some brew/pip installs
export CFLAGS=-Qunused-arguments
export CPPFLAGS=-Qunused-arguments

export DEFAULT_CHEAT_DIR=~/Dropbox/CheatSheets
export CHEATCOLORS=true

export GPG_TTY=$(tty)

export HH_CONFIG=hicolor

export LINESCH_AUTHOR=katy
export LINESCH_PATHS=~/Code/Work/:$GOPATH/src/github.com/oreillymedia/:$GOPATH/src/github.com/safarijv/

source $brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# https://github.com/zsh-users/zsh-syntax-highlighting/issues/411#issuecomment-317109904
zle -N history-substring-search-up; zle -N history-substring-search-down

source $brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# must come after zsh-syntax-highlighting
source $brew_prefix/share/zsh-history-substring-search/zsh-history-substring-search.zsh


eval "$(pyenv init -)"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
# the following are a little slow
# eval "$(pyenv virtualenv-init -)"
# eval "$(pyenv virtualenv-init - | sed s/precmd/chpwd/g)"
