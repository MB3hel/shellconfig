# *** THIS FILE IS A SHELLCONFIG REPO TEMPLATE RevA ***

# THIS FILE WILL BE OVERWRITEN. DO NOT EDIT. EDIT ~/.profile.ps1




# Shared (across systems / platforms) profile first
. $HOME/.shellconfig/pwsh_profile.ps1



# Then machine specific profile second
# This "template" cannot be used as a machine specific profile like is done for bash / zsh because windows puts it on onedrive
. $HOME/.pwsh_profile.ps1
