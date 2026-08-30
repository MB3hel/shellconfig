# Shell Config

My cross platform shell configurations for zsh, bash, and powershell


## Install Bash / Zsh

### Anything but Windows

Linux/BSD prerequisites: git, bash, zsh

macOS prerequisites: git, bash (newer version from brew)

```sh
git clone git@github.com:MB3hel/shellconfig.git ~/.shellconfig
cd ~/.shellconfig
./install.sh
```

### Windows Install (using MSYS2 - Recommended)

*Note: MSYS2 is not a prerequisite. It will be installed in a minimal standalone instance by following the instructions below. The MSYS2 installation should not have many packages installed using pacman. Install native windows versions of tools instead (eg using scoop package manager) except for software only available through MSYS2.*

Windows prerequisites: git, zstd (included in windows 11, but not 10), tar (included in windows 10 & 11)

*It is recommended to install windows prerequisites using scoop if not included by the os*

```sh
# Start in CMD
cd /d "%USERPROFILE%"
git clone git@github.com:MB3hel/shellconfig.git .shellconfig
cd .shellconfig
.\msys2_install.cmd
.\msys2bin\bash.cmd --login -i

# Now in bash
pacman -S zsh tmux
./install.sh
```

(Optional) Add `%USERPROFILE%\.shellconfig\msys2bin` to your user's PATH variable (allows running bash.cmd or zsh.cmd from windows shells)


### Windows Install (No MSYS2)

*This is an alternate method using git for window's own builtin bash shell. It is less flexible than the MSYS2 method and only recommended on systems where you cannot install MSYS2*

To install using git for windows's bash, follow the same steps with the following changes
- Skip `msys2_install.cmd`
- Use `bash-from-git.cmd` instead of `bash.cmd` during installation and in windows terminal profile
- zsh is not available

### Shell Startup Files

This repo configures both bash and zsh to behave in a similar way: login shells source the profile script. Interactive shells source the rc script. This is default behavior for zsh. However, bash by default would not source the rc for interactive login shells. Here it does. Essentially

- Bash (login): sources `.bash_profile`
- Bash (login, interactive): sources `.bash_profile` then sources `.bashrc`
- Bash (interactive): sources `.bashrc`
- Zsh (login): soruces `.zprofile`
- Zsh (login, interactive): sources `.zprofile` then sources `.zshrc`
- Zsh (interactive): sources `.zshrc`

Environment variables should be set / modified in whichever profile script is your user's login shell (see chsh command). The rc files should not modify variables unless making changes that should only apply to interactive sessions. Because of this a new login is often needed to see changes.

### SSH Agent

If no SSH agent is already running, login shells will start one that can be shared by any interactive shell launched from within that shell (eg GUI terminal emulators or tmux). On macOS and GNOME, an SSH agent will already be running.

The SSH agent will be terminated at logout to ensure keys are locked.

On windows, no SSH agent is managed by the shell as it is assumed the ssh agent will be running as a system service instead.

Note: Adding `AddKeysToAgent yes` to `~/.ssh/config` will make so you only have to unlock keys once until log out.

### Why is it slow on windows

The answer is almost always: Antivirus. Windows defender, etc.
Excluding both where you have git installed and the standlone msys2 folder helps quite a bit


## Install Powershell

- Install powershell 7.x+ (pwsh) not windows powershell
- On macOS and Liunx, homebrew works well for this
- On windows, scoop
- Run `install_pwsh.ps1`
- Install the optional modules it recommends

Will create a `~/.pwsh_profile.ps1` script for system specifics


## Terminal Emulator Settings

Settings I change over defaults. Not automatically applied via install scripts.
Profiles for windows terminal and konsole will be installed via the install.sh and install_pwsh.ps1 scripts though.

### Windows Terminal

- Startup:
    - Default profile = zsh (native)
    - Launch size: 120 x 34
- Rendering:
    - In VirtualBox VMs, enable software rendering (lower latency when typing)
- Actions:
    - Unmap Ctrl+C from copy text
    - Unmap Enter from copy text
    - Remap duplicate tab to Ctrl+Shift+T
    - Unmap Ctrl+V from paste
- New Tab Menu
    - Order zsh (native), bash (native), pwsh, cmd, WSL distros
- Profile Defaults
    - Appearance > Color Scheme: Tango Dark
    - Appearance > Font: Cascadia Mono 11pt
    - Appearance > Cursor shape: Bar
    - Appearance > BG Opacity: 80% w/ acrylic
    - Advanced > Bell: None
    - Advanced > Display menu on right-click on
- Hide other profiles (azure, windows powershell, visual studio, etc)

### Konsole

- Set installed zsh profile as default profile
- General > Remember widow size off (lets profile control)
- Tab bars / splitters > Behavior > Put new tabs after current
- 

