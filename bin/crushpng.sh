#!/usr/bin/env bash

[ ! -d /tmp/crushpng ] && mkdir /tmp/crushpng
pngcrush -rem gAMA -rem cHRM -rem iCCP -rem sRGB "${1}" "${1}.crushed"
mv "${1}" /tmp/crushpng
mv "${1}.crushed" "${1}"

echo "Crushed. Old file can be found at /tmp/crushed/${1}."
