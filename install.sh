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

# Move files that have templates to .bak versions
mv ~/.bashrc ~/.bashrc.bak
mv ~/.bash_profile ~/.bash_profile.bak
mv ~/.profile ~/.profile.bak
mv ~/.zprofile ~/.zprofile.bak
mv ~/.zshrc ~/.zshrc.bak

# Install templates
cp "$DIR/template/bash_profile.template" ~/.bash_profile
cp "$DIR/template/bashrc.template" ~/.bashrc
cp "$DIR/template/profile.template" ~/.profile
cp "$DIR/template/zprofile.template" ~/.zprofile
cp "$DIR/template/zshrc.template" ~/.zshrc
mkdir -p ~/.config/plasma-workspace/env/
cp "$DIR/template/plasmaenv.sh.template" ~/.config/plasma-workspace/env/profile.sh
cp "$DIR/template/dircolors_conf" ~/.dircolors

# Extras for MSYS2 on windows
if [ "$(uname -o)" = "Msys" ]; then
    # Install the shell launcher exes so "bash" "zsh" and "sh" in a windows shell (eg cmd or
    # powershell) will run the "native" (via standalone msys2) bash, zsh, or sh on windows (not WSL)
    mkdir -p ~/bin
    cp "$DIR/msys2launchers/bin/"*.exe ~/bin/

    # MSYS2's default zshenv defines PROMPT which makes a mess of things when trying to invoke cmd
    # from one of the MSYS2 shells. Just get rid of it. Not needed in this standalone environment
    # anyway
    mv /etc/zsh/zshenv /etc/zsh/zshenv.bak 2> /dev/null
fi

