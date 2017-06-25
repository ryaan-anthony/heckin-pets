#!/bin/bash

function create_pet
{
  head -n 1 bin/meta-pets > $1
  echo "NAME=\"$2\"" >> $1
  tail -n +2 bin/meta-pets >> $1
}

function initialize_stats
{
  chmod +x $1
  stats=".$2_stats"
  mkdir -p $stats
  echo 0 > "$stats/age"
  date +%s > "$stats/time"
}

function hexdump_length
{
  echo $1 | hexdump | xargs | wc -c
}

hexdump_length=$(hexdump_length $1)

if [[ ${#1} == 1 && $((hexdump_length)) > 22 && $1 && $2 ]]; then
  create_pet $*
  initialize_stats $*
  echo Type \"./$1\" to wake your pet!
else
  echo $0: wrong number of arguments
  echo $0: provide an emoji and name for your pet
fi
