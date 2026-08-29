# Aliases for unix commands
function which{
    (Get-Command @args | Format-Table -HideTableHeaders -Property CommandType, Name, Source | Out-String).Trim()
}
function ln ($target, $link) {
	New-Item -Path $link -ItemType SymbolicLink -Value $target
}
if(-not $IsWindows) {
    # Use alias same as on windows by default instead of ls application
    New-Alias ls Get-ChildItem
}

# vimx / gvim aliases
function InvokeVimx() {
    vimx @args
}
function InvokeGvimV() {
    gvim -v @args
}
if (-not ($IsWindows -or $IsMacOS)){
    # Some linux distros split the vim package
    if (Get-Command "vimx" -ErrorAction SilentlyContinue) {
        New-Alias vim InvokeVimx
    } elseif (Get-Command "gvim" -ErrorAction SilentlyContinue) {
        New-Alias vim InvokeGvimV
    }
}

# Tmux ssh fixes
if(-not $IsWindows) {
    # All this handles tmux detach then reattach with different ssh agent
    # See aliases file for more details. These are pwsh port
    function fixssh() {
        $auth_sock = tmux showenv -s SSH_AUTH_SOCK 2>$null
        if($auth_sock){
            $name, $value = $auth_sock -split '=', 2
            Set-Content -Path "env:\$name" -Value $value
        }
        $agent_pid = tmux showenv -s SSH_AGENT_PID 2>$null
        if($agent_pid){
            $name, $value = $agent_pid -split '=', 2
            Set-Content -Path "env:\$name" -Value $value
        }
    }
    function InvokeFixSshGit(){
        fixssh >$null 2>&1
        & (Get-Command -CommandType Application git)[0].Source @args
    }
    function InvokeFixSshSsh(){
        fixssh >$null 2>&1
        & (Get-Command -CommandType Application ssh)[0].Source @args
    }
    function InvokeFixSshScp(){
        fixssh >$null 2>&1
        & (Get-Command -CommandType Application scp)[0].Source @args
    }
    if($Env:TMUX){
        New-Alias git InvokeFixSshGit
        New-Alias ssh InvokeFixSshSsh
        New-Alias scp InvokeFixSshScp
    }
}

# open and trash aliases
New-Alias open ii
if ($IsWindows) {
    Add-Type -AssemblyName Microsoft.VisualBasic
    function trash() {
         foreach ($f in $args) {
            if (Test-Path -LiteralPath $f) {
                if (Test-Path -LiteralPath $argument -PathType Leaf) {
                    [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile($f,'OnlyErrorDialogs','SendToRecycleBin')
                } elseif (Test-Path -LiteralPath $argument -PathType Container) {
                    [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteDirectory($f,'OnlyErrorDialogs','SendToRecycleBin')
                }
            }
        }
    }
}
if($IsLinux) {
    function InvokeGioTrash() {
        gio trash @args
    }
    New-Alias trash InvokeGioTrash
}

# TODO: openwin for WSL
 
