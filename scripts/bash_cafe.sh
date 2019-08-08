#!/bin/bash
#!/usr/bin/env bash
. functions/save_load_functions.sh
. functions/menu_functions.sh
. functions/calculation_functions.sh
. functions/weather_functions.sh
. functions/upgrade_functions.sh
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

get_saves
if [[ $? == 0 ]]; then
    read -p "Would you like to load your saved game? (y/n) >>> " input
    if [[ $input == "y" ]]; then
        load
    else
        new_save
        save
    fi
else
    new_save
    save
fi

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
        elif [ -z "$coffee_cnt" ]; then
            echo "invalid!"
	    :
        else
            break
        fi
    done
    while true; do
        read -p "How much do you wish to charge per coffee? >>> " coffee_cost
        if [ ! -z "${coffee_cost##[0-9]*}" ]; then
            echo "You cannot do that!"
	elif [ -z "$coffee_cnt" ]; then
	    :
        else
            break  
        fi
    done
    
    #opens shop, displays clock and calculates profit
    read -p "Press enter to open shop: "
    clear
    open_shop
    echo -e "\e[1;7m $shop_name on Day $day_num \e[0m"  
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
    #get next action from user
    day_menu
    #case statement for menu return
    menu_cases $?
done
