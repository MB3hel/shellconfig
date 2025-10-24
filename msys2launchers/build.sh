#!/usr/bin/env bash

compile(){
    g++ -static -static-libgcc -static-libstdc++ -DSHELL="\"$1\"" "src/launcher.cpp" -o bin/${1}.exe
}

compile bash
compile zsh
compile sh

