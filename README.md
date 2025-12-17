# Shell Config

My Unix shell configurations.


## Install (Anything but Windows)

Linux/BSD prerequisites: git, bash, zsh

macOS prerequisites: git, bash (newer version from brew)

```sh
git clone git@github.com:MB3hel/shellconfig.git ~/.shellconfig
cd ~/.shellconfig
./install.sh
```

## Windows Install (using MSYS2 - Recommended)

Windows prerequisites: git

```sh
# Start in CMD
cd /d "%USERPROFILE%"
git clone git@github.com:MB3hel/shellconfig.git .shellconfig
cd .shellconfig
.\msys2_install.cmd
.\msys2bin\bash.cmd --login -i

# Now in bash
pacman -S zsh
./install.sh
```

(Optional) Add `%USERPROFILE%\.shellconig\msys2bin` to your user's PATH variable (allows running bash.cmd or zsh.cmd from windows shells)

(Optional) Add windows terminal profiles if desired:

```
{
    "bellStyle": "none",
    "closeOnExit": "always",
    "commandline": "%USERPROFILE%\\.shellconfig\\msys2bin\\zsh.cmd --login -i",
    "guid": "{a9bab809-8bec-4bbf-886b-8c352a43d37b}",
    "name": "zsh (native)",
    "startingDirectory": "%USERPROFILE%"
},
{
    "bellStyle": "none",
    "closeOnExit": "always",
    "commandline": "%USERPROFILE%\\.shellconfig\\msys2bin\\bash.cmd --login -i",
    "guid": "{a9bab809-8bec-4bbf-886b-8c352a43d37a}",
    "name": "bash (native)",
    "startingDirectory": "%USERPROFILE%"
}
```

## Shell Startup Files

This repo configures both bash and zsh to behave in a similar way: login shells source the profile script. Interactive shells source the rc script. This is default behavior for zsh. However, bash by default would not source the rc for interactive login shells. Here it does. Essentially

- Bash (login): sources `.bash_profile`
- Bash (login, interactive): sources `.bash_profile` then sources `.bashrc`
- Bash (interactive): sources `.bashrc`
- Zsh (login): soruces `.zprofile`
- Zsh (login, interactive): sources `.zprofile` then sources `.zshrc`
- Zsh (interactive): sources `.zshrc`

Environment variables should be set / modified in whichever profile script is your user's login shell (see chsh command). The rc files should not modify variables unless making changes that should only apply to interactive sessions. Because of this a new login is often needed to see changes.

## SSH Agent

If no SSH agent is already running, login shells will start one that can be shared by any interactive shell launched from within that shell (eg GUI terminal emulators or tmux). On macOS and GNOME, an SSH agent will already be running.

The SSH agent will be terminated at logout to ensure keys are locked.

Note: Adding `AddKeysToAgent yes` to `~/.ssh/config` will make so you only have to unlock keys once until log out.
