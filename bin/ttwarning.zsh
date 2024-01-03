#! /usr/bin/env zsh

PROJECT=$(timetrace status -f '{project}')

test "$PWD" != "/Users/kyl/Code/pct" && exit 1

[[ "${PROJECT}" = '---' || "${PROJECT}" =~ 'today' ]] && exit 0

exit 1
