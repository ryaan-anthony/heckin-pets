#!/bin/bash

IFS='%' #set field separator to something other than space to preserve whitespace
grid_width=20 #character length
grid_height=8 #line height
refresh_rate=1 #seconds
wall_character='🔸'
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
  target_x=$(random_position $max_x)
  target_y=$(random_position $max_y)
  position_x=$(random_position $max_x)
  position_y=$(random_position $max_y)
  emoji=${0: -1}
  clear
  tput setaf 9
  tput civis --invisible
  draw_grid
  display_stats
  tput sgr0
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
    return
  fi
  tput cup $treat_y $treat_x; echo $treat
}

# Display the emoji, grid, and stats
function display_current_sequence
{
  animate_emoji
  update_stats
  make_sounds
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
  tput cup 2 $((max_x + 3)); echo "Name: ${NAME} (${AGE} years)"
  # tput setaf 3
  tput cup 3 $((max_x + 3)); echo 'Health: [️❤️ ❤️ ❤️ ❤ ❤ ]'
}
function update_stats
{
  :
}

# Move the emoji around the grid
function animate_emoji
{
  local old_x=$position_x
  local old_y=$position_y
  move_to_target && : || update_emoji $old_y $old_x $position_y $position_x
}

function update_emoji
{
  tput cup $1 $2; echo $floor_character
  tput cup $3 $4; echo $emoji
}

function move_to_target
{
  find_target
  if [[ $position_y -lt $target_y && $(((RANDOM % 3))) == 1 ]]; then
    position_y=$((position_y + 1))
  elif [[ $position_x -lt $target_x && $(((RANDOM % 3))) == 1 ]]; then
    position_x=$((position_x + 1))
  elif [[ $position_y -gt $target_y && $(((RANDOM % 3))) == 1 ]]; then
    position_y=$((position_y - 1))
  elif [[ $position_x -gt $target_x && $(((RANDOM % 3))) == 1 ]]; then
    position_x=$((position_x - 1))
  elif [[ $position_y == $target_y && $position_x == $target_x ]]; then
    # At target, return true
    return 0
  else
    # Undecided move, try again
    return $(move_to_target)
  fi
  return 1
}

function find_target
{
  ((RANDOM % 5)) && : || set_target
}

function set_target
{
  target_x=$(random_position $max_x)
  target_y=$(random_position $max_y)
}

function is_even
{
  [ $(($1%2)) -eq 0 ]
}

function is_wall_position
{
  [ $1 -eq 0 ] || [ $1 -eq $grid_width ] || ([ $2 -eq 0 ] && is_even $1) || ([ $2 -eq $grid_height ] && is_even $1)
}

# Draw the grid
function draw_grid
{
  for (( y=0; y < $((grid_height + 1)); y++ )); do
    local line=
    for (( x=0; x < $((grid_width + 1)); x++ )); do
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
