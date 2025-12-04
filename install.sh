#!/usr/bin/env bash

# Directory this script is in
DIR=$(realpath $(dirname "$0"))

# Install templates from this repo unless they already exist
# The templates generally just load files from this repo but are intended to be customized
# with machine specific additions (so we don't want to override once installed)
# But a user may need to run install.sh again to install *new* templates when updating the repo
# $1 = template
# $2 = destination
install-template(){
    # If the destination exists and is already one of the templates, skip reinstall
    if [ -f "$2" ] && grep -F -e '*** THIS FILE IS A MIN SHELLCONFIG REPO TEMPLATE ***' "$2" >/dev/null; then
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

# Install shell config templates
install-template "$DIR/template/bash_profile.template" ~/.bash_profile
install-template "$DIR/template/bashrc.template" ~/.bashrc

