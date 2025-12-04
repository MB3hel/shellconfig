# Shell Config

Minimal bash configuration that can be used on any Linux system with standard software (mostly meaning bash) without a bunch of third party dependencies

Intended to provide something good enough on systems that I can't install much on

Features:
- Bash only (no zsh)
- Custom prompt with git status, arrow, venv info
- Bashrc sourced for login scripts
- SSH agent management

## Install

```sh
git clone git@github.com:MB3hel/shellconfig.git ~/.shellconfig
cd ~/.shellconfig
./install.sh
```
