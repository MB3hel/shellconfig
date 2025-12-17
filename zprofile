# Global zprofile
# This will have already been done in correct sequence by zsh
# DO NOT DO IT AGAIN OR THINGS MAY BREAK
# if [ -f /etc/zsh/zprofile ]; then
#     . /etc/zsh/zprofile
# fi
# if [ -f /etc/zprofile ]; then
#     . /etc/zprofile
# fi

# Launch an SSH agent unless the OS is already running one.
# On windows, SSH_AUTH_SOCK is not used, so we always assume the agent is running.
if [ -z "$SSH_AUTH_SOCK" ] && [ "$(uname -o)" != "Msys" ]; then
    # Luanch agent now
     eval `ssh-agent` > /dev/null

    # Kill SSH agent on logout of this shell
    trap 'ssh-agent -k > /dev/null 2>&1' EXIT
fi

# Default environment settings (system specific ~/.bash_profile can override these)
export EDITOR="nvim"
export LANG=en_US.UTF-8
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
if [ "$(uname -o)" = "Msys" ] && ! type msys2_open.sh > /dev/null 2>&1; then
    export PATH="$HOME/.shellconfig/msys2bin:$PATH"
fi
