# zstyle :compinstall filename '~/.zshrc'

autoload -Uz compinit

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

fpath=(~/.dotkyl/completion /usr/local/share/zsh-completions $fpath)

compinit

# Too fucking slow
# if [ $commands[kubectl] ]; then
#   source <(kubectl completion zsh)
# fi
#

source /Users/kathleenlavalle/Code/Vendor/google-cloud-sdk/completion.zsh.inc
