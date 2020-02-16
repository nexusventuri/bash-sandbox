#!/bin/bash

_LIB_DIR_EXPOSED_FOR_HELPERS="${BASH_SOURCE%/*}"
_PROJECT_DIR_EXPOSED_FOR_HELPERS="${BASH_SOURCE%/*/*}"
_PROJECT_NAME_EXPOSED_FOR_HELPERS=$(basename $0)
_COMMAND_DIR_EXPOSED_FOR_HELPERS="$_PROJECT_DIR_EXPOSED_FOR_HELPERS/${_PROJECT_NAME_EXPOSED_FOR_HELPERS}_"
# echo "lib dir: $_LIB_DIR_EXPOSED_FOR_HELPERS"
# echo "project dir: $_PROJECT_DIR_EXPOSED_FOR_HELPERS"
# echo "project name: $_PROJECT_NAME_EXPOSED_FOR_HELPERS"
# echo "command dir: $_COMMAND_DIR_EXPOSED_FOR_HELPERS"

set -e
settings_file="${_PROJECT_DIR_EXPOSED_FOR_HELPERS}/.${_PROJECT_NAME_EXPOSED_FOR_HELPERS}"
if [[ -f "$settings_file" ]]; then
  source "$settings_file"
fi

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

function find_existing_command_path {
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

function generate_path_for_new_command {
  if [[ "$(validate_command_name $1)" == "1" ]]; then 
    echo 'invalid command name'
    exit 1
  fi

  command="$_COMMAND_DIR_EXPOSED_FOR_HELPERS/$1"
  if [[ "$2" != "" ]]; then
    if [[  "$(validate_command_name $2)" == "1" ]]; then
      echo 'invalid sub command name'
    else
      command="$_COMMAND_DIR_EXPOSED_FOR_HELPERS/$1_/$2"
    fi
  fi
  echo "$command"
}

function validate_command_name {
  echo "$1"
  if [[ ! $1 =~ ^[0-9a-zA-Z_-]+$ ]]; then
    return 1
  fi
  return 0
}

function file_name_to_command {
  echo "$1" | sed "s|^$_COMMAND_DIR_EXPOSED_FOR_HELPERS||g" | sed "s/_/ /g" | sed 's/\///g'
}

function execute_command {
  command_path=$(find_existing_command_path ${@:1})

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

export -f find_existing_command_path
export -f validate_command_name
export -f generate_path_for_new_command 
export -f file_name_to_command
export -f is_sub_command

export _LIB_DIR_EXPOSED_FOR_HELPERS
export _COMMAND_DIR_EXPOSED_FOR_HELPERS
export _PROJECT_DIR_EXPOSED_FOR_HELPERS
export _PROJECT_NAME_EXPOSED_FOR_HELPERS
