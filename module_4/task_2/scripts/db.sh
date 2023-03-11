#!/bin/bash

DB_DIR='./data/users.db'

command=$1
option=$2

validate() {
  local value=$1

  if [[ ! "$value" =~ ^[a-zA-Z\ ]+$ ]]; then
    echo "Entered values must be latin letters!"
    exit 0
  fi
}

addUser() {
  read -p "Enter a user name" userName
  validate $userName

  read -p "Enter a user role" userRole
  validate userRole

  if [[ -e $DB_DIR ]]; then
    echo "$userName, $userRole">>$DB_DIR
  else
     read -p "Do you want to create a file users.db?(Y/N)" response

     if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
        then
            mkdir data
            cd data
            touch users.db
            echo "$userName, $userRole">>$DB_DIR
        else
            exit 0
     fi
  fi
}



case "$command" in
  add) addUser ;;
  backup)  ;;
  restore) ;;
  find) ;;
  "" | help) ;;
  list) ;;
esac