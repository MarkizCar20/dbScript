#!/bin/bash

#SCRIPT FOR CREATING AND MANAGING SIMPLE DATABASES
directory="./databases"

create_database() {
    echo "Please enter database name:"
    read db_name
    if [[ -d "$directory" ]]; then
        touch ./"$directory"/"$db_name"
    else 
        mkdir "$directory"
        touch ./"$directory"/"$db_name"
    fi
    echo "$db_name" >> ./"$directory"/"$db_name"
    stars=$(printf "*%.0s" {1..39})
    echo "$stars" >> ./"$directory"/"$db_name"
}

create_table() {
    echo "create_table"
}

display_data() {
    echo "Data"
}

add_data() {
    echo "Data add"
}

delete_data() {
    echo "Data delete"
}

display_pages() {
    echo "Man Pages"
}

echo "Welcome to the Database management script"
echo "*****************************************"
echo "For the manual pages, use command man"
while [ 1 ]
do
    echo "What would you like to do:"
    read command

    create_database

done 
