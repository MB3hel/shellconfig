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
./install_msys2_scripts.sh
```

### Update

```sh
cd ~/.shellconfig
git pull
./install_msys2_scripts.sh
```


## macOS

TODO


## Linux Install

### Prerequisties

- Install zsh and curl

### Install

```sh
git clone git@github.com:MB3hel/shellconfig.git ~/.shellconfig
cd ~/.shellconfig
./install.sh
```

## Update

```sh
cd ~/.shellconfig
git pull
```


## Environment Variables

*On windows, this method will not set variables system wide. Just for zsh and bash shells. On macOS and Linux, this is "system-wide" on a per-user basis.*

- Use `~/.profile` for environment variables (shared with all shells; must use sh syntax). 
- `~/.zprofile` and `~/.bash_profile` can be edited for shell-specific vars or syntax. Both of these files source `.profile`. 
- Note that changes are not applied immediately for interactive shells. Bash only sources `.bash_profile` for a login shell and zsh only sources `.zprofile` for login shells. Thus, an X session will have to be restarted (logout then back in).
- Do not edit `~/.zprofile`, `~/.bash_profile`, `~/.zshrc`, or `~/.bashrc` unless absolutely necessary. Profile should generally work. Just keep sh syntax / features.


## Git Setup

TODO


## Windows Command Priority

TODO


## Package Mangers

TODO

