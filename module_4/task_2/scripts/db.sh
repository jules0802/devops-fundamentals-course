#!/bin/bash

DB_PATH='../data/users.db'

command=$1
option=$2

validate() {
  local value=$1

  if [[ ! "$value" =~ ^[a-zA-Z\ ]+$ ]]
  then
    echo "Entered values must be latin letters!"
    exit 0
  fi
}

addUser() {
  read -p "Enter a user name " userName
  validate "$userName"

  read -p "Enter a user role " userRole
  validate "$userRole"

  if [[ -e $DB_PATH ]]
  then
    echo "$userName, $userRole">>$DB_PATH
  else
     read -p "Do you want to create a file users.db?(Y/N)" response

     if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
        then
            mkdir data
            cd data
            touch users.db
            echo "$userName, $userRole">>$DB_PATH
        else
            exit 1
     fi
  fi
}

showInfo() {
  echo "db.sh helps manipulating users DB"
  echo "Syntax: db.sh [command] [-parameter]"
  echo "Following commands are available:"
  echo "add    Adds a new line to the users.db. The script must prompt a user to type the username of a new entity.
After entering the username, the user must be prompted to type a role."
  echo "backup Creates a new file, named %date%-users.db.backup which is a copy of
current users.db"
  echo "find   Prompts user to type a username, then prints username and role if such
exists in users.db. If there is no user with selected username, script must print:
“User not found”. If there is more than one user with such username, print all
found entries."
  echo "list   Prints contents of users.db in format: N. username, role
where N – a line number of an actual record
Accepts an additional optional parameter inverse which allows to get
result in an opposite order – from bottom to top"
 echo "help    Prints instructions on how to use this script with a description of all available commands"
}

doBackup() {
  backupPath=$(date +'%Y-%m-%d')-users.db.backup
  echo $backupPath
  cp $DB_PATH ../data/$backupPath
}

doRestore() {
  resentBackup=$(ls -t ../data/*.backup | tail -n 1)
  if [[ -e $DB_PATH ]]
  then
    cat "$resentBackup">$DB_PATH
    echo "Database was restored from $resentBackup"
  else
     echo "No backup found"
     exit 0
  fi
}

findUser() {
  read -p "Please type a user name" userName
  res=`grep -i $userName $DB_PATH`

  if [ -z "$res" ]
    then
      echo "User not found"
    else
      echo "$res"
  fi
}

case "$command" in
  add) addUser ;;
  backup) doBackup ;;
  restore) doRestore;;
  find) findUser;;
  "" | help) showInfo ;;
  list) ;;
esac