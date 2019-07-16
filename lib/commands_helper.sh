#!/bin/bash

_LIB_DIR_EXPOSED_FOR_HELPERS="$PWD/${BASH_SOURCE%/*}"
_PROJECT_NAME_EXPOSED_FOR_HELPERS=$(basename $0)
_PROJECT_DIR_EXPOSED_FOR_HELPERS="$PWD"
_COMMAND_DIR_EXPOSED_FOR_HELPERS="$PWD/commands"

function commands_path {
  echo "$_COMMAND_DIR_EXPOSED_FOR_HELPERS/$1"
}

function project_path {
  echo "$_PROJECT_DIR_EXPOSED_FOR_HELPERS/$1"
}

function project_name {
  echo "$_PROJECT_NAME_EXPOSED_FOR_HELPERS"
}

function require {
  target_file="$1"
  target_file_name=$(basename $1)
  current_file="$0"
  current_file_dir=$(dirname $0)

  source "$_LIB_DIR_EXPOSED_FOR_HELPERS/$target_file_name"
}

function require_relative {
  current_file="$0"
  current_file_dir=$(dirname "${BASH_SOURCE[1]}")
  required_file="$PWD/$current_file_dir/$1"

  source "$required_file"
}


function show_help {
  help_command=$(commands_path "help")
  $help_command $@
}

function command_to_path {
  command="$_COMMAND_DIR_EXPOSED_FOR_HELPERS/$1"
  sub_command="$_COMMAND_DIR_EXPOSED_FOR_HELPERS/$1_/$2"

  if [[ -f "$sub_command" && -x "$sub_command" ]]; then
    echo "$sub_command"
  elif [[ -f "$command" && -x "$command" ]]; then
    echo "$command"
  else
    echo "/??/"
  fi
}

function file_name_to_command {
  echo "$1" | sed "s|^$_COMMAND_DIR_EXPOSED_FOR_HELPERS||g" | sed "s/_/ /g" | sed 's/\///g'
}

function execute_command {
  command_path=$(command_to_path ${@:1})

  if is_sub_command "${@:1}"; then
    $command_path "${@:3}"
    exit $?
  elif [[ -f "$command_path" ]]; then
    $command_path "${@:2}"
    exit $?
  elif [[ -z "$1" ]]; then
    show_help "${@:2}"
    exit 1
  else
    echo "Sorry, I don't know how to run command: $1"
    echo ""
    show_help "${@:2}"
    exit 1
  fi
}

function is_sub_command {
  sub_command="$_COMMAND_DIR_EXPOSED_FOR_HELPERS/$1_/$2"

  if [[ -f "$sub_command" && -x "$sub_command" ]]; then
    true
  else
    false
  fi
}

export -f require
export -f show_help
export -f require_relative
export -f execute_command

export -f commands_path
export -f project_path
export -f project_name

export -f command_to_path
export -f file_name_to_command
export -f is_sub_command

export _LIB_DIR_EXPOSED_FOR_HELPERS
export _COMMAND_DIR_EXPOSED_FOR_HELPERS
export _PROJECT_DIR_EXPOSED_FOR_HELPERS
export _PROJECT_NAME_EXPOSED_FOR_HELPERS
