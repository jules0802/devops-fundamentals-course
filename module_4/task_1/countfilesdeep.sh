#!/bin/bash

count() {
  echo "$(find $1 -type f | wc -l)"
}

if (($#==0))
then
  echo "Please provide the directory"
fi

for directory in "$@"
do
  if [ ! -d "$directory" ]
  then
    echo "**" Skipping $directory
    continue
  fi


  res=$(count "$directory")
  echo "Directory $directory and it's subdirectories contain $res files"
done


