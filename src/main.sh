#!/bin/bash

function next
{
  emoji_hexdump=$(echo $last | hexdump | xargs)
  if [[ ${#emoji_hexdump} > 22 && ${#last} == 1 ]]; then
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
