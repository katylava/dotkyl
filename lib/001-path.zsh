typeset -U path

# $path is a magical variable from which $PATH is set
path=(
    /usr/local/opt/curl/bin
    /usr/local/opt/python/libexec/bin
    /usr/local/share/npm/bin
    /usr/local/opt/coreutils/libexec/gnubin
    ~/Code/gocode/bin
    ~/.dotkyl/bin
    ~/google-cloud-sdk/bin
    $path
)
export PATH
export GOPATH=~/Code/gocode

function node_repl_path {
    [ -d ./node_modules ] && export NODE_PATH="${PWD}/node_modules"
}

precmd_functions+=(node_repl_path)
