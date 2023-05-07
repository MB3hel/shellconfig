#!/usr/bin/env bash

g++ -static -static-libgcc -static-libstdc++ -DCMD_NAME="\"${1}\"" zsh.cpp -o ../zsh.exe
g++ -static -static-libgcc -static-libstdc++ -DCMD_NAME="\"${1}\"" bash.cpp -o ../bash.exe

