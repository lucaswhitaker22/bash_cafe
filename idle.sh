#!/bin/bash
#"\e[31m \e[0m"
. C:/cygwin/style.sh

day_num=1
expense=1

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


start_shop () {
    echo "You just bought a coffee shop on a local street"
    echo "By evaluating the weather, you can determine how many visitors you may have"
    echo "Upgrade your shop to increase the number of visitors"
    echo "What would you like to name your shop?"
    read -r name
}


calculate_profit () {
    weather=$1
    cost=$2
    count=$3
    echo count: $count
    #calculate # of sales
    mult=$(( 5+$RANDOM%10 ))
    sales=$(( $((weather*2 - mult*cost))/2 ))
    echo sales: $sales
    #calculate income
    if (( sales > count )); then
        income=$(( count*cost ))
    else
        income=$(( sales*cost ))
    fi
    echo income: $income
    #calculate profit
    profit=$(( income-count ))
    return $profit
}

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
    
    echo "Press enter to open shop: "
    read -r
    clear
    
    open_shop
    echo -e "\e[1;7m Day $day_num: Summary \e[0m"    
    calculate_profit $weather $coffee_cost $coffee_cnt
    echo "Profit: $profit"
    cash=$(( $cash+$profit ))
    day_num=$(( day_num+1 ))
    echo ""
    echo "Press enter to continue: "
    read -r
    clear
done