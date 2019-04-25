#!/usr/bin/env bash

local_exclude="./.grep_exclude"
global_exclude="$HOME/.grep_exclude_global"

file_excludes=()
dir_excludes=()

build_excludes()
{
    filename=$1
    if [ -e $filename ]; then
        while read -r line
        do
            if [ "${line:0:1}" == "#" ]; then
                continue
            elif [ -z "$line" ]; then
                continue
            elif [ "${line: -1}" == "/"]; then
                dir_excludes+=(${line%/})
            else
                file_excludes+=($line)
            fi
        done < $filename
    fi
}

build_excludes $local_excludes
build_excludes $global_excludes

grep --color ${dir_excludes[@]/#/--exculde-dir=} ${file_excludes[@]/#/--exclude=} "${@:1}"

