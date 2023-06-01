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

Then in windows terminal or another terminal emulator, use the following command line for zsh and bash (change `pwsh.exe` to `powershell.exe` if you don't have powershell core installed)

- zsh: `pwsh.exe -noprofile -executionpolicy bypass C:\Users\mbehe\bin\zsh-launcher.ps1`
- bash: `pwsh.exe -noprofile -executionpolicy bypass C:\Users\mbehe\bin\bash-launcher.ps1`


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

Enable the OpenSSH agent in windows services. Then run `git config --global core.sshCommand C:\WINDOWS\System32\OpenSSH\ssh.exe`. If you have manually installed a newer build of OpenSSH-Win32 using the msi installer, run `git config --global core.sshCommand '"C:/Program Files/OpenSSH/ssh.exe"'` instead.

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

*Note that this only impacts the zsh and bash environments. This does not apply to native windows shells.*

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


## Windows Native Shell Fixes

Powershell and cmd (even if launched from zsh or bash) should not inherit the path and some other variables from the zsh / bash setup. This can cause issues. The following changes can be made to prevent this (this is not done automatically by the installer)

For powershell, add the following to your profile
- Windows Powershell (Legacy?): `~/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1`
- Powershell Core: `~/Documents/PowerShell/Microsoft.PowerShell_profile.ps1`

```ps1
# If launched from MSYS2 zsh / bash setup, some variables will be wrong.
if ([System.Environment]::GetEnvironmentVariable('MSYSTEM')){
    # Restore PATH, TMP, and TEMP from the MSYS2 ORIGINAL_ variables
    $Env:PATH = $Env:ORIGINAL_PATH
    $Env:TMP = $Env:ORIGINAL_TMP
    $Env:TEMP = $Env:ORIGINAL_TEMP
    
    # Unset all the variables set by MSYS2, zsh, or bash
    [System.Environment]::SetEnvironmentVariable("_", $null)
    [System.Environment]::SetEnvironmentVariable("COMP_WORDBREAKS", $null)
    [System.Environment]::SetEnvironmentVariable("CONFIG_SITE", $null)
    [System.Environment]::SetEnvironmentVariable("EDITOR", $null)
    [System.Environment]::SetEnvironmentVariable("HISTFILESIZE", $null)
    [System.Environment]::SetEnvironmentVariable("HISTIGNORE", $null)
    [System.Environment]::SetEnvironmentVariable("HISTSIZE", $null)
    [System.Environment]::SetEnvironmentVariable("HOME", $null)
    [System.Environment]::SetEnvironmentVariable("HOSTNAME", $null)
    [System.Environment]::SetEnvironmentVariable("INFOPATH", $null)
    [System.Environment]::SetEnvironmentVariable("LANG", $null)
    [System.Environment]::SetEnvironmentVariable("LC_CTYPE", $null)
    [System.Environment]::SetEnvironmentVariable("LESS", $null)
    [System.Environment]::SetEnvironmentVariable("LOGNAME", $null)
    [System.Environment]::SetEnvironmentVariable("LS_COLORS", $null)
    [System.Environment]::SetEnvironmentVariable("LSCOLORS", $null)
    [System.Environment]::SetEnvironmentVariable("MANPATH", $null)
    [System.Environment]::SetEnvironmentVariable("MSYS2_PATH_TYPE", $null)
    [System.Environment]::SetEnvironmentVariable("MSYS2WINFIRST", $null)
    [System.Environment]::SetEnvironmentVariable("MSYSCON", $null)
    [System.Environment]::SetEnvironmentVariable("MSYSTEM", $null)
    [System.Environment]::SetEnvironmentVariable("MSYSTEM_CARCH", $null)
    [System.Environment]::SetEnvironmentVariable("MSYSTEM_CHOST", $null)
    [System.Environment]::SetEnvironmentVariable("MSYSTEM_PREFIX", $null)
    [System.Environment]::SetEnvironmentVariable("OLDPWD", $null)
    [System.Environment]::SetEnvironmentVariable("ORIGINAL_PATH", $null)
    [System.Environment]::SetEnvironmentVariable("ORIGINAL_TEMP", $null)
    [System.Environment]::SetEnvironmentVariable("ORIGINAL_TMP", $null)
    [System.Environment]::SetEnvironmentVariable("OSH", $null)
    [System.Environment]::SetEnvironmentVariable("PAGER", $null)
    [System.Environment]::SetEnvironmentVariable("PKG_CONFIG_PATH", $null)
    [System.Environment]::SetEnvironmentVariable("PRINTER", $null)
    [System.Environment]::SetEnvironmentVariable("PROMPT", $null)
    [System.Environment]::SetEnvironmentVariable("PS1", $null)
    [System.Environment]::SetEnvironmentVariable("PWD", $null)
    [System.Environment]::SetEnvironmentVariable("SHELL", $null)
    [System.Environment]::SetEnvironmentVariable("SHLVL", $null)
    [System.Environment]::SetEnvironmentVariable("TERM", $null)
    [System.Environment]::SetEnvironmentVariable("USER", $null)
    [System.Environment]::SetEnvironmentVariable("ZSH", $null)
}  
```

For cmd, create `~/init.cmd` with the following

```bat
@echo off

@rem If launched from MSYS2 zsh / bash setup, some variables will be wrong.
if NOT "%MSYSTEM%" == "" (
    
    @rem allow MSYSPRESERVE=1 to prevent this. Used for override exes.
    if NOT "%MSYSPRESERVE%" == "1" (
        @rem Restore PATH, TMP, and TEMP from the MSYS2 ORIGINAL_ variables
        set "PATH=%ORIGINAL_PATH%"
        set "TEMP=%ORIGINAL_TEMP%"
        set "TMP=%ORIGINAL_TMP%"
        
        @rem Unset all the variables set by MSYS2, zsh, or bash
        set "_="
        set "COMP_WORDBREAKS="
        set "CONFIG_SITE="
        set "EDITOR="
        set "HISTFILESIZE="
        set "HISTIGNORE="
        set "HISTSIZE="
        set "HOME="
        set "HOSTNAME="
        set "INFOPATH="
        set "LANG="
        set "LC_CTYPE="
        set "LESS="
        set "LOGNAME="
        set "LS_COLORS="
        set "LSCOLORS="
        set "MANPATH="
        set "MSYS2_PATH_TYPE="
        set "MSYS2WINFIRST="
        set "MSYSCON="
        set "MSYSTEM="
        set "MSYSTEM_CARCH="
        set "MSYSTEM_CHOST="
        set "MSYSTEM_PREFIX="
        set "OLDPWD="
        set "ORIGINAL_PATH="
        set "ORIGINAL_TEMP="
        set "ORIGINAL_TMP="
        set "OSH="
        set "PAGER="
        set "PKG_CONFIG_PATH="
        set "PRINTER="
        set "PROMPT="
        set "PS1="
        set "PWD="
        set "SHELL="
        set "SHLVL="
        set "TERM="
        set "USER="
        set "ZSH="
    )
)
```

Then run the following in cmd to register init.cmd as an auto run script

`reg add "HKCU\Software\Microsoft\Command Processor" /v AutoRun /t REG_EXPAND_SZ /d "%"USERPROFILE"%\init.cmd" /f`
