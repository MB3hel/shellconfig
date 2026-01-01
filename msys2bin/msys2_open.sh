#!/bin/bash

item=""
if [ -d "$1" ] || [ -f "$1" ]; then
    item=$(cygpath -w "$1")
else
    item="$1"
fi
$(realpath $(dirname "$0"))/msys2_open.cmd "$item"
