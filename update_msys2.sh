#!/usr/bin/env bash

DIR=$(realpath $(dirname "$0"))

# Required for MSYS2 setup on windows for native zsh and bash
if [[ "$(uname -o)" == "Msys" ]]; then
    mkdir -p ~/bin
    
    # Using exe launchers instead to avoid stupid "terminate batch script" behavior
    # Make sure old bat launchers do not exist though
    rm ~/bin/zsh.bat 2> /dev/null
    rm ~/bin/bash.bat 2> /dev/null
    
    # Write exe launchers if they don't alredy exist
    if [ ! -f ~/bin/zsh.exe ]; then
        cp "$DIR/msys2/zsh.exe" ~/bin/zsh.exe
    fi
    if [ ! -f ~/bin/bash.exe ]; then
        cp "$DIR/msys2/bash.exe" ~/bin/bash.exe
    fi

    cp "$DIR/msys2/msys2launch" ~/bin/msys2launch     # Launch a normal msys2 isolated environment
    
    # Forces msys2 git to work like windows git
    # Avoids issues since msys2 git used in git plugin of zsh prompt
    git config --global core.autocrlf true
    
    # Override some windows commands
    # Ex: bash will be wsl bash by default.
    # This causes problems running scripts
    if ! [ -d ~/msys2-override-bin/ ]; then
        mkdir ~/msys2-override-bin/
    else
        rm -rf ~/msys2-override-bin/
        mkdir ~/msys2-override-bin/
    fi
    

    # overrides handle with exe wrapper now
    # Prevents issues with tools trying to run the bash scripts with cmd or powershell (nvim, vscode, etc)
    cp "$DIR/msys2/override-exes"/*.exe ~/msys2-override-bin
    echo "THIS DIRECTORY'S CONTENTES WILL BE DELETED BY UPDATES" > ~/msys2-override-bin/WARNING.txt
fi
