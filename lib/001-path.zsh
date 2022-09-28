typeset -U path

# $path is a magical variable from which $PATH is set
# shims for nodenv an pyenv are added later by their init commands
path=(
    ~/.dotkyl/bin
    ~/.fzf/bin
    ~/node_modules/.bin
    ~/go/bin
    ~/google-cloud-sdk/bin
    /opt/homebrew/bin
    /usr/local/bin
    /usr/bin
    /bin
    /usr/sbin
    /sbin
)

export PATH
export GOPATH=~/go

function node_repl_path {
    [ -d ./node_modules ] && export NODE_PATH="${PWD}/node_modules"
}

precmd_functions+=(node_repl_path)
