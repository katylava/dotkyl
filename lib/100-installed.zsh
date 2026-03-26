brew_prefix=/opt/homebrew

export EDITOR=nvim

# Fixes for some brew/pip installs
export CFLAGS=-Qunused-arguments
export CPPFLAGS=-Qunused-arguments

export CLAUDE_CODE_DISABLE_TERMINAL_TITLE=1
export DOCKER_CLI_HINTS=false

export GPG_TTY=$(tty)

export HH_CONFIG=hicolor

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

eval "$(mise activate zsh --shims)"
