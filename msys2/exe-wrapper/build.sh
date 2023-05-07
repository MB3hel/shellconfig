#!/usr/bin/env bash

if [ "$#" != "1" ]; then
    echo "Usage: build.sh command_name"
    exit 1
fi

g++ -static -static-libgcc -static-libstdc++ -DCMD_NAME="\"${1}\"" wrapper.cpp -o ../override-exes/${1}.exe

