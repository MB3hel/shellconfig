#!/usr/bin/env bash
# Takes any number of arguments to files / folders and sends them to recyle bin
# Uses powershell to avoid needing custom-built exes
# Note that this does NOT call a powershell script instead invoking powershell directly
# because of how powershell's execution policies work (stupid yes, but it does work)

for f in "$@"; do
    f_win="$(cygpath -w "$(realpath "$f")")"
    if [ -f "$f" ]; then
        powershell.exe -Command "Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteFile('${f_win}','OnlyErrorDialogs','SendToRecycleBin')"
    elif [ -d "$f" ]; then
        powershell.exe -Command "Add-Type -AssemblyName Microsoft.VisualBasic; [Microsoft.VisualBasic.FileIO.FileSystem]::DeleteDirectory('${f_win}','OnlyErrorDialogs','SendToRecycleBin')"
    fi
done
