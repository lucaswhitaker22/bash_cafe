#!/bin/bash
#!/usr/bin/env bash

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