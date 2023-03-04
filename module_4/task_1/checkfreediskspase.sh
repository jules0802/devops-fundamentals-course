#!/bin/bash

typeset threshold=${1:-60}

df -h | while
  read filesystem size used avail capacity rest
  do

    if [[ $filesystem == *"disk"* ]]
    then
      usedSpace=$(echo $capacity | sed s/%//g)

      if ((usedSpace>threshold))
      then
        echo "Warning! The free space on your disk partition $filesystem is about to end! Less then $threshold left \($usedSpace used\)"
      fi
     fi

    ((n++))
  done




