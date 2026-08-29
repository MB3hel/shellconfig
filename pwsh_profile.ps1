# Powershell profile script common portions across all machines / platforms



# TODO: Make windows terminal duplicate tab work



# Custom prompt. Matches bash / zsh prompts, but uses '>' at the end not '$' or '%'
function prompt {
    # Green / red arrow depending on last command exit code
    $lastSuccess = $global:?
        Write-Host "→" -NoNewline -ForegroundColor $(if ($lastSuccess) { "Green" } else { "Red" })

    # TODO: deal with python venvs

    # Base prompt
    $user = [System.Environment]::UserName
    $hostname = [System.Net.Dns]::GetHostName()
    $curlocfull = $ExecutionContext.SessionState.Path.CurrentLocation
    if ([System.IO.Path]::GetFullPath($curlocfull) -eq [System.IO.Path]::GetFullPath($HOME)) {
        $curloc = "~"
    } else {
        $curloc = Split-Path $curlocfull -Leaf
    }
    Write-Host "[" -NoNewline
    Write-Host "$user@${hostname}:" -NoNewline -ForegroundColor $(if ($IsWindows) { "DarkYellow" } else { "Green" })
    Write-Host "$curloc" -NoNewline -ForegroundColor Blue
    Write-host "]" -NoNewline

    # TODO: git status prompt info (not using posh-git b/c need this in places I can't install modules)

    # End of prompt right before command is typed
    return "> "
}



# Aliases
New-Alias open ii
function which{
    (Get-Command @args | Format-Table -HideTableHeaders -Property CommandType, Name, Source | Out-String).Trim()
}
function ln ($target, $link) {
	New-Item -Path $link -ItemType SymbolicLink -Value $target
}



# Better tab completion and history search
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -HistorySearchCursorMovesToEnd:$true
Set-PSReadLineOption -ShowToolTips:$False
Set-PSReadLineOption -PredictionSource None
Set-PSReadlineOption -BellStyle None
