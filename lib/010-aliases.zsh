# safety
alias r='rm -ir'
alias rem='rmtrash'

# listing and grepping
alias lgrep='ll | grep'
# alias ll='gls --color=auto -NFalh'
# alias ls='gls --color=auto -NFh'
alias la='lsd -Fa'
alias ll='lsd -Fal'
alias ls='lsd -F'
alias exa='exa -F --icons'

# frequently edited files
alias edit.aliases='nvim ~/.dotkyl/lib/*aliases.zsh'
alias edit.kubeconf='nvim ~/.kube/config'
alias edit.npmrc='nvim ~/.npmrc'
alias edit.path='nvim ~/.dotkyl/lib/*path.zsh'
alias edit.profile='nvim ~/.zshrc'
alias edit.prompt='nvim ~/.dotkyl/lib/*prompt.zsh'
alias edit.vimrc='nvim ~/.dotkyl/nvim/init.vim'
alias unstuck='nvim ~/Dropbox/desktop/unstuck.md'

# switch npmrc
alias npm.coc='cp ~/.npmrc.coc ~/.npmrc'
alias npm.work='cp ~/.npmrc.work ~/.npmrc'

# things i forget
alias cmdfreq='fc -l 1 | awk '\''{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}'\'' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n25'
alias diff2html='pygmentize -f html -O style=colorful,full -l diff -O encoding=utf-8'
alias eject='hdiutil detach'
alias encoding="vim -c 'execute \"silent !echo \" . &fileencoding | q'"
alias ezrsync='rsync -avhC --progress --no-o'
alias flushdns='sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder && say "flushed DNS"'
alias history='fc -ilD 1'
alias killcam='sudo killall AppleCameraAssistant; sudo killall VDCAssistant'
alias locate='glocate'
alias locip='ifconfig | grep "inet " | grep -v 127.0.0.1 | cut -d " " -f 2 | head -n 1'
alias noderl='env NODE_NO_READLINE=1 rlwrap node'
alias rpass='</dev/urandom tr -dc A-Za-z0-9 | head -c 10'
alias updatedb="export LC_ALL='C' && sudo gupdatedb"

# things i just hate typing
alias bat='bat --theme="Dracula"'
alias browse='gh repo view --web'
alias dc='docker compose'
alias dice='rolldice -s'
alias edocker='eval "$(docker-machine env default)"'
alias epyenv='eval "$(pyenv init -)"'
alias enodenv='eval "$(nodenv init -)"'
alias freecell='python3 ~/Code/Projects/pyfreecell/freecell.py -w6'
alias jira='jira-cli'
alias k='kubectl'
alias kc='kubectl config use-context'
alias kcc='kubectl config current-context'
alias kd='ksc dev-gke'
alias kgp='kubectl get pods'
alias kl='kubectl logs'
alias klist="kubectl config view -o jsonpath='{.contexts[*].name}'"
alias kp='ksc prod-gke'
alias ql='qlmanage -p 2>/dev/null'
alias sopr='source ~/.zshrc'
alias t='todolist'
alias tabview='tabview --width max'
alias tree='tree -I "*.pyc|node_modules|__pycache__"'
alias year='gcal $(date +%Y)'
