# Shell Config

My Unix shell configurations using [Oh My Zsh](https://ohmyz.sh/) and [Oh My Bash](https://ohmybash.nntoan.com/).

Works on Windows, macOS, and Linux (probably &ast;BSD too)


## Windows

### Prerequisites

- Install [scoop](https://scoop.sh)
- Use scoop to install `msys2` package
- Open a MSYS2 shell (run `msys2` in powershell after installing with scoop)
- Edit `/etc/nsswitch.conf` and change `db_home` to `windows`
- Install `curl` and `zsh` using `pacman`

### Install

```sh
git clone git@github.com:MB3hel/shellconfig.git ~/.shellconfig
cd ~/.shellconfig
./install.sh
./update_msys2.sh
```

### Update

```sh
cd ~/.shellconfig
git pull
./update_msys2.sh
```


## macOS

### Prerequisites

- Brew and bash (technically optional)

### Install

```sh
git clone git@github.com:MB3hel/shellconfig.git ~/.shellconfig
cd ~/.shellconfig
./install.sh
```

### Update

```sh
cd ~/.shellconfig
git pull
```


## Linux Install

### Prerequisites

- Install zsh and curl

### Install

```sh
git clone git@github.com:MB3hel/shellconfig.git ~/.shellconfig
cd ~/.shellconfig
./install.sh
```

### Update

```sh
cd ~/.shellconfig
git pull
```


## Environment Variables (Linux / macOS / Unix)

*On windows, this method will not set variables system wide. Just for zsh and bash shells. Use windows methods instead.*

*On macOS and Linux, this is "system-wide" on a per-user basis.*

- Use `~/.profile` for environment variables (shared with all shells; must use sh syntax). This has access to `append_path`, `prepend_path`, and `remove_path` functions. They should be used to modify the PATH.
- `~/.zprofile` and `~/.bash_profile` can be edited for shell-specific vars or syntax. Both of these files source `.profile`. 
- Note that changes are not applied immediately for interactive shells. Bash only sources `.bash_profile` for a login shell and zsh only sources `.zprofile` for login shells. Thus, an X session will have to be restarted (logout then back in).
- Do not edit `~/.zprofile`, `~/.bash_profile`, `~/.zshrc`, or `~/.bashrc` unless absolutely necessary. Profile should generally work. Just keep sh syntax / features.


## Git Setup

### Windows

Enable the OpenSSH agent in windows services. 

Note: autocrlf is enabled explicitly in global git config. This ensures consistent behavior between native (scoop) git and MSYS2 git.

Sometimes, the shell prompt is slow on windows due to git. The following settings seem to help a little

```
git config --global core.preloadindex true
git config --global core.fscache true
git config --global pack.window 1
git config --global gc.auto 256
```

### macOS

Nothing special is setup here. macOS runs an agent. Note: Adding `AddKeysToAgent yes` to `~/.ssh/config` will make so you only have to type git key passwords once until logout.


### Linux

I typically use gnome, which runs an ssh agent, prompts for keys, and keeps them until logout. Thus, nothing special is setup here. 

For environments where the desktop does not manage an ssh agent create the file `~/.shell_manage_ssh-agent`. This will cause the profile script to manage an agent. Note: Adding `AddKeysToAgent yes` to `~/.ssh/config` will make so you only have to type git key passwords once until logout.


## Windows Command Priority

In the windows setup, there are multiple environments at play (standard windows and MSYS2). The path is modified to have the following priorities

- `~/msys2-override/bin`: For wrappers such as `bash` and `find` to override windows commands with MSYS2 ones (*note: the content of this directory will be deleted and re-written when running update_msys2.sh*)
- The default profile prepends `~/bin` and `~/.local/bin` to the path if they exist (so they have higher priority)
- Windows path entries
- MSYS2 commands


## Package Mangers

- Windows: scoop and MSYS2 pacman (typically, native windows tools from scoop are preferred when available)
- macOS: Brew
- Linux: Native system package manager


## MSYS2 (Windows)

On windows, the entire setup relies on MSYS2. This can make it harder to use the MSYS2 isolated environments as intended. Thus, a `msys2launch` script is included (installed to `~/bin`). This script launches an isolated `msys2` environment.

Usage:

```
msys2launch [environment]
```

Where `[environment]` is `mingw64`, `mingw32`, or any other MSYS2 environment name.
