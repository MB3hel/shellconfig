@echo off
setlocal enableextensions
set TERM=
set MSYS2WINFIRST=1
"%USERPROFILE%\scoop\apps\msys2\current\usr\bin\env.exe" MSYSTEM=MSYS MSYSCON=defterm MSYS2_PATH_TYPE=inherit CHERE_INVOKING=1 /usr/bin/zsh -li