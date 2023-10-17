#!/bin/bash
#SCRIPT FOR CREATING AND MANAGING SIMPLE DATABASES

directory="./databases"

database_check() {

    if [[ ! -d "./$directory" ]]; then
    echo "Folder doesn't exist, create a database folder first!"
    break
    else
        if [[ ! -e "./$directory/$db_name.txt" ]]; 
        then
            echo "Database doesn't exist, you need to create it first!"
            break
        fi
    fi

}

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
    database_check

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

    pattern+="*"
    echo "$pattern" >> ./"$directory"/"$db_name.txt"

}

display_data() {

    echo "From which database would you like to read a value:"
    read db_name

    database_check

    echo "These are the database parameters:"
    sed -n '/^\*\* /{p;q;}' ./"$directory"/"$db_name.txt"
    read -p "Enter the column name: " col_name
    read -p "Enter the value to search for: " search_value

    if [ -z "$search_value" ] || [ -z "$col_name" ]
    then
        echo "Printing the entire database: "
        cat ./"$directory"/"$db_name.txt"
        break
    fi

    awk -F"[ *]+" -v col_name="$col_name" -v search_value="$search_value" '
        NR == 3 { 
            for (i = 1; i <= NF; i++) {
                if ($i == col_name) {
                 col = i
                }
            }
        }

        NR > 3 && $col == search_value {
            print $0
        }
    ' ./"$directory"/"$db_name.txt"

    # read value
    # rows=$(grep "^\*\* $value[[:space:]]*\*" ./"$directory"/"$db_name.txt") 
    # if [ "$rows" = "" ]
    # then
    #     echo "There is no data of specified value"
    # else
    #     echo "Rows with specified data"
    #     echo "$rows"
    # fi

}

add_data() {

    echo "To which database would you like to add?"
    read db_name

    database_check

    count=$(grep -m 1 "^\*\* " databases/"$db_name".txt | grep -o "\* " | wc -l)
    echo "Enter the values for the following parameters(Enter / for no value): "
    sed -n '/^\*\* /{p;q;}' ./"$directory"/"$db_name.txt"
    
    words=()

    while [ "$count" -gt 0 ] && IFS= read -r word
    do

        string_length=${#word}
        line_length=$((line_length + string_length))

        if [ "$string_length" -gt 7 ]
        then
            echo "Value too large, choose a smaller value!!"
            continue
        fi

        (( count-- ))

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

delete_data() {

    read -p "From which table would you like to delete data: " db_name
    database_check
    
    read -p "Enter the column name you're searching for: " col_value
    read -p "Enter the value you want to delete: " search_value

    found=0
    data_found=0
    awk -F'[ *]+' -v column_value="$col_value" -v search_value="$search_value" '
        NR == 3 {
            for(i=1; i <= NF; i++) {
                if ($i == column_value) {
                    col=i
                    break
                    found=1
                }
            }
            if (found == 0) {
                exit
            }
        }
        NR <= 3 || $col != search_value {
            print $0
            data_found=1
        }
    ' col=0 ./"$directory"/"$db_name.txt" > ./"$directory"/"$db_name.temp"
    mv ./"$directory"/"$db_name.temp" ./"$directory"/"$db_name.txt"

    if [ "$found" == 0 ]
    then
        echo "Column doesn't exist"
    fi
    if [ "$data_found" == 0 ]
    then
        echo "Data doesn't exist"
    fi
}

display_pages() {

    cat ./man_pages.txt

}

echo "Welcome to the Database management script"
echo "*****************************************"
echo "For the manual pages, use command man"
echo "*****************************************"
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
        "read-data")
        echo "You chose to read a value"
        display_data***************************************************
        ;;
        "add-data")
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