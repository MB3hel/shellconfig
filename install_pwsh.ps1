#!/usr/bin/env pwsh

# Unlike bash/zsh templates, the pwsh template is not intended to be modified further by users
# since it gets synced on windows. So no need to implement the template system like install.sh
# has. Can just always copy the latest one

[System.IO.Directory]::CreateDirectory((Split-Path $PROFILE)) | Out-Null
cp $PSScriptRoot/template/Microsoft.PowerShell_profile.ps1 $PROFILE
if (-not (Test-Path -Path "$HOME/.pwsh_profile.ps1")) {
    New-Item -Path "$HOME/.pwsh_profile.ps1" -ItemType "File" -Value "# System specifics go below`n" > $null
}
if($IsWindows){
    New-Item -ItemType Directory -Force -Path "$Env:LOCALAPPDATA/Microsoft/Windows Terminal/Fragments/mb3hel.shellconfig/" | Out-Null
    $pwsh_link = "$Env:LOCALAPPDATA/Microsoft/Windows Terminal/Fragments/mb3hel.shellconfig/pwsh.json"
    $pwsh_target = "$PSScriptRoot/win_terminal/pwsh.json"
    try {
        New-Item -ItemType SymbolicLink -Path $pwsh_link -Target $pwsh_target -ErrorAction Stop | Out-Null
    } catch {
        # Fallback on copy for systems where dev mode is not enabled
        Copy-Item -Path $pwsh_target -Destination $pwsh_link -Force
    }
} elseif (-not $IsMacOS){
    if (Test-Path -Path "$HOME/.local/share/konsole/02-pwsh.profile") {
        mv "$HOME/.local/share/konsole/02-pwsh.profile" "$HOME/.local/share/konsole/02-pwsh.profile.bak"
    }
    ln -s "$PSScriptRoot/konsole/02-pwsh.profile" "$HOME/.local/share/konsole/02-pwsh.profile"
}
echo "It is HIGHLY recommended to run Install-Module git-completion if able to install modules"

