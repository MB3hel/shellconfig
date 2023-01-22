# Shell Config

Unix shell configurations using [Oh My Zsh](https://ohmyz.sh/) and [Oh My Bash](https://ohmybash.nntoan.com/)

Clone repo to `~/.shellconfig` and run `install.sh`.

NOTE: If using windows, install `msys2` using [scoop](https://scoop.sh). Make sure to install zsh and curl in msys2 first and change `db_home` to `windows` in `/etc/nsswitch.conf`.

Use `~/.profile` for environment variables (shared with all shells; must use sh syntax). `~/.zprofile` and `~/.bash_profile` can be edited for shell-specific vars or syntax. Both of these files source `.profile`. Note that they are not applied immediately for interactive shells. Bash only sources `.bash_profile` for a login shell and zsh only sources `.zprofile` for login shells. Thus, an X session will have to be restarted (logout then back in). This will also not work for wayland sessions since there is no login shell for wayland sessions.
