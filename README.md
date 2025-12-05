# Shell Config

My Unix shell configurations.


## Install (Anything but Windows)

- Linux/BSD prerequisites: bash, zsh
- macOS prerequisites: brew and newer bash installed from brew

```sh
git clone git@github.com:MB3hel/shellconfig.git ~/.shellconfig
cd ~/.shellconfig
./install.sh
```

## Windows Install

TODO: Script this

On windows, a standalone msys2 install (separate from msys2 installed by scoop or via msys2 installer) is used to provide a minimal and clean unix-like environment on windows including bash and zsh shells. While you can install packages in this environment using `pacman` it is recommended to install as few packages as possible. It is intended that this is used to provide a "native" bash or zsh for windows (meaning the native windows commands should be used not pacman packages). Even tools such as python, git, vim, etc should be installed using native windows methods (eg scoop pacakge manager) not pacman.

The standalone msys2 environment will coexist with other msys2 environments (eg one installed using scoop). As such, scoop's mingw64, ucrt64, etc commands will still work as expected from windows shells. However, if launching from the native bash or zsh shell, use winlaunch

Note that when you run windows commands from the "native" bash and zsh shells, the MSYS2 enviroment changes (eg PATH) are preserved unless using `winlaunch`. Eg `winlaunch cmd` to launch a clean cmd shell from bash or zsh. If you keep the set of packages in the standalone msys2 environment minimal, this should rarely be necessary.

Note that `bash.exe`, `zsh.exe`, and `sh.exe` wrappers are provided to use the "native" shells vs WSL. These require `%USERPROFILE%\bin` appear in your path. Note that when invoked these are not run as login shells automatically. If you want the profile script to apply (you do) make sure to run bash --login or zsh --login not just bash or zsh if coming from a windows shell. If already in a zsh or bash shell, the existing login settings can be kept instead.

Finally, note that other msys2 installs should not be configured to use the windows home directory or they will try to use these bashrc and zshrc files (may or may not work as expected). Make sure `db_home` is left as `cygwin desc` in `/etc/nsswitch.conf`.

**Install Instructions:**

- Install git on windows (natively on windows eg using scoop)
- Download MSYS2 base package tarball from latest release on [GitHub](https://github.com/msys2/msys2-installer/releases)
- Extract the tarball to `C:\Users\USERNAME\` and rename `msys64` to `standalonemsys2`
- Launch `msys2.exe`
- Install zsh using `pacman -S zsh`
- Edit `/etc/nsswitch.conf` to set `db_home` to `windows`
- Edit `msys2.ini` and set `MSYS2_PATH_TYPE=inherit`
- Close and re-open `msys2.exe`
- Clone and install this repo using commands in the Linux / Unix section
- You probably want `%USERPROFILE%\bin` in your path
- Add windows terminal profiles 
    ```
    {
        "bellStyle": "none",
        "closeOnExit": "always",
        "commandline": "%USERPROFILE%\\.shellconfig\\msys2launchers\bin\\zsh.exe --login -i",
        "guid": "{a9bab809-8bec-4bbf-886b-8c352a43d37b}",
        "name": "zsh (native)",
        "startingDirectory": "%USERPROFILE%"
    },
    {
        "bellStyle": "none",
        "closeOnExit": "always",
        "commandline": "%USERPROFILE%\\.shellconfig\\msys2launchers\\bin\\bash.exe --login -i",
        "guid": "{a9bab809-8bec-4bbf-886b-8c352a43d37a}",
        "name": "bash (native)",
        "startingDirectory": "%USERPROFILE%"
    }
    ```
- Add `%USERPROFILE%\.shellconig\msys2launchers` to your users PATH variable

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
