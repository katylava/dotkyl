# TODO: add stuff from https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/vi-mode/vi-mode.plugin.zsh
# ...more good stuff here: https://unix.stackexchange.com/a/344028
# ...and easier escape: https://superuser.com/a/353127
# http://pawelgoscicki.com/archives/2012/09/vi-mode-indicator-in-zsh-prompt/
bindkey -e
bindkey -M menuselect '^o' accept-and-infer-next-history
# bindkey '\e[A' history-beginning-search-backward
# bindkey '\e[B' history-beginning-search-forward
bindkey '^J' autosuggest-accept
