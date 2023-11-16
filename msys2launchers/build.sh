#!/usr/bin/env bash
for file in src/*.cpp; do
    name="$(basename "$file" ".cpp")"
    g++ -static -static-libgcc -static-libstdc++ "src/$name.cpp" -o "bin/$name.exe"
done