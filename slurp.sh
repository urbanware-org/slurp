#!/bin/bash

# ============================================================================
# Slurp - File gathering script
# Copyright (C) 2017 by Ralf Kilian
# Distributed under the MIT License (https://opensource.org/licenses/MIT)
#
# Website: http://www.urbanware.org
# GitHub: https://github.com/urbanware-org/slurp
# ============================================================================

version="1.1.2"

source_path="$1"
target_path="$2"
file_ext="$3"

echo
echo "Slurp - File gathering script"
echo "Version $version"
echo "Copyright (C) 2017 by Ralf Kilian"
echo "Distributed under the MIT License"
echo

echo "You can cancel this script at any time by pressing Ctrl+C."
echo

if [ -z "$source_path" ] || \
   [ -z "$target_path" ] || \
   [ -z "$file_ext" ]; then
    read -p "Source path: " source_path
    read -p "Target path: " target_path
    echo -e "\nFile extension, multiple separated with spaces (e. g."\
            "\"bmp jpg png\"):"
    read -p "> " file_ext
    echo
fi

if [ -z "$source_path" ]; then
    echo "error: No source path given"
    exit 1
elif [ -z "$target_path" ]; then
    echo "error: No target path given"
    exit 1
elif [ -z "$file_ext" ]; then
    echo "error: No file extensions given"
    exit 1
elif [ "$source_path" = "$target_path" ]; then
    echo "error: Source and target path must be different"
    exit 1
elif [ ! -e "$source_path" ]; then
    echo "error: Given source path does not exist"
    exit 1
elif [ ! -d "$source_path" ]; then
    echo "error: Given source path must be a directory"
    exit 1
elif [ ! -e "$target_path" ]; then
    echo "error: Given target path does not exist"
    exit 1
elif [ ! -d "$target_path" ]; then
    echo "error: Given target path must be a directory"
    exit 1
fi

digits=10
for item in $(echo $file_ext); do
    num=0
    echo "Current extension: $item"

    mkdir -p $target_path/slurp_$item
    find "$source_path" -type f | grep -i "\.$item$" \
                                > /tmp/slurp_$item.tmp
    while read line; do
        num=$(( num + 1 ))
        file_name=$(echo "$line" | sed -e "s/.*\///g")
        file_num=$(printf "%.${digits}i" $num)
        cp "$line" "$target_path/slurp_$item/${file_num}_${file_name}"
    done < /tmp/slurp_${item}.tmp
    rm -f /tmp/slurp_${item}.tmp
done

echo
echo "Process completed."
echo "See '$target_path' for the results."
echo

# EOF

