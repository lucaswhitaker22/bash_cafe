#!/bin/bash
#!/usr/bin/env bash
. functions/save_load_functions.sh
#get input from user


center () {
    #get size of terminal window
    width=$(tput cols)
    height=$(tput lines)
    #center cursor into center of terminal and echo
    str="$1"
    length=${#str}
    tput cup $((height / 2)) $(((width / 2) - (length / 2)))
    if [[ $str == *"Day"* ]];then
        tput rev;echo "$str";  tput sgr0
    else
        echo "$str"
    fi

}

open_shop () {
    #displays simple timer
    m=15
    h=9
    t="am"
    width=$(tput cols)
    height=$(tput lines)-4
    spacer=""
    for ((c=0; c <=$((height/2)); c++)); do
        spacer+="\n"
    done
    while (( h != 5 )); do
    echo -e $spacer
    printf "%*s\n" $((( 12+width )/2 )) "$h:$m $t"
        if (( m == 45 )); then
            m=00
            if (( h == 11 )); then
                t="pm"
            elif (( h == 12 )); then
                h=00
            fi
            h=$(( h+1 ))
        fi
        m=$(( m+15 ))
        sleep 0.01
        clear
    done
}

day_menu () {
    #displays menu options and gets user input
    tput clear
    title="Day Options"
    in=$2
    options="Continue,Upgrade,Save_Game,Load_Game,Exit"
    arr=$(echo $options | tr "," "\n")
    x=0
    y=0
    
    tput cup $y $x
    tput rev;echo " $title "; tput sgr0
    y=$((y+2))
    i=0
    for n in $arr
    do
        tput cup $(( y+$i )) $x
            str="$n" 
            echo "$((i+1)). $str"
        i=$((i+1))
    done
    tput cup $(( y+$i+1 )) $x
    while true; do
        read -p "Enter your choice [1-$i] >>> " choice
        if (( $choice < 1 )) || (( $choice > $i )); then
            echo "Invalid choice!"
        else
            return $choice
        fi
    done
}

menu_cases () {
    clear
    case "$1" in
    #Continue: save game then continue
    1)  save
        return 1 ;;
    #Upgrade: work in progress
    2)  echo "Upgrade feature: WIP"
        sleep 1
        save
        return 2 ;;
    #Save_Game: Get save name and create save
    3)  new_save
        save
        return 3 ;;
    #Load_Game: Save current session then load new game
    4)  save
        load
        return 4 ;;
    #Exit: Save current session then exit
    5)  save
        exit 0 ;;
    *)  echo "ERROR" 
        exit 1 ;;
    esac
}
