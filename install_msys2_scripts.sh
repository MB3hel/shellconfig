#!/usr/bin/env bash

# Required for MSYS2 setup on windows for native zsh and bash
if [[ "$(uname -o)" == "Msys" ]]; then
	mkdir -p ~/bin
    cp "$DIR/msys2/zsh.bat" ~/bin/zsh.bat
	cp "$DIR/msys2/bash.bat" ~/bin/bash.bat
    cp "$DIR/msys2/mys2launch" ~/bin/msys2launch     # Launch a normal msys2 isolated environment
    
    # Forces msys2 git to work like windows git
    # Avoids issues since msys2 git used in git plugin of zsh prompt
    git config --global core.autocrlf true
    
    # Override some windows commands
    # Ex: bash will be wsl bash by default.
    # This causes problems running scripts
    mkdir ~/msys2-override-bin/
    printf '#!/usr/bin/bash\n/usr/bin/bash "$@"' > ~/msys2-override-bin/bash
    printf '#!/usr/bin/bash\n/usr/bin/find "$@"' > ~/msys2-override-bin/find
fi