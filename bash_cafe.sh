#!/bin/bash
#!/usr/bin/env bash

#counts the date
day_num=1
#expense is the cost of making a single coffee
expense=1
#sales_mult multiplies the number of sales everyday, can be increased using upgrades (not added yet)
sales_mult=1
#cash user has to spend
cash=100
shop_name=""
SAVE_FILE=""

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
    echo -e "\e[4m Your shops: \e[0m"
    for i in "${saves[@]}"; do
    echo " - $i"
    done
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
    #check if save file exists
    while true; do
        read -p "Which shop would you like to load? >>> " input
        save_file=$input"_save.txt"
        if [[ $(ls) == *"$save_file"* ]]; then
            #load saves file, parse its content into global variables
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

calculate_profit () {
    weather=$1
    cost=$2
    count=$3
    #calculate # of sales
    mult=$(( 5+RANDOM%10 ))
    sales=$(( $(( $(($((weather-20))*10 - mult*cost))/2 ))*sales_mult))
    if [[ ! $sales -gt 0 ]]; then
        sales=0
    fi
    echo "Sales: $sales"
    #calculate income
    if (( sales > count )); then
        income=$(( count*cost ))
    else
        income=$(( sales*cost ))
    fi
    echo "Income: $income"
    #calculate profit
    profit=$(( income-count-$((sales/2)) ))
    return $profit
}

read -p "Would you like to load your saved game? (y/n) >>> " input
if [[ $input == "y" ]]; then
    load
else
    new_save
fi
clear

#main loop
while true; do
clear
    #output the day and weather
    center " Day $day_num "
    sleep 1
    tput clear
    weather=$(( 20+RANDOM%15 ))
    center "Weather: $weather"
    sleep 1
    tput clear
    
    #get user input (coffee_cnt and coffee_cost)
    tput rev;echo " Cash: $cash ";tput sgr0
    echo ""
    while true; do
        read -p "How many coffees do you wish make? >>> " coffee_cnt
        if (( coffee_cnt*expense > cash)) || [ ! -z "${coffee_cnt##[0-9]*}" ]; then
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
    
    #opens shop, displays clock and calculates profit
    read -p "Press enter to open shop: "
    clear
    open_shop
    echo -e "\e[1;7m Day $day_num: Summary \e[0m"  
    profit=0    
    calculate_profit "$weather" "$coffee_cost" "$coffee_cnt"
    
    #display the days summary
    echo "Profit: $profit"
    cash=$(( cash+profit ))
    
        if ! (( day_num % 7 )) ; then
            cash=$(( cash-50 ))
            echo ""
            echo -e "\e[31mYou paid '$'50 in weekly bills\e[0m"
        fi
    
    day_num=$(( day_num+1 ))
    echo ""
    
    read -p "Press enter to continue: "
    clear
    save
done
