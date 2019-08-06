#!/bin/bash
#!/usr/bin/env bash

day_num=6
expense=1
sales_mult=1
cash=100
mult=0
start_time=$(date +"%s")

center () {
    width=$(tput cols)
    height=$(tput lines)
    str="$1"
    length=${#str}
    tput cup $((height / 2)) $(((width / 2) - (length / 2)))
    if [[ $str == *"Day"* ]];then
        tput rev;echo "$str";  tput sgr0
    else
        echo "$str"
    fi

}
FILE="save.txt"

save () {
     > $FILE
    echo "day_num=$day_num" >> $FILE
    echo "cash=$cash" >> $FILE
    echo "sales_mult=$sales_mult" >> $FILE
}
load () {
    saved_data=$(cat $FILE)
    day_num=$(grep "day_num" <<< $saved_data|awk -F "=" '{print $2}')
    cash=$(grep "cash" <<< $saved_data|awk -F "=" '{print $2}')
    sales_mult=$(grep "sales_mult" <<< $saved_data|awk -F "=" '{print $2}')
}
open_shop () {
    m=15
    h=9
    t="am"
    width=$(tput cols)
    height=$(tput lines)-4
    spacer=""
    for ((c=0; c <=$((height/2)); c++)); do
        spacer+="\n"
    done
    while (( $h != 5)); do
    echo -e $spacer
    printf "%*s\n" $(((12+$width)/2)) "$h:$m $t"
        if (( $m == 45 )); then
            m=00
            if (( $h == 11 )); then
                t="pm"
            elif (( $h == 12 )); then
                h=00
            fi
            h=$(( $h+1 ))
        fi
        m=$(( $m+15 ))
        sleep 0.01
        clear
    done
}


calculate_profit () {
    weather=$1
    cost=$2
    count=$3
    echo count: $count
    #calculate # of sales
    mult=$(( 5+$RANDOM%10 ))
    sales1=$(( $(($((weather-20))*10 - mult*cost))/2 ))
    echo sales_before_bonus: $sales1
    sales=$(( $(( $(($((weather-20))*10 - mult*cost))/2 ))*sales_mult))
    if [[ ! $sales -gt 0 ]]; then
        sales=0
    fi
    echo sales: $sales
    #calculate income
    if (( sales > count )); then
        income=$(( count*cost ))
    else
        income=$(( sales*cost ))
    fi
    echo income: $income
    #calculate profit
    profit=$(( income-count-$((sales/2)) ))
    return $profit
}

read -p "Would you like to load your saved game? (y/n) >>> " input
if [[ $input == "y" ]]; then
    load
fi
clear

name="Coffee Shop"
#start_shop
while true
do
clear
    profit=0
    #tput smul; echo -e " Day $day_num "; tput sgr0
    center " Day $day_num "
    sleep 1
    tput clear
    weather=$(( 20+$RANDOM%15 ))
    center "Weather: $weather"
    sleep 1
    tput clear
    tput rev;echo " Cash: $cash ";tput sgr0
    echo ""
    while true; do
        read -p "How many coffees do you wish make? >>> " coffee_cnt
        if (( $coffee_cnt*$expense > $cash)) || [ ! -z "${coffee_cnt##[0-9]*}" ]; then
            echo "You cannot do that!"
        else
            break
        fi
    done
    while true; do
        read -p "How much do you wish to charge per coffee? >>> " coffee_cost
        if [ ! -z "${coffee_cost##[0-9]*}" ]; then
            echo "You cannot do that!"
        else
            break  
        fi
    done
    read -p "Press enter to open shop: "
    clear
    open_shop
    echo -e "\e[1;7m Day $day_num: Summary \e[0m"    
    calculate_profit $weather $coffee_cost $coffee_cnt
    echo "Profit: $profit"
    cash=$(( $cash+$profit ))
    
        if ! (( $day_num % 7 )) ; then
            cash=$(( cash-50 ))
            echo ""
            echo -e "\e[31mYou paid $"50" in weekly bills\e[0m"
        fi
    
    day_num=$(( day_num+1 ))
    echo ""
    read -p "Press enter to continue: "
    clear
    save
done

