#!/bin/bash

function next
{
  if [[ ${#last} == 1 ]]; then
    saved=$last
    last=
  fi
  # TODO: create a grid for pet
  # TODO: maintain age / time
  # TODO: process user input
  # TODO: health meter
  echo $saved
  echo ${0: -1}
  echo name: $NAME

  read -n 4 -t 5 last
  clear
}

clear; while true; do next; done
