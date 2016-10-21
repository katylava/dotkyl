# safety
alias r='rm -ir'
alias rem='rmtrash'

# listing and grepping
alias lgrep='ll | grep'
alias ll='gls --color=auto -NFalh'
alias ls='gls --color=auto -NFh'

# frequently edited files
alias edit.aliases='nvim ~/.dotkyl/lib/*aliases.zsh'
alias edit.mediocre='nvim ~/Code/Mediocre/notes/Mediocre.md'
alias edit.profile='nvim ~/.zshrc'
alias edit.prompt='nvim ~/.dotkyl/lib/*prompt.zsh'
alias edit.vimrc='nvim ~/.dotkyl/nvim/init.vim'

# things i forget
alias diff2html='pygmentize -f html -O style=colorful,full -l diff -O encoding=utf-8'
alias eject='hdiutil detach'
alias encoding="vim -c 'execute \"silent !echo \" . &fileencoding | q'"
alias ezrsync='rsync -avhC --progress --no-o'
alias flushdns='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder && say "flushed DNS"'
alias history='fc -il 1'
alias locate='glocate'
alias locip='ifconfig | grep "inet " | grep -v 127.0.0.1 | cut -d " " -f 2 | head -n 1'
alias noderl='env NODE_NO_READLINE=1 rlwrap node'
alias rpass='</dev/urandom tr -dc A-Za-z0-9 | head -c 10'
alias updatedb='export LC_ALL='C' && sudo gupdatedb'

# things i just hate typing
alias dice='rolldice -s'
alias freecell='~/Code/Incubator/pyfreecell/freecell.py -w 8 -o 2'
alias ql='qlmanage -p'
alias sopr='source ~/.zshrc'
alias tabview='tabview --width max'
alias tree='tree -I "*.pyc" -I node_modules'
alias year='gcal $(date +%Y)'
