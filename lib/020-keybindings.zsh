# Various stuff from the following:
# https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/vi-mode/vi-mode.plugin.zsh
# https://unix.stackexchange.com/a/344028
# https://superuser.com/a/353127
# http://pawelgoscicki.com/archives/2012/09/vi-mode-indicator-in-zsh-prompt/

### vi-mode stuff
export VIM_MODE=INS

function zle-keymap-select {
    VIM_MODE="${${KEYMAP/vicmd/NORM}/(main|viins)/INS}"
    # change cursor shape in iTerm2
    case $KEYMAP in
      vicmd)      print -n -- "\E]50;CursorShape=0\C-G";;  # block cursor
      viins|main) print -n -- "\E]50;CursorShape=1\C-G";;  # line cursor
    esac
    zle reset-prompt
    zle -R
}
zle -N zle-keymap-select

function zle-line-finish {
  VIM_MODE=INS
  print -n -- "\E]50;CursorShape=0\C-G"  # block cursor
}
zle -N zle-line-finish

bindkey -v # this is what enables vi-mode
bindkey -M vicmd '^[' undefined-key # bind escape in normal mode to nothing so it doesn't hang

# I guess `bindkey -v` overwrites the following, so we need to rebind them

# allow vv to edit the command line (standard behaviour)
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'vv' edit-command-line

# allow ctrl-h, ctrl-w, ctrl-? for char and word deletion (standard behaviour)
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^k' kill-line
bindkey '^u' backward-kill-line

# allow ctrl-r and ctrl-s to search the history
bindkey '^r' history-incremental-search-backward
bindkey '^s' history-incremental-search-forward

# allow ctrl-a and ctrl-e to move to beginning/end of line
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

### The following are needed regardless of if we are using vi-mode or not

bindkey -M menuselect '^o' accept-and-infer-next-history
# bindkey '\e[A' history-beginning-search-backward
# bindkey '\e[B' history-beginning-search-forward
bindkey '^N' autosuggest-accept
bindkey '\e[A' history-substring-search-up
bindkey '\e[B' history-substring-search-down
