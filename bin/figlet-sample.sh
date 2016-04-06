#!/usr/bin/env bash

fonts=(
banner big block bubble digital ivrit lean mini mnemonic script shadow slant 
small smscript smshadow smslant standard term
)

[ -z "${1}" ] && text="Milton & Emilie" || text="${1}"

for f in ${fonts[@]}; do echo $f && figlet -f $f "${text}"; done
