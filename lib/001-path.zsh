export PATH=/usr/local/share/npm/bin:/usr/local/opt/coreutils/libexec/gnubin:~/Code/gocode/bin:~/.dotkyl/bin:$PATH
export GOPATH=~/Code/gocode

function node_repl_path {
    [ -d ./node_modules ] && export NODE_PATH="${PWD}/node_modules"
}

precmd_functions+=(node_repl_path)
