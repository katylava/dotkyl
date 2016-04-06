#!/bin/sh

# script for optimizing images in a directory (recursive)
# pngcrush & jpegtran settings from:
# http://developer.yahoo.com/performance/rules.html#opt_images

# pngcrush
for png in `find $1 -iname "*.png"`; do
    echo "crushing $png ..."
    pngcrush -rem alla -reduce -brute "$png" temp.png

    # preserve original on error
    if [ $? = 0 ]; then
        mv -f temp.png $png
    else
        rm temp.png
    fi
done

# jpegtran
for jpg in `find $1 -iname "*.jpg"`; do
    echo "crushing $jpg ..."
    jpegtran -copy none -optimize -perfect "$jpg" > temp.jpg

    # preserve original on error
    if [ $? = 0 ]; then
        mv -f temp.jpg $jpg
    else
        rm temp.jpg
    fi
done