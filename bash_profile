# For interactive shells, source bashrc too
[[ $- == *i* ]] && source ~/.bashrc

####################################################################################################
# SSH Agent
####################################################################################################

# Launch an agent if SSH_AUTH_SOCK is not set
# If SSH_AUTH_SOCK is set before the shell starts, assume it's environment
# managed ssh agent such as Gnome, or macOS, etc
if [ -z "$SSH_AUTH_SOCK" ]; then
    # Luanch agent now
     eval `ssh-agent` > /dev/null

    # Kill SSH agent on logout of this shell
    trap 'ssh-agent -k > /dev/null 2>&1' EXIT
fi

####################################################################################################

