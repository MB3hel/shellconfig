@echo off
:: Setup a standalone msys2 environment on windows
:: Run this only once before using install.sh


:: Only allow this to run once
:: After that, update with pacman -Syu then pacman -Su
IF EXIST "%USERPROFILE%\standalonemsys2\" (
    ECHO %USERPROFILE%\standalonemsys2 already exists!
    EXIT /B 1
)

:: Download and extract
PUSHD "%TEMP%"
curl -LO "https://github.com/msys2/msys2-installer/releases/latest/download/msys2-base-x86_64-latest.tar.zst"
mkdir "%USERPROFILE%\standalonemsys2\"
cd "%USERPROFILE%\standalonemsys2\"
tar -xf "%TEMP%\msys2-base-x86_64-latest.tar.zst" --strip-components=1
POPD

:: Edit some settings. Windows doesn't have sed, but msys2 does!
"%USERPROFILE%\standalonemsys2\usr\bin\sed.exe" -i 's/#MSYS2_PATH_TYPE=inherit/MSYS2_PATH_TYPE=inherit/g' "%USERPROFILE%\standalonemsys2\msys2.ini"
"%USERPROFILE%\standalonemsys2\usr\bin\sed.exe" -i 's/db_home: cygwin desc/db_home: windows/g' "%USERPROFILE%\standalonemsys2\etc\nsswitch.conf"


