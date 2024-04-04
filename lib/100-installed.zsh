brew_prefix=`brew --prefix`

export EDITOR=nvim

# Fixes for some brew/pip installs
export CFLAGS=-Qunused-arguments
export CPPFLAGS=-Qunused-arguments

export DEFAULT_CHEAT_DIR=~/Library/Mobile\ Documents/com~apple~CloudDocs/CheatSheets
export CHEATCOLORS=true

export DOCKER_CLI_HINTS=false

export GPG_TTY=$(tty)

export HH_CONFIG=hicolor

export LINESCH_AUTHOR=katy
export LINESCH_PATHS=~/code/Work/:$GOPATH/src/github.com/oreillymedia/:$GOPATH/src/github.com/safarijv/

export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# fzf-tab:
# must come before zsh-autosuggestions, zsh-syntax-highlighting, etc.
# https://github.com/Aloxaf/fzf-tab
# (note that it must also come after compinit)
source ~/code/Vendor/fzf-tab/fzf-tab.plugin.zsh
zstyle ':completion:*:git-checkout:*' sort false # disable sort when completing `git checkout`
zstyle ':completion:*:descriptions' format '[%d]' # set descriptions format to enable group support
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # set list-colors to enable filename colorizing
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --color=always $realpath' # preview directory's content with lsd when completing cd
zstyle ':fzf-tab:*' switch-group ',' '.' # switch group with , and . (default is F1/F2)

source $brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# https://github.com/zsh-users/zsh-syntax-highlighting/issues/411#issuecomment-317109904
zle -N history-substring-search-up; zle -N history-substring-search-down

source $brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# must come after zsh-syntax-highlighting
source $brew_prefix/share/zsh-history-substring-search/zsh-history-substring-search.zsh

# 1password cli github cli plugin
source /Users/kyl/.config/op/plugins.sh

# asdf
source $brew_prefix/opt/asdf/libexec/asdf.sh


# would prefer to init pyenv as needed, but it's easier to point to pyenv shims
# for my neovim python_host_prog, so i always need it.
# eval "$(pyenv init -)"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
# the following are a little slow
# eval "$(pyenv virtualenv-init -)"
# eval "$(pyenv virtualenv-init - | sed s/precmd/chpwd/g)"

# would prefer init nodenv as needed, but copilot requires node < 18. i keep
# the non-nodenv version updated to latest, so need nodenv to set a < 18 global
# version.
# eval "$(nodenv init -)"
