
BUILD WITH mingw64 OR mingw32 ENVIRONMENTS (UCRT should work too, but don't use msys environment)

Used to create exe wrappers to run msys2 commands instead of windows ones
Using an exe wrapper instead of a bash script ensures that cmd and powershell can invoke these too
This is mostly important when using some windows tool (eg nvim installed by scoop) but launched by msys2 zsh / bash
In this case, zsh would try to run C:/USER/msys2-override-bin/git (bash script) as it's git command, but that would fail
Since it uses cmd internally. Making C:/USER/msys2-override-bin/git.exe an exe ensures it will still work
