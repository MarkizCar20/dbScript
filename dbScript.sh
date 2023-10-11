#!/bin/bash

#SCRIPT FOR CREATING AND MANAGING SIMPLE DATABASES
directory="./databases"

create_database() {
    if [[ -d "$directory" ]]; then
        touch ./$directory/somethings
    else 
        mkdir "$directory"
        touch ./"$directory"/somethings
    fi
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
echo "For the man pages use -man option, or insert man command"

