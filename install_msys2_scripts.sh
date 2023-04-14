#!/usr/bin/env bash

DIR=$(realpath $(dirname "$0"))

override(){
    printf "#!/usr/bin/bash\n/usr/bin/$1" > ~/msys2-override-bin/$1
    printf ' "$@"' >> ~/msys2-override-bin/$1
}

# Required for MSYS2 setup on windows for native zsh and bash
if [[ "$(uname -o)" == "Msys" ]]; then
	mkdir -p ~/bin
    cp "$DIR/msys2/zsh.bat" ~/bin/zsh.bat
	cp "$DIR/msys2/bash.bat" ~/bin/bash.bat
    cp "$DIR/msys2/msys2launch" ~/bin/msys2launch     # Launch a normal msys2 isolated environment
    
    # Forces msys2 git to work like windows git
    # Avoids issues since msys2 git used in git plugin of zsh prompt
    git config --global core.autocrlf true
    
    # Override some windows commands
    # Ex: bash will be wsl bash by default.
    # This causes problems running scripts
    if ! [ -d ~/msys2-override-bin/ ]; then
        mkdir ~/msys2-override-bin/
    fi
    

    override bash       # Use native bash not wsl wrapper
    override find       # windows has a find command? It doesn't do what I want.

    # Windows openssh just breaks git clone and other things, so force MSYS2 git and ssh
    override ssh
    override ssh-agent
    override ssh-add
    override git
fi
