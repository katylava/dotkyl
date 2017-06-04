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
tar -czvf ~/Dropbox/CleanInstall/Code-Personal.tgz --exclude={node_modules,.venv} ~/Code/Personal/

tar -czvf ~/Dropbox/CleanInstall/Library-Application-Support.tgz ~/Library/Application\ Support/

cp -R ~/Library/Fonts ~/Dropbox/CleanInstall/Library-Fonts
cp -R ~/Library/Preferences ~/Dropbox/CleanInstall/Library-Preferences

cp -Rv ~/.config ~/Dropbox/CleanInstall/dot-config
cp -Rv ~/.ngrok2 ~/Dropbox/CleanInstall/dot-ngrok2
cp -Rv ~/.ssh ~/Dropbox/CleanInstall/dot-ssh

cp ~/.histfile ~/Dropbox/CleanInstall/dot-histfile
cp ~/.pyfreecell.db ~/Dropbox/CleanInstall/dot-pyfreecell.db
cp ~/.dotkyl/lib/000-private.zsh

# TODO: Add warnings if there is anything in ~/Code/Work that isn't synced to Github

