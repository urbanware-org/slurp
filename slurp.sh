#!/usr/bin/env bash

#
# Slurp - File gathering script
# Copyright (C) 2022 by Ralf Kilian
# Distributed under the MIT License (https://opensource.org/licenses/MIT)
#
# GitHub: https://github.com/urbanware-org/slurp
# GitLab: https://gitlab.com/urbanware-org/slurp
#

version="1.2.0"

echo
echo -e "\e[93mSlurp - Automated file gathering script\e[0m"
echo -e "\e[93mVersion ${version}\e[0m"
echo -e "\e[93mCopyright (C) 2022 by Ralf Kilian\e[0m"
echo -e "\e[93mDistributed under the MIT License\e[0m"
echo

if [ $# -gt 0 ]; then
    echo "This script is interactive and does not require any command-line" \
         "arguments."
    echo
fi

echo -e "You can \e[91mcancel\e[0m this script at any time by pressing" \
        "\e[96mCtrl\e[97m+\e[96mC\e[0m."
echo

echo -e "\e[96mSource path: \e[0m\c"
read source_path
if [ -z "${source_path}" ]; then
    echo -e "\n\e[91merror:\e[0m No source path given\n"
    exit 1
elif [ ! -e "${source_path}" ]; then
    echo -e "\n\e[91merror:\e[0m Given source path does not exist\n"
    exit 1
elif [ ! -d "${source_path}" ]; then
    echo -e "\n\e[91merror:\e[0m Given source path must be a directory\n"
    exit 1
fi
echo

echo -e "\e[96mTarget path: \e[0m\c"
read target_path
if [ -z "${target_path}" ]; then
    echo -e "\n\e[91merror:\e[0m No target path given\n"
    exit 1
elif [ "${source_path}" = "${target_path}" ]; then
    echo -e \
        "\n\e[91merror:\e[0m Source and target path must be different\n"
    exit 1
elif [ -e "${target_path}" ]; then
    echo -e "\n\e[91merror:\e[0m Given target path already exists\n"
    exit 1
fi
mkdir -p ${target_path}
echo

echo -e "\e[96mFile extension\e[0m, multiple separated with spaces." \
        "For example: \e[93mbmp jpg png\e[0m"
echo -e "\e[36m> \e[0m\c"
read file_ext
if [ -z "${file_ext}" ]; then
    echo -e "\n\e[91merror:\e[0m No file extensions given\n"
    exit 1
fi
echo

digits=10
for item in $(echo ${file_ext}); do
    num=0
    echo -e "\e[93mCurrent extension:\e[0m" \
            "$(tr '[:upper:]' '[:lower:]' <<< ${item}) ... \c"

    mkdir -p ${target_path}/slurp_${item}
    find "${source_path}" -type f | grep -i "\.${item}$" \
                                > /tmp/slurp_${item}.tmp
    while read line; do
        num=$(( num + 1 ))
        file_name=$(echo "${line}" | sed -e "s/.*\///g")
        file_num=$(printf "%.${digits}i" ${num})
        cp "${line}" "$target_path/slurp_$item/${file_num}_${file_name}"
    done < /tmp/slurp_${item}.tmp
    rm -f /tmp/slurp_${item}.tmp
    echo -e "\e[92mDone\e[0m"
done

echo
echo -e "Process completed."
echo -e "See '\e[93m${target_path}\e[0m' for the results."
echo

# EOF
