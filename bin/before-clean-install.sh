#!/usr/bin/env bash


test -d ~/Dropbox/CleanInstall || mkdir ~/Dropbox/CleanInstall

cd ~/Dropbox/CleanInstall

echo "Creating lists of installed apps, libs, packages, etc."

ls /Applications > applications.txt
brew list > brew.txt
gem list > gem.txt
go list ... > go.txt
npm ls -g --depth 0 > npm.txt
pip freeze > pip.txt
pip3 freeze > pip3.txt

echo "Backing up certain files to Dropbox."
echo "BUT it's really better to just back up entire home directory to an external drive."

tar -czvf ~/Dropbox/CleanInstall/Desktop.tgz --exclude={node_modules,.venv} ~/Desktop/
tar -czvf ~/Dropbox/CleanInstall/Code-Vendor.tgz --exclude={node_modules,.venv} ~/Code/Vendor/
tar -czvf ~/Dropbox/CleanInstall/Code-Playground.tgz --exclude={node_modules,.venv} ~/Code/Playground/
tar -czvf ~/Dropbox/CleanInstall/Code-Incubator.tgz --exclude={node_modules,.venv} ~/Code/Incubator/
tar -czvf ~/Dropbox/CleanInstall/Code-Web.tgz --exclude={node_modules,.venv} ~/Code/Web/
tar -czvf ~/Dropbox/CleanInstall/Code-Mediocre-Experiments.tgz --exclude={node_modules,.venv} ~/Code/Mediocre/experiments/

cp -r ~/Library/Fonts ~/Dropbox/CleanInstall/Library-Fonts
cp -r ~/Library/Preferences ~/Dropbox/CleanInstall/Library-Preferences

cp -r ~/.config/pgcli ~/Dropbox/CleanInstall/dot-config-pgcli
cp -r ~/.ngrok2 ~/Dropbox/CleanInstall/dot-ngrok2
cp -r ~/.ssh ~/Dropbox/CleanInstall/dot-ssh

cp ~/.histfile ~/Dropbox/CleanInstall/dot-histfile
cp ~/.pyfreecell.db ~/Dropbox/CleanInstall/dot-pyfreecell.db
cp ~/.dotkyl/lib/000-private.zsh
