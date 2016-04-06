#!/usr/bin/env bash

brew list | grep $1 && echo "(brew)"
pip list | grep $1 && echo "(pip)"
npm -g list --depth 0 2> /dev/null | grep $1 && echo "(npm)"
gem list | grep $1 && echo "(gem)"

cd ~/Code/gocode && go list ./... | grep $1 && echo "(go)"
