# Shell Config

My Unix shell configurations.


## Install (Anything but Windows)

- Linux/BSD prerequisites: bash, zsh, curl
- macOS prerequisites: brew and newer bash installed from brew

```sh
git clone git@github.com:MB3hel/shellconfig.git ~/.shellconfig
cd ~/.shellconfig
./install.sh
```

## Windows Install

On windows, a standalone msys2 install (separate from msys2 installed by scoop or via msys2 installer) is used to provide a minimal and clean unix-like environment on windows including bash and zsh shells. While you can install packages in this environment using `pacman` it is recommended to install as few packages as possible. It is intended that this is used to provide a "native" bash or zsh for windows (meaning the native windows commands should be used not pacman packages). Even tools such as python, git, vim, etc should be installed using native windows methods (eg scoop pacakge manager) not pacman.

The standalone msys2 environment will coexist with other msys2 environments (eg one installed using scoop). As such, scoop's mingw64, ucrt64, etc commands will still work as expected from windows shells. However, if launching from the native bash or zsh shell, use winlaunch

Note that when you run windows commands from the "native" bash and zsh shells, the MSYS2 enviroment changes (eg PATH) are preserved unless using `winlaunch`. Eg `winlaunch cmd` to launch a clean cmd shell from bash or zsh. If you keep the set of packages in the standalone msys2 environment minimal, this should rarely be necessary.

Note that `bash.exe`, `zsh.exe`, and `sh.exe` wrappers are provided to use the "native" shells vs WSL. These require `%USERPROFILE%\bin` appear in your path. Note that when invoked these are not run as login shells automatically. If you want the profile script to apply (you do) make sure to run bash --login or zsh --login not just bash or zsh if coming from a windows shell. If already in a zsh or bash shell, the existing login settings can be kept instead.

Finally, note that other msys2 installs should not be configured to use the windows home directory or they will try to use these bashrc and zshrc files (may or may not work as expected). Make sure db_home is left as `cygwin desc` in `/etc/nsswitch.conf`.

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
        "commandline": "%USERPROFILE%\\bin\\zsh.exe --login -i",
        "guid": "{a9bab809-8bec-4bbf-886b-8c352a43d37b}",
        "name": "zsh (native)",
        "startingDirectory": "%USERPROFILE%"
    },
    {
        "bellStyle": "none",
        "closeOnExit": "always",
        "commandline": "%USERPROFILE%\\bin\\bash.exe --login -i",
        "guid": "{a9bab809-8bec-4bbf-886b-8c352a43d37a}",
        "name": "bash (native)",
        "startingDirectory": "%USERPROFILE%"
    }
    ```

## Shell Startup Files

[Useful Diagrams](https://medium.com/@rajsek/zsh-bash-startup-files-loading-order-bashrc-zshrc-etc-e30045652f2e)

`sh` (usually either `dash`, `ash`, or `bash` in POSIX compliance mode):

- `sh`: Usually either `dash`, `ash`, or `bash` in POSIX compliance mode
    - Sources `/etc/profile`
    - Sources `~/.profile`
- `bash` login shells (interactive or not)
    - Sources `/etc/profile`
    - Sources the first found of: `~/.bash_profile`, `~/.bash_login`, `~/.profile` (in that order)
- `bash` interactive shells (non-login ONLY)
    - Sources `/etc/bash.bashrc`
    - Sources `~/.bashrc`
- `bash` non-interactive and non-login (eg running a script)
    - Sources file that `BASH_ENV` variable expands to
    - Could be used to define environment vars for a script invoked from systemd, launchd, etc
- `zsh`
    - `/etc/zshenv`
    - `~/.zshenv`
    - `/etc/zprofile` (if login shell)
    - `~/.zprofile` (if login shell)
    - `/etc/zshrc` (if interactive)
    - `~/.zshrc` (if interactive)
    - `/etc/zlogin` (if login)
    - `/etc/.zlogin` (if login)

The setup in this repo is as follows. Only user files are considered. This is facilitated by the templates this repo provides.

- `sh`:
    - `~/.profile`
- `bash` login:
    - `~/.bash_profile`: Sources `~/.profile`. Also sources `~/.bashrc` if interactive too.
- `bash` interactive (non login)
    - `~/.bashrc`
- `zsh` login (interactive or not):
    - `~/.zprofile`: Sources `~/.profile` in sh compatibility mode
- `zsh` interactive (login or not):
    - `~/.zshrc`

This behavior essentially defines the following

- Login shells (interactive or not) source `~/.profile`
- Interactive shells (login or not) source their own rc file
- Sourced in order: `~/.profile` -> shell rc file

This repo provides "base files" for each of the following.

- `~/.profile` sources `~/.shellconfig/profile_script`
- `~/.bashrc` sources `~/.shellconfig/bash/bashrc`
- `~/.zshrc` sources `~/.shellconfig/zsh/zshrc`
- Additionally provides `~/.shellconfig/aliases` which is automatically run by the RC files (or by profile if neither bash or zsh).

## Environment Variables

- Place environment variables in `~/.profile` using posix sh syntax (no bash or zsh specific syntax). Use the `append_path` `prepend_path` and `remove_path` functions when modifying the path.
- These will apply in all login shells for the user. Note that they don't apply to scripts run as the user with no login shell (eg from systemd or launchd running a script as these have no login context).
- Note that interactive non-login shells won't detect environment changes unless you manually source the shell's profile script. Thus on Linux desktops, you have to log out / back in before changes take effect (even if relaunching terminal emulator).

Some notes about login vs interactive shells

- WSL starts a login shell (when using `wsl -d DistroName`)
- Starting a terminal with bash / zsh using MSYS2 on windows is a login interactive shell
- macOS: Terminal app runs shells as login and interactive.
- Linux Desktop:
    - Starting desktop (X11 or wayland) uses a login shell (thus `~/.profile` is sourced for GUI session)
    - Shell in terminal emulator is usually interactive non-login
    - Tmux by default starts login interactive shells (though my config switches this to nonlogin)
- Linux Console: Runs an interactive login shell
- SSH: Runs a login interactive shell (same as logging into console on Linux)


## SSH Agent

These scripts *may* launch / manage an SSH agent. If the environment defines `SSH_AUTH_SOCK` before starting a login shell (before `~/.profile` is sourced), these scripts will not launch / manage an agent. This occurs on macOS or on Linux when logging into some GUI desktops (eg GNOME).

If the environment does not provide an SSH agent, `SSH_AUTH_SOCK` will not be defined when `~/.profile` is sourced. In this case, the login shell manages an SSH agent. This occurs on Linux / BSD with console logins, reomte console logins (eg ssh, telnet), Xfce sessions, or other contexts in which the environment does not provide an SSH agent.

Essentially, unless the login starts an SSH agent, the intial login SHELL will. Any subsequent shells (login or not) will share the same SSH agent. This also means that shells that can "switch" between different logins (eg tmux detach and re-attach) will need to change SSH agents to their new logins. There is a `fixssh` function to do this.

Note that I intentionally avoid using solutions that share / re-use agents across login shells. User logout (termination of the login shell) that started the agent will terminate the agent and force the next login to unlock keys again.

Note: Adding `AddKeysToAgent yes` to `~/.ssh/config` will make so you only have to unlock keys once until log out.
