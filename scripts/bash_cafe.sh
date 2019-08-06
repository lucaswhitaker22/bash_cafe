#!/bin/bash
#!/usr/bin/env bash
. save_load_functions.sh
. user_interface_functions.sh

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
