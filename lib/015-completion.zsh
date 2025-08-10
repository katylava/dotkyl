# zstyle :compinstall filename '~/.zshrc'

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on succesive tab press
setopt complete_in_word
setopt always_to_end

zmodload -i zsh/complist
zstyle ':completion:*' list-colors ''

# makes completion case-insensitive, and something about hyphens i don't know
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# only complete local git branches
# WHY DOES THIS NOT WORK?!
zstyle :completion::complete:git-checkout:argument-rest:headrefs command "git for-each-ref --format='%(refname)' refs/heads 2>/dev/null"

fpath=(~/.dotkyl/completion $(brew --prefix)/share/opt/zsh-completions $fpath)

# source /Users/kyl/google-cloud-sdk/completion.zsh.inc

# dynamic completion is bad for compinit performance
# eval "$(op completion zsh)"; compdef _op op # 1password CLI

autoload -Uz compinit
compinit -C # -C is supposed to speed up compinit, but i can't tell
