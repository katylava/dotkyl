#!/usr/bin/env bash

test -d ~/Dropbox/CleanInstall || mkdir ~/Dropbox/CleanInstall

cd ~/Dropbox/CleanInstall

ls /Applications > applications.txt
brew list > brew.txt
gem list > gem.txt
go list ... > go.txt
npm ls -g --depth 0 > npm.txt
pip freeze > pip.txt
pip3 freeze > pip3.txt

tar -czvf ~/Dropbox/CleanInstall/Desktop.tgz ~/Desktop/
tar -czvf ~/Dropbox/CleanInstall/Code-Vendor.tgz ~/Code/Vendor/
tar -czvf ~/Dropbox/CleanInstall/Code-Playground.tgz ~/Code/Playground/
tar -czvf ~/Dropbox/CleanInstall/Code-Incubator.tgz ~/Code/Incubator/
tar -czvf ~/Dropbox/CleanInstall/Code-Web.tgz ~/Code/Web/
tar -czvf ~/Dropbox/CleanInstall/Code-Mediocre-Experiments.tgz ~/Code/Mediocre/experiments/
