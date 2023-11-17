# Shell Config

My Unix shell configurations using [Oh My Zsh](https://ohmyz.sh/) and [Oh My Bash](https://ohmybash.nntoan.com/).



## Install

- Linux prerequisites: zsh and curl
- macOS prerequisites: brew and newer bash installed from brew

```sh
git clone git@github.com:MB3hel/shellconfig.git ~/.shellconfig
cd ~/.shellconfig
./install.sh
```

## Shell Startup Files

[Useful Diagrams](https://medium.com/@rajsek/zsh-bash-startup-files-loading-order-bashrc-zshrc-etc-e30045652f2e)

- `sh`: Usually either `dash`, `ash`, or `bash` in POSIX compliance mode
    - Sources `/etc/profile`
    - Sources `~/.profile`
- `bash` login shells (interactive or not)
    - Sources `/etc/profile`
    - Sources the first found of: `~/.bash_profile`, `~/.bash_login`, `~/.profile` (in that order)
- `bash` interactive shells (non-login)
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
    - `~/.bash_profile`: Sources `~/.bash_profile`. Also sources `~/.bashrc` if interactive too.
- `bash` interactive (non login)
    - `~/.bashrc`
- `zsh` login (interactive or not):
    - `~/.zprofile`: Sources `~/.profile` in sh compatibility mode
- `zsh` interactive (login or not):
    - `~/.zshrc`

This behavior essentially defines the following

- Login shells (interactive or not) source `~/.profile`
- Interactive shells (login or not) source their rc file

This repo provides "base files" for each of the following.

- `~/.profile` sources `~/.shellconfig/profile_script`
- `~/.bashrc` sources `~/.shellconfig/bash/bashrc`
- `~/.zshrc` sources `~/.shellconfig/zsh/zshrc`

## Environment Variables

- Place environment variables in `~/.profile` using posix sh syntax (no bash or zsh specific syntax). Use the `append_path` `prepend_path` and `remove_path` functions when modifying the path.
- These will apply in all login shells for the user. Note that they don't apply to scripts run as the user with no login shell (eg from systemd or launchd running a script as these have no login context).
- Note that interactive non-login shells won't detect environment changes unless you manually source the shell's profile script. Thus on Linux desktops, you have to log out / back in before changes take effect (even if relaunching terminal emulator).

Some notes about login vs interactive shells

- Starting a terminal with bash / zsh using MSYS2 on windows is a login interactive shell
- macOS: Terminal app runs shells as login and interactive.
- Linux Desktop:
    - Starting desktop (X11 or wayland) uses a login shell (thus `~/.profile` is sourced for GUI session)
    - Shell in terminal emulator is usually interactive non-login
- Linux Console: Runs an interactive login shell
- SSH: Runs a login interactive shell (same as logging into console on Linux)


## SSH Agent

On Windows, the SSH agent runs as a system service with a constant pipe. As such, `SSH_AUTH_SOCK` is not used by OpenSSH on windows. Thus, these scripts do not manage an SSH agent on windows. It is always assumed that the OS has one running as a system service.

For other systems (macOS, Linux, BSD) these scripts *may* launch / manage an SSH agent. If the environment defines `SSH_AUTH_SOCK` before starting a login shell (before `~/.profile` is sourced), these scripts will not launch / manage an agent. This occurs on macOS and Liunx when logging into the GNOME desktop.

If the environment does not provide an SSH agent, `SSH_AUTH_SOCK` will not be defined when `~/.profile` is sourced. In this case, the shell manages an SSH agent. This occurs on Linux / BSD with console logins, Xfce sessions, or other contexts in which the environment does not provide an SSH agent.

Note that I intentionally avoid using solutions that share / re-use agents across login shells.

By using this agent environment file, multiple shells can use the same agent (even for sepearte logins of the same user) and shells can reuse the agent if it was started before logging out and back in (same user).

Note: Adding `AddKeysToAgent yes` to `~/.ssh/config` will make so you only have to unlock keys once until log out.
