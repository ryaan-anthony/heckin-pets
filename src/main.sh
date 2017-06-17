#!/bin/bash

grid_width=20 #character length
grid_height=10 #line height
refresh_rate=10 #seconds
wall_character='#'
floor_character='.'

# Get the length of the hexdump signature
function hexdump_length
{
  echo $1 | hexdump | xargs | wc -c
}

function random_position
{
  local max=$(($1 - 2))
  echo $(( ( RANDOM % $max )  + 1 ))
}

function initialize
{
  max_x=$((grid_width -1))
  max_y=$((grid_height -1))
  position_x=$(random_position $max_x)
  position_y=$(random_position $max_y)
  emoji=${0: -1}
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
  read -sn 4 -t $refresh_rate last_input
  clear
}

# Consume user input
function handle_last_input
{
  # Check user input for emoji
  local hexdump_length=$(hexdump_length $last_input)
  if [[ $((hexdump_length)) > 22 && ${#last_input} == 1 ]]; then
    treat=$last_input
    place_treat
    last_input=
  fi
}

function place_treat
{
  treat_x=$(random_position $max_x)
  treat_y=$(random_position $max_y)
  if [[ $treat_x == $position_x || $treat_y == $position_y ]]; then
    place_treat
  fi
}

# Display the emoji, grid, and stats
function display_current_sequence
{
  animate_emoji
  draw_grid
  display_stats
}

function display_stats
{
  # TODO: display stats
  echo name: $NAME
}

function animate_emoji
{
  # TODO: animate emoji
  local animation=
}

function draw_grid
{
  for (( y=0; y < $grid_height; y++ )); do
    local column=
    for (( x=0; x < $grid_width; x++ )); do
      local character=$floor_character
      if [[ $position_x == $x && $position_y == $y ]]; then
        character=$emoji
      fi
      if [[ $treat_x == $x && $treat_y == $y ]]; then
        character=$treat
      fi
      if [[ $x == 0 || $x == $max_x || $y == 0 || $y == $max_y ]]; then
        character=$wall_character
      fi
      column+=$character
    done
    echo $column
  done
}
# Program start
clear;
initialize;
while true; do
  next_sequence
done
