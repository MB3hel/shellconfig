# Powershell profile script common portions across all machines / platforms
# This is designed for pwsh 7.x cross platform (not just windows)


# Custom prompt. Matches bash / zsh prompts, but uses '>' at the end not '$' or '%'
if($IsWindows){
    function DoPromptWinTermDuplicate() {
        $loc = Get-Location
        Write-Host -NoNewline "$([char]27)]9;12$([char]7)"
        if ($loc.Provider.Name -eq "FileSystem"){
            Write-Host -NoNewline "$([char]27)]9;9;`"$($loc.Path)`"$([char]7)"
        }
    }
}
if($IsLinux -and (Get-Command -CommandType Application -TotalCount 1 "wslpath" -ErrorAction SilentlyContinue)) {
    function DoPromptWinTermDuplicate() {
        $loc = Get-Location
        $winloc = & "wslpath" -w $loc
        Write-Host -NoNewline "$([char]27)]9;12$([char]7)"
        if ($loc.Provider.Name -eq "FileSystem"){
            Write-Host -NoNewline "$([char]27)]9;9;`"$($winloc)`"$([char]7)"
        }
 
    }
}
$_orig_git_cmd = (Get-Command -CommandType Application -TotalCount 1 git)[0].Source
function DoPromptGitInfo {
    # Minimize git command invocations because launching git on windows is slow
    # enough to be noticeable. Use one git status command to get all info needed for prompt
    # Not using posh-git because I use this in contexts where I can't install modules
    $git_banch = ""
    $git_dirty = ""
    & "$_orig_git_cmd" status --porcelain=v2 --branch | ForEach-Object {
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
        return "($($PSStyle.Foreground.BrightCyan)$git_branch$($PSStyle.Foreground.BrightRed)$git_dirty$($PSStyle.Reset))"
    }
    return ""
}
function DoPromptEnvironment {
    $out = ""
    if($Env:CONTAINER_ID){
        $out += "($Env:CONTAINER_ID)"
    }
    if(Test-Path -Path "/etc/debian_chroot" -PathType Leaf) {
        $chroot = Get-Content -Path "/etc/debian_chroot" -TotalCount 1
        $out += "($chroot)"
    }
    if($Env:VIRTUAL_ENV) {
        if($Env:VIRTUAL_ENV_PROMPT) {
            $out += "($Env:VIRTUAL_ENV_PROMPT)"
        } else {
            $venv_dir = Split-Path "$Env:VIRTUAL_ENV" -Leaf
            $out += "($venv_dir)"
        }
    }
    return $out
}
function prompt {
    # Capture last command success / fail
    $lastSuccess = $global:?
    
    # Construct prompt in string so it is all printed when ready for command
    $prompt = ""

    # Support for windows terminal duplicate tab
    try { DoPromptWinTermDuplicate } catch {  }
    
    # Green / red arrow depending on last command exit code
    if($lastSuccess) {
        $prompt += "$($PSStyle.Foreground.BrightGreen)→$($PSStyle.Reset)"
    } else {
        $prompt += "$($PSStyle.Foreground.BrightRed)→$($PSStyle.Reset)"
    }

    # Environment sections (eg containers, venvs, etc)
    $prompt += DoPromptEnvironment

    # Base prompt
    $user = [System.Environment]::UserName
    $hostname = [System.Net.Dns]::GetHostName()
    $curlocfull = $ExecutionContext.SessionState.Path.CurrentLocation
    if ([System.IO.Path]::GetFullPath($curlocfull) -eq [System.IO.Path]::GetFullPath($HOME)) {
        $curloc = "~"
    } else {
        $curloc = Split-Path $curlocfull -Leaf
    }
    $prompt += "["
    if($IsWindows) {
        $prompt += "$($PSStyle.Foreground.Yellow)$user@${hostname}:$($PSStyle.Reset)"
    } else {
        $prompt += "$($PSStyle.Foreground.BrightGreen)$user@${hostname}:$($PSStyle.Reset)"
    }
    $prompt += "$($PSStyle.Foreground.BrightBlue)$curloc$($PSStyle.Reset)"
    $prompt += "]"

    # Git status portion
    $prompt += DoPromptGitInfo

    # End of prompt right before command is typed
    $prompt += "> "
    return $prompt
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


# Git tab completion via git-completion module
# Only if module is installed. Can't install modules on all systems
if (Get-Module -ListAvailable -Name "git-completion") {
   Register-ArgumentCompleter -CommandName gitk -Native -ScriptBlock {
        param($wordToComplete, $CommandAst, $CursorPosition)
        return (Complete-Gitk -CommandAst $CommandAst -CursorPosition $CursorPosition)
    }
    Register-ArgumentCompleter -CommandName git -Native -ScriptBlock {
        param($wordToComplete, $CommandAst, $CursorPosition)
        return (Complete-Git -CommandAst $CommandAst -CursorPosition $CursorPosition)
    } 
}

