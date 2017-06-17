#!/bin/bash

function hexdump_length
{
  echo $1 | hexdump | xargs | wc -c
}

function next
{
  hexdump_length=$(hexdump_length $last)
  if [[ $((hexdump_length)) > 22 && ${#last} == 1 ]]; then
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

  read -sn 4 -t 1 last
  clear
}

clear; while true; do next; done
