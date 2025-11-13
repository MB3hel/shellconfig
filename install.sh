#!/usr/bin/env bash

# Directory this script is in
DIR=$(realpath $(dirname "$0"))

# Check for curl, zsh, and bash
if ! type "curl" > /dev/null; then
    echo "curl must be installed first."
    exit 1
fi
if ! type "zsh" > /dev/null; then
    echo "zsh must be installed first."
    exit 1
fi
if ! type "bash" > /dev/null; then
    echo "bash must be installed first."
    exit 1
fi

# Install oh my zsh and oh my bash
if [[ ! -d ~/.oh-my-zsh ]]; then
    export RUNZSH='no'
    curl https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | zsh -s --
fi
if [[ ! -d ~/.oh-my-bash ]]; then
    curl https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh | bash -s -- --unattended
fi

# Install templates from this repo unless they already exist
# The templates generally just load files from this repo but are intended to be customized
# with machine specific additions (so we don't want to override once installed)
# But a user may need to run install.sh again to install *new* templates when updating the repo
# $1 = template
# $2 = destination
install-template(){
    # If the destination exists and is already one of the templates, skip reinstall
    if [ -f "$2" ] && grep -F -e '*** THIS FILE IS A SHELLCONFIG REPO TEMPLATE ***' "$2" >/dev/null; then
        echo "Skip    $2 (already a template)"
        return 0
    fi

    # Otherwise backup the original and install the template
    echo "Install $2"
    mv "$2" "$2.bak"
    cp "$1" "$2"
}

# Install shell config templates
install-template "$DIR/template/bash_profile.template" ~/.bash_profile
install-template "$DIR/template/bashrc.template" ~/.bashrc
install-template "$DIR/template/profile.template" ~/.profile
install-template "$DIR/template/zprofile.template" ~/.zprofile
install-template "$DIR/template/zshrc.template" ~/.zshrc

# Templates for plasma desktop
if [ "$(uname -o)" != "Msys" ] && [ "$(uname -o)" != "Darwin" ]; then
    mkdir -p ~/.config/plasma-workspace/env/
    install-template "$DIR/template/plasmaenv.sh.template" ~/.config/plasma-workspace/env/profile.sh
fi

# Extras for MSYS2 on windows
if [ "$(uname -o)" = "Msys" ]; then
    # Really no good way to do this via script due to how windows does user and system PATH vars
    # Just do it manually
    echo "Make sure $(cygpath -w "$DIR/msys2launchers/bin") is in your path"

    # MSYS2's default zshenv defines PROMPT which makes a mess of things when trying to invoke cmd
    # from one of the MSYS2 shells. Just get rid of it. Not needed in this standalone environment
    # anyway
    mv /etc/zsh/zshenv /etc/zsh/zshenv.bak 2> /dev/null
fi

