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
    # Only install template if the same template was not previously installed
    # If the first line of the template is changed, a new version will be installed
    local temp_l1="$(head -1 "$1")"
    local dest_l1=""
    [ -f "$2" ] && dest_l1="$(head -1 "$2")"
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

# Install bash & zsh shell config templates
install-template "$DIR/template/bash_profile.template" ~/.bash_profile
install-template "$DIR/template/bashrc.template" ~/.bashrc

# Older versions of shellconfig relied heavily on ~/.profile. This is no longer the case
# So to avoid confusing myself, get rid of it
if [ -f ~/.profile ]; then
    echo "Remove  $HOME/.profile"
    mv ~/.profile ~/.profile.bak
    echo "# *** USE ~/.bash_profile OR ~/.zprofile INSTEAD!!!" >> ~/.profile.bak
fi

