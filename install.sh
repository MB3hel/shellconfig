#!/usr/bin/env bash

# Directory this script is in
DIR=$(realpath $(dirname "$0"))

# ~/.shellconfig is hard coded in various files.
if [ "$(realpath "$DIR")" != "$(realpath "$HOME/.shellconfig")" ]; then
    echo "Must clone to ~/.shellconfig" >&2
    exit 1
fi

# Install templates from this repo unless they already exist
# The templates generally just load files from this repo but are intended to be customized
# with machine specific additions (so we don't want to override once installed)
# But a user may need to run install.sh again to install *new* templates when updating the repo
# $1 = template
# $2 = destination
install-template(){
    local temp_l1="$(grep "$1" -e 'SHELLCONFIG REPO TEMPLATE')"
    local dest_l1=""
    [ -f "$2" ] && dest_l1="$(grep "$2" -e 'SHELLCONFIG REPO TEMPLATE')"
    if [ -f "$2" ] && [ "$temp_l1" = "$dest_l1" ]; then
        echo "Skip    $2 (already a template)"
        return 0
    fi

    # Otherwise backup the original and install the template
    echo "Install $2"
    if [ -f "$2" ]; then
        mv "$2" "$2.bak"
    fi
    cp "$1" "$2"
}

# Install a link if nothing already exists
# This is not often used in this repo as most files are templates to pull in changes
# directly from this repo as it is pulled, but to allow per-machine modifications
# Some files don't support this though
# $1 = target (absolute paths only)
# $2 = destination (link name)
install-link(){
    if [ -f "$2" ] && [ "$(readlink "$2")" = "$1" ]; then
        echo "Skip    $2 (already linked)"
        return 0
    fi

    echo "Link    $2"
    if [ -f "$2" ]; then
        mv "$2" "$2.bak"
    fi
    ln -s "$1" "$2"
}


# Install bash & zsh shell config templates
install-template "$DIR/template/bash_profile.template" ~/.bash_profile
install-template "$DIR/template/bashrc.template" ~/.bashrc
install-template "$DIR/template/zprofile.template" ~/.zprofile
install-template "$DIR/template/zshrc.template" ~/.zshrc

# Older versions of shellconfig relied heavily on ~/.profile. This is no longer the case
# So to avoid confusing myself, get rid of it
if [ -f ~/.profile ]; then
    echo "Remove  $HOME/.profile"
    mv ~/.profile ~/.profile.bak
    echo "# *** USE ~/.bash_profile OR ~/.zprofile INSTEAD!!!" >> ~/.profile.bak
fi

# Templates for plasma desktop
if [ "$(uname -o)" != "Msys" ] && [ "$(uname -o)" != "Darwin" ]; then
    mkdir -p ~/.config/plasma-workspace/env/
    install-template "$DIR/template/plasma_profile.sh.template" ~/.config/plasma-workspace/env/plasma_profile.sh
    mkdir -p ~/.config/plasma-workspace/shutdown/
    install-template "$DIR/template/plasma_logout.sh.template" ~/.config/plasma-workspace/shutdown/plasma_logout.sh
    chmod +x ~/.config/plasma-workspace/shutdown/plasma_logout.sh
    mkdir -p ~/.local/share/konsole/
    install-link "$DIR/konsole_tango.colorscheme" ~/.local/share/konsole/Tango.colorscheme
fi


