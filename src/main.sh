#!/bin/bash

grid_width=25 #character length
grid_height=10 #line height
refresh_rate=10 #seconds
wall_character='#'
floor_character='.'
prompt='Type an Emoji: '
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

function refresh_screen
{
  tput clear
}

function initialize
{
  refresh_screen
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
  read -sn 4 -t $refresh_rate -p "$prompt" last_input
  refresh_screen
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
  display_stats
  draw_grid
}

# Display the stats
function display_stats
{
  # TODO: display stats
  AGE=$(cat "${stats_directory}/age")
  echo "Name: ${NAME} (${AGE} years)"
  echo 'Health: |||||||||||...'
  echo 'Hunger: ||||||........'
}

# Move the emoji around the grid
function animate_emoji
{
  # TODO: animate emoji
  local animation=
}

function is_emoji_position
{
  if [[ $position_x == $1 && $position_y == $2 ]]; then
    return 0 # true
  fi
  return 1 # false
}

function is_treat_position
{
  if [[ $treat_x == $1 && $treat_y == $2 ]]; then
    return 0 # true
  fi
  return 1 # false
}

function is_wall_position
{
  if [[ $1 == 0 || $1 == $max_x || $2 == 0 || $2 == $max_y ]]; then
    return 0 # true
  fi
  return 1 # false
}

# Draw the grid
function draw_grid
{
  for (( y=0; y < $grid_height; y++ )); do
    local line=
    for (( x=0; x < $grid_width; x++ )); do
      # Default character is a floor
      local character=$floor_character
      # Draw the emoji
      if is_emoji_position $x $y; then character=$emoji; fi
      # Draw the treat
      if is_treat_position $x $y; then character=$treat; fi
      # Draw the wall
      if is_wall_position $x $y; then character=$wall_character; fi
      # Build the line
      line+=$character
    done
    echo $line
  done
}

# Program start
initialize;
while true; do
  next_sequence
done
