# Shell Config

Unix shell configurations using [Oh My Zsh](https://ohmyz.sh/) and [Oh My Bash](https://ohmybash.nntoan.com/)

Clone repo to `~/.shellconfig` and run install.sh

Use `~/.profile` for environment variables (shared with all shells; must use sh syntax). `~/.zprofile` and `~/.bash_profile` can be edited for shell-specific vars or syntax.

Note: On windows, the scripts are written assuming msys2 has been installed using [scoop](https://scoop.sh). Some paths will need to be modified if not. Also, make sure zsh is installed in msys2 before running the install script. Additionally, make sure `db_home` is set to `windows` in `/etc/nsswitch.conf`
