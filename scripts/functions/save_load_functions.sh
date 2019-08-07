#!/bin/bash
#!/usr/bin/env bash

shop_name=""
new_save () {
    while true; do
        read -p "What would you like to name your shop? >>> " shop_name
        if [[ $shop_name =~ [^a-zA-Z0-9_-] ]]; then
            echo "Shop name contains invalid characters, please try again!"
        else
            break
        fi
    done
}

#outputs the list of saves in folder
get_saves () {
    saves=($(ls|grep "_save.txt"|awk -F "_save.txt" '{print $1}'))
    if [[ -z "$saves" ]]; then
        return 1
    fi    
    echo -e "\e[4m Your shops: \e[0m"
    for i in "${saves[@]}"; do
        echo " - $i"
    done
    return 0
}

#creates new save file and writes to it
save () {
    FILE="$shop_name"_save.txt
    > $FILE
    echo "day_num=$day_num" >> $FILE
    echo "cash=$cash" >> $FILE
    echo "sales_mult=$sales_mult" >> $FILE
}

#asks user which load to open and reads it
load () {
    #get list of save files
    get_saves
    if [[ $? == 1 ]]; then
        echo "There are no saves to load"
        new_save
        return 0
    fi
    #check if save file exists
    while true; do
        read -p "Which shop would you like to load? >>> " input
        save_file=$input"_save.txt"
        if [[ $(ls) == *"$save_file"* ]]; then
            #load saves file, parse its content into global variables
            shop_name=$input
            saved_data=$(cat $save_file)
            day_num=$(grep "day_num" <<< "$saved_data"|awk -F "=" '{print $2}')
            cash=$(grep "cash" <<< "$saved_data"|awk -F "=" '{print $2}')
            sales_mult=$(grep "sales_mult" <<< "$saved_data"|awk -F "=" '{print $2}')
            break
        fi
            echo "This shop does not exist"
            sleep 1
    done
}