@echo off
set CHERE_INVOKING=1
set MSYSTEM=MSYS2
set MSYS2_PATH_TYPE=inherit
@rem Somehow the "& call & call" suppresses the terminate batch script
@rem if the shell exits with error code 130 (from ctrl c)
@rem No idea why, but it works and avoids needing compiled exes to do this
"%USERPROFILE%\standalonemsys2\usr\bin\bash.exe" %* & call & call
