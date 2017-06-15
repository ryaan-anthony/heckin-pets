#!/bin/bash

function create_pet
{
  head -n 1 src/main.sh > $1
  echo "NAME=\"$2\"" >> $1
  tail -n +2 src/main.sh >> $1
}

function initialize_stats
{
  chmod +x $1
  stats=".$2_stats"
  mkdir -p $stats
  echo 0 > "$stats/age"
  date +%s > "$stats/time"
}

emoji_hexdump=(`echo $1 | hexdump | xargs`)
if [[ ${#1} == 1 && ${#emoji_hexdump} > 22 && $1 && $2 ]]; then
  create_pet $*
  initialize_stats $*
  echo Type \"./$1\" to wake your pet!
else
  echo $0: wrong number of arguments
  echo $0: provide an emoji and name for your pet
fi
