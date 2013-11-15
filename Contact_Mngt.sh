#!/usr/bin/env bash
# ===
# Script for Building a Contact Management System
# Author: Vinod
# ===
#Variables
Filename=$1
_mydir="$(pwd)"
#terminal coloring helper variables
CLR_GREEN="\033[01;32m"
CLR_RED="\033[1;31m"
CLR_END="\033[0m"

function dec_line () {
# This function will take all the arguments passed to it and will print out
# $* contains all the arguments passed
echo "************ $* **************"
}
function printclr () {
# This function is a wrapper which will take all the arguments passed to it
# and color it out in green using the variables we set previously
echo -e $CLR_GREEN"${*}"$CLR_END
}
function printerr () {
# This function is a wrapper which will take all the arguments passed to it
# and color it out in red using the variables we set previously
echo -e $CLR_RED"[ERROR] ${*}"$CLR_END
}

function Create_records () {
# This function is to add a contact to record
 echo "Please enter the following contact details:"
 
read -p "Given name: " firstname
read -p "Surname: " lastname
read -p "Address: " address
read -p "City: " city
read -p "State: " state
read -p "Zip: " zip

grep "^${firstname}" $Filename > /dev/null
if [ $? -eq 0 ]; then
   printerr "Contact ${firstname} already exists"
else
 echo "${firstname}:${lastname}:${address}:${city}:${state}:${zip}" >> $Filename 
[ $? -eq 0 ] && printclr "Contact ${firstname} has been added to the record!" || printerr "Failed to add the Contact ${firstname}"
fi
}

function View_records () {

echo "  First Name    Surname         Address        City           State       Zip "
echo "======================================================================================="
array="$(cat $Filename)"
for i in $array
do
OIFS="$IFS"
IFS=':'
read -a dnsservers <<< "${i}"
IFS="$OIFS"
echo " ${dnsservers[0]}       ${dnsservers[1]}             ${dnsservers[2]}          ${dnsservers[3]}             ${dnsservers[4]}            ${dnsservers[5]}"


done
}

function Search_records () {
read -p "Enter the pattern to search in ${Filename} : " pattern
search_pattern="$(grep "$pattern" $Filename)" 
#echo "$search_pattern"
echo "  First Name    Surname         Address           City          State        Zip "
echo "======================================================================================"

OIFS="$IFS"
IFS=':'
read -a dnsservers <<< "${search_pattern}"
IFS="$OIFS"
echo " ${dnsservers[0]}       ${dnsservers[1]}             ${dnsservers[2]}          ${dnsservers[3]}             ${dnsservers[4]}            ${dnsservers[5]}"
}

function Delete_records () {
read -p "Enter the pattern to be deleted or press enter to delete all contacts  : " del_pattern
if [ -z "$del_pattern" ]; then
echo "" > $Filename
else

echo "$(sed '/'"$del_pattern"'/d' $Filename)" > $Filename 
[ $? -eq 0 ] && printclr " Pattern $del_pattern has been deleted from the record!" || printerr "unable to delete $del_pattern " 
fi

}


#Logic
# Check if the script is being run by the root user if not exit out
if [ $(id -u) -ne 0 ]; then
printerr "only root user can run this script"
exit 1
fi

if [ -z "$Filename" ]; then
printerr " Please mention the record name"
exit 1
else
[ -f $_mydir ] && echo "Found" || touch $Filename
fi


# while with true will loop for ever, until we exit out explicitly
printclr "               SHELL PROGRAMMING DATABASE"
printclr "                       MAIN MENU"
echo
echo
while true
do
#Menu that we want to show to the user
echo

echo "What do you wish to do?"
echo
echo "1. Create records"
echo "2. View records"
echo "3. Search for records"
echo "4. Delete records that match a pattern"

#echo -e will allow it to recognize special symbols in this case \c
#which will cause the echo to supress new line and stay at the current line
echo -e "Answer (or 'q' to quit)? \c"
read choice junk
#continue if the user has not entered any option and show the menu again
[ "$choice" = "" ] && continue
#Using case to sort out which function to call
case $choice in
1)
dec_line "Create records"
Create_records
;;
2)
dec_line "View records"
View_records
;;
3)
dec_line "Search for records"
Search_records
;;
4)
dec_line "Delete records that match a pattern"
Delete_records
;;
q)
exit 0
;;
*)
printerr "Only takes 1..4 and q to exit"
;;
esac
done
