#!/usr/bin/env sh

# Directory this script is in
DIR="$(dirname "$0")"

# Move files that have templates to .bak versions
mv ~/.bashrc ~/.bashrc.bak 2> /dev/null
mv ~/.bash_profile ~/.bash_profile.bak 2> /dev/null
mv ~/.profile ~/.profile.bak 2> /dev/null
mv ~/.zprofile ~/.zprofile.bak 2> /dev/null
mv ~/.zshrc ~/.zshrc.bak 2> /dev/null

# Install templates
cp "$DIR/template/bash_profile.template" ~/.bash_profile
cp "$DIR/template/bashrc.template" ~/.bashrc
cp "$DIR/template/profile.template" ~/.profile
cp "$DIR/template/zprofile.template" ~/.zprofile
cp "$DIR/template/zshrc.template" ~/.zshrc
