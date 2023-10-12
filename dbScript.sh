#!/bin/bash

#SCRIPT FOR CREATING AND MANAGING SIMPLE DATABASES
directory="./databases"

create_database() {
    echo "Please enter database name:"
    read db_name
    if [[ -d "$directory" ]]; then
        touch ./"$directory"/"$db_name.txt"
    else 
        mkdir "$directory"
        touch ./"$directory"/"$db_name.txt"
    fi
    echo "$db_name" >> ./"$directory"/"$db_name.txt"
    stars=$(printf "*%.0s" {1..39})
    echo "$stars" >> ./"$directory"/"$db_name.txt"
}

create_table() {
    echo "Enter the database in which you would like to create a table: "
    read db_name
    if [[ ! -d "./$directory" ]]; then
    echo "Folder doesn't exist, create a database first!"
    exit
    else
        if [[ ! -e "./$directory/$db_name.txt" ]]; 
        then
            echo "Database doesn't exist, you need to create it first!"
            exit
        fi
    fi

    words=()
    echo "Enter your collumns names (Max size 8 chars):"
    line_length=11
    while IFS= read -r word
    do
        string_length=${#word}
        line_length=$((line_length + string_length))

        if [ -z "$word" ]
        then
            break
        fi

        if [ "$string_length" -gt 7 ]
        then
            echo "Name is too big, choose a different name!!"
            continue
        fi

        if [ "$line_length" -gt 39 ]
        then
            echo "Sum of collumn names is too big, ending collumn input!"
            break
        fi

        words+=("$word")
        
    done
    echo "Creating table with given collumn names!"
    pattern="**"
    for word in "${words[@]}"
    do
        num_spaces=$((7 - ${#word}))
        pattern+=" ${word}"

        for ((i = 0; i < num_spaces; i++)); 
        do
        pattern+=" "
        done
        pattern+="*"
    
    done
    #stars=$(printf "*%.0s" {1..39})
    pattern+="*"
    echo "$pattern" >> ./"$directory"/"$db_name.txt"
    #echo "$stars" >> ./"$directory"/"$db_name.txt"

}

#this can be done with the sed command
display_data() {
    echo "Data"
}

#thinking about using either sed or awk
add_data() {
    echo "To which database would you like to add?"
    read db_name

    echo "Enter the values for the following parameters:"
    sed -n '/^\*\* /p' ./"$directory"/"$db_name.txt"
    
    words=()

    while IFS= read -r word
    do
        string_length=${#word}
        line_length=$((line_length + string_length))

        if [ -z "$word" ]
        then
            break
        fi

        if [ "$string_length" -gt 7 ]
        then
            echo "Value too large, choose a smaller value!!"
            continue
        fi

        words+=("$word")
        
    done

    pattern="**"
    for word in "${words[@]}"
    do
        num_spaces=$((7 - ${#word}))
        pattern+=" ${word}"

        for ((i = 0; i < num_spaces; i++)); 
        do
        pattern+=" "
        done
        pattern+="*"
    
    done

    pattern+="*"
    echo "$pattern" >> ./"$directory"/"$db_name.txt"
    echo "Added row to table!"
}

#definetely sed with this
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

    case "$command" in
        "create-db")
        echo "You chose to create a database"
        create_database
        ;;
        "create-table")
        echo "You chose to create a table"
        create_table
        ;;
        "read-value")
        echo "You chose to read a value"
        display_data
        ;;
        "add-value")
        echo "You chose to add a value"
        add_data
        ;;
        "remove-data")
        echo "You chose to delete a value"
        delete_data
        ;;
        "man")
        display_pages
        ;;
        "quit")
        echo "Exiting"
        break
        ;;
        *)
        echo "Command doesn't exist -> Check manual pages!!"
        ;;
    esac

done 
