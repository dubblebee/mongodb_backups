#!/usr/bin/env bash

dir="." # <-- Current directory - change as required.
min_dirs=3

[[ $(find "$dir" -maxdepth 1 -type d | wc -l) -ge $min_dirs ]] &&
IFS= read -r -d $'\0' line < <(find "$dir" -maxdepth 1 -printf '%T@ %p\0' 2>/dev/null | sort -z -n)
file="${line#* }"
ls -lLd "$file"
rm -rf "$file"