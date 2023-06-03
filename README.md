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



## Environment Variables

*This is "system-wide" on a per-user basis.*

- Use `~/.profile` for environment variables (shared with all shells; must use sh syntax). This has access to `append_path`, `prepend_path`, and `remove_path` functions. They should be used to modify the PATH.
- `~/.zprofile` and `~/.bash_profile` can be edited for shell-specific vars or syntax. Both of these files source `.profile`. 
- Note that changes are not applied immediately for interactive shells. Bash only sources `.bash_profile` for a login shell and zsh only sources `.zprofile` for login shells. Thus, an X session will have to be restarted (logout then back in).
- Do not edit `~/.zprofile`, `~/.bash_profile`, `~/.zshrc`, or `~/.bashrc` unless absolutely necessary. Profile should generally work. Just keep sh syntax / features.


## Git Setup

### macOS

Nothing special is setup here. macOS runs an agent. Note: Adding `AddKeysToAgent yes` to `~/.ssh/config` will make so you only have to type git key passwords once until logout.


### Linux

I typically use gnome, which runs an ssh agent, prompts for keys, and keeps them until logout. Thus, nothing special is setup here. 

For environments where the desktop does not manage an ssh agent create the file `~/.shell_manage_ssh-agent`. This will cause the profile script to manage an agent. Note: Adding `AddKeysToAgent yes` to `~/.ssh/config` will make so you only have to type git key passwords once until logout.
