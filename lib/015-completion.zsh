# The following lines were added by compinstall
zstyle :compinstall filename '/Users/kyl/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# the rest is copied from oh-my-zsh because i assume it makes completion nicer...

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on succesive tab press
setopt complete_in_word
setopt always_to_end

zmodload -i zsh/complist
zstyle ':completion:*' list-colors ''

# makes completion case-insensitive, and something about hyphens i don't know
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
