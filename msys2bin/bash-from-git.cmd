@echo off
@rem Somehow the "& call & call" suppresses the terminate batch script
@rem if the shell exits with error code 130 (from ctrl c)
@rem No idea why, but it works and avoids needing compiled exes to do this
"%ProgramFiles%\Git\bin\bash.exe" %* & call & call
