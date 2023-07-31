#!/bin/bash

# Author: Venkata Ramana Pulugari
# 31-07-2023
# <pvrreddy155@gmail.com>

# script to decompile and compile apk package
# --apktool && --jarsigner

clear

# check is number of arguments are two
if [ "$#" -lt 2 ] || [ "$#" -gt 4 ]; then
    echo "Usage: $0 decompile package_name.apk (or) $0 compile package_name [optional_keystore] [optional_keystore_alias]"
    exit 1
fi

# first argument
command="$1"

# second argument
name="$2"

# third argument
keystore="${3:-my-release-key.keystore}"

# fourth argument
keystore_alias="${4:-my-key-alias}"

source_folder="source_code"
apk_jar="apktool.jar"

# if the command is decompile..
if [ "$command" = "decompile" ]; then
    
    # check if the given file name ends with .apk
    if [ "${name: -4}" = ".apk" ]; then
        echo "APK: $name"
        
        # folder name
        folder_name="${name%.apk}"
        
        # create folder if not exists or remove 
        if [ -d "$folder_name" ]; then
            echo "Folder '$folder_name' already exists."
            rm -rf "$folder_name"
            mkdir -p "$folder_name"
        else
            mkdir -p "$folder_name"
            echo "Folder '$folder_name' created successfully."
        fi
        
        cp "$name" "$folder_name"/"$name"

        if [ -d "$folder_name"/"$source_folder" ]; then
            echo "Folder '$source_folder' already exists."
            rm -rf "$folder_name"/"$source_folder"
            mkdir -p "$folder_name"/"$source_folder"
        else
            mkdir -p "$folder_name"/"$source_folder"
            echo "Folder '$source_folder' created successfully."
        fi

        echo "Decompiling..."
        java -jar apktool.jar d -f "$folder_name"/"$name" -o "$folder_name"/"$source_folder"
        echo "Decompile done..!!"
    else
        echo "Error: The filename given is not apk."
        exit 1
    fi
else
    if [ -d "$name" ]; then
        if [ -d "$name"/"$source_folder" ]; then
            echo "Source code exists.."
            echo "Compiling source code to APK"

            # Get today's date in the format YYYY-MM-DD
            today=$(date +'%d-%m-%Y')

            compile_name="$name"_"$today".apk
            java -jar apktool.jar b "$name"/"$source_folder" -o "$name"/"$compile_name"
            echo "APK compilation done.."
            if [ ! -e "$keystore" ]; then
                keytool -genkeypair -v -keystore my-release-key.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias my-key-alias
                jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore my-release-key.keystore "$name"/"$compile_name" my-key-alias
                jarsigner -verify -verbose -certs "$name"/"$compile_name"
            else
                jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore "$keystore" "$name"/"$compile_name" "$keystore_alias"
                jarsigner -verify -verbose -certs "$name"/"$compile_name"
            fi
            echo "APK sign done..!!"
        else
            echo "Source folder not found in '$name'"
            exit 1
        fi
    else
        echo "Folder '$name' not found"
        exit 1
    fi
fi