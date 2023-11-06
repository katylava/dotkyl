#!/usr/bin/env bash

brew list | grep $1 && echo "(brew)"
pip list | grep $1 && echo "(pip)"
pip3 list | grep $1 && echo "(pip3)"
npm -g list --depth 0 2> /dev/null | grep $1 && echo "(npm)"
gem list | grep $1 && echo "(gem)"

cd ~/code/gocode && go list ./... | grep $1 && echo "(go)"
