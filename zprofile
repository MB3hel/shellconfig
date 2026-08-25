# Global zprofile
# This will have already been done in correct sequence by zsh
# DO NOT DO IT AGAIN OR THINGS MAY BREAK
# if [ -f /etc/zsh/zprofile ]; then
#     . /etc/zsh/zprofile
# fi
# if [ -f /etc/zprofile ]; then
#     . /etc/zprofile
# fi

# uname -o is used extensively in these scripts. Real macOS supports it
# but the darling compatibility layer does not.
if type sw_vers > /dev/null 2>&1 && [ -n "$(sw_vers | grep Darling)" ]; then
    uname(){
        local args=("$@")
        for i in "${args[@]}"; do
            if [ "${args[$i]}" = "-o" ]; then
                args[$i]="-s"
            fi
        done
        uname "${args[@]}"
    }
fi

# Launch an SSH agent unless the OS is already running one.
# openssh ssh-add -l exit codes:
#   0 = Agent is running and has keys
#   1 = Agent is running but has no keys
#   2 = Agent is not running
ssh-add -l > /dev/null 2>&1
if [ $? -gt 1 ]; then
    # Luanch agent now
    eval `ssh-agent` > /dev/null

    # Kill SSH agent on logout of this shell
    trap 'ssh-agent -k > /dev/null 2>&1' EXIT
fi

# Default environment settings (system specific ~/.bash_profile can override these)
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
type vim > /dev/null 2>&1 && export EDITOR="vim"
type nvim > /dev/null 2>&1 && export EDITOR="nvim"
export LANG=en_US.UTF-8
if [ "$(uname -o)" = "Msys" ] && ! type msys2_open.sh > /dev/null 2>&1; then
    export PATH="$HOME/.shellconfig/msys2bin:$PATH"
fi

# Homebrew for tools, packages, versions, etc not in os repos
[ -x "/home/linuxbrew/.linuxbrew/bin/brew" ] && \
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"

# Enable windows symlinks in msys2 (requires developer mode)
[ "$(uname -o)" = "Msys" ] && export MSYS='winsymlinks:nativestrict'

