$Env:MSYS2WINFIRST=1
$Env:MSYSTEM="MSYS"
$Env:MSYSCON="defterm"
$Env:MSYS2_PATH_TYPE="inherit"
$Env:CHERE_INVOKING=1
. "$HOME\scoop\apps\msys2\current\usr\bin\zsh.exe" -li
Exit $LASTEXITCODE