#!/bin/bash

IFS='%' #set field separator to something other than space to preserve whitespace
grid_width=20 #character length
grid_height=8 #line height
refresh_rate=1 #seconds
wall_character='.'
floor_character=' '
stats_directory=".${NAME}_stats"

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
  clear
  draw_grid
  display_stats
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
  tput cup $treat_y $treat_x; echo $treat
}

# Display the emoji, grid, and stats
function display_current_sequence
{
  animate_emoji
  update_stats
  make_sounds
  tput cup $((max_y + 3)) 0
}

function make_sounds
{
  if [[ $make_sounds ]]; then
    tput bel
    sleep '0.3'
    tput bel
    make_sounds=
  fi
}

# Display the stats
function display_stats
{
  # TODO: display stats
  AGE=$(cat "${stats_directory}/age")
  echo "Name: ${NAME} (${AGE} years)"
  # tput setaf 3
  echo 'Health: [ -----    ]'
  # tput sgr0
}
function update_stats
{
  stats=
}

# Move the emoji around the grid
function animate_emoji
{
  # TODO: animate emoji
  tput cup $position_y $position_x; echo $floor_character
  position_x=$(random_position $max_x)
  position_y=$(random_position $max_y)
  tput cup $position_y $position_x; echo $emoji
}

function is_wall_position
{
  return $([[ $1 == 0 || $1 == $max_x || $2 == 0 || $2 == $max_y ]])
}

# Draw the grid
function draw_grid
{
  for (( y=0; y < $grid_height; y++ )); do
    local line=
    for (( x=0; x < $grid_width; x++ )); do
      line+=$(is_wall_position $x $y && echo $wall_character || echo $floor_character)
    done
    echo $line
  done
}

# Program start
initialize
while true; do
  next_sequence
done
