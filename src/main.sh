#!/bin/bash

# Get the length of the hexdump signature
function hexdump_length
{
  echo $1 | hexdump | xargs | wc -c
}

# Describe the request flow
function next_sequence
{
  handle_last_input
  display_current_sequence
  prepare_next_input
}

# Listen for user input
function prepare_next_input
{
  read -sn 4 -t 1 last_input
  clear
}

# Consume user input
function handle_last_input
{
  # Check user input for emoji
  hexdump_length=$(hexdump_length $last_input)
  if [[ $((hexdump_length)) > 22 && ${#last_input} == 1 ]]; then
    saved=$last_input
    last=
  fi
}

# Display the emoji, grid, and stats
function display_current_sequence
{
  # TODO: create a grid for pet
  # TODO: maintain age / time
  # TODO: process user input
  # TODO: health meter
  echo $saved
  echo ${0: -1}
  echo name: $NAME
}

# Program start
clear;
while true; do
  next_sequence
done
