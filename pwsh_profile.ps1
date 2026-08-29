# Powershell profile script common portions across all machines / platforms
# This is designed for pwsh 7.x cross platform (not just windows)


# TODO: Make windows terminal duplicate tab work including in WSL



# Custom prompt. Matches bash / zsh prompts, but uses '>' at the end not '$' or '%'
function DoPromptGitInfo {
    # Minimize git command invocations because launching git on windows is slow
    # enough to be noticeable. Use one git status command to get all info needed for prompt
    # Not using posh-git because I use this in contexts where I can't install modules
    $git_banch = ""
    $git_dirty = ""
    git status --porcelain=v2 --branch | ForEach-Object {
        $line_type, $line_contents, $line_contents2 = $_ -split '\s+', 3
        if($line_type -eq "#") {
            if($line_contents -eq "branch.oid"){
                $git_branch = $line_contents2.Substring(0,7)
            } elseif(($line_contents -eq "branch.head") -and -not ($line_contents2 -eq "(detached)")){
                $git_branch = $line_contents2
            }
        } elseif ($line_type -in @("1", "2", "u", "?")) {
            $git_dirty = " ✗"
        }
    }
    if($git_branch){
        Write-Host -NoNewline "("
        Write-Host -NoNewline -ForegroundColor Cyan $git_branch
        Write-Host -NoNewline -ForegroundColor Red $git_dirty
        Write-Host -NoNewline ")"
    }
}
function DoPromptEnvironment {
    if($Env:CONTAINER_ID){
        Write-Host -NoNewline "($Env:CONTAINER_ID)"
    }
    if(Test-Path -Path "/etc/debian_chroot" -PathType Leaf) {
        $chroot = Get-Content -Path "/etc/debian_chroot" -TotalCount 1
        Write-Host -NoNewline "($chroot)"
    }
    if($Env:VIRTUAL_ENV) {
        if($Env:VIRTUAL_ENV_PROMPT) {
            Write-Host -NoNewline "($Env:VIRTUAL_ENV_PROMPT)"
        } else {
            $venv_dir = Split-Path "$Env:VIRTUAL_ENV" -Leaf
            Write-Host -NoNewline "($venv_dir)"
        }
    }
}
function prompt {
    # Green / red arrow depending on last command exit code
    $lastSuccess = $global:?
        Write-Host "→" -NoNewline -ForegroundColor $(if ($lastSuccess) { "Green" } else { "Red" })

    # Environment sections (eg containers, venvs, etc)
    DoPromptEnvironment

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

    # Git status portion
    DoPromptGitInfo
    
    # End of prompt right before command is typed
    return "> "
}

# Disable default venv prompt, will handle custom
$Env:VIRTUAL_ENV_DISABLE_PROMPT = "1"

# Load aliases
. $PsScriptRoot/aliases.ps1


# Better tab completion and history search
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -HistorySearchCursorMovesToEnd:$true
Set-PSReadLineOption -ShowToolTips:$False
Set-PSReadLineOption -PredictionSource None
Set-PSReadlineOption -BellStyle None


# Fix some colors that use dark grey by default. Hard to read
# on almost black terminal background (such as when window transparency
# is turned on)
Set-PSReadLineOption -Colors @{ "Parameter" = "Gray"; "Operator" = "Gray" }

