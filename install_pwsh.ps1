#!/usr/bin/env pwsh

# Unlike bash/zsh templates, the pwsh template is not intended to be modified further by users
# since it gets synced on windows. So no need to implement the template system like install.sh
# has. Can just always copy the latest one

[System.IO.Directory]::CreateDirectory((Split-Path $PROFILE)) | Out-Null
cp $PSScriptRoot/template/Microsoft.PowerShell_profile.ps1 $PROFILE
if (-not (Test-Path -Path "$HOME/.pwsh_profile.ps1")) {
    New-Item -Path "$HOME/.pwsh_profile.ps1" -ItemType "File" -Value "# System specifics go below`n" > $null
}
echo "It is HIGHLY recommended to run Install-Module git-completion if able to install modules"

