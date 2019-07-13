#!/bin/bash

_LIB_DIR_EXPOSED_FOR_HELPERS="$PWD/${BASH_SOURCE%/*}"
_PROJECT_NAME_EXPOSED_FOR_HELPERS=$(basename $0)
_PROJECT_DIR_EXPOSED_FOR_HELPERS="$PWD"
_COMMAND_DIR_EXPOSED_FOR_HELPERS="$PWD/commands"

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

function execute_command {
  command="$_COMMAND_DIR_EXPOSED_FOR_HELPERS/$1"

  if [[ -f "$command" && -x "$command" ]]; then
    $command "${@:2}"
    exit $?
  else
    help_command="$_COMMAND_DIR_EXPOSED_FOR_HELPERS/help"
    echo "Sorry, I don't know how to run command: $1"
    echo ""
    $help_command "${@:2}"
    exit 1
  fi
}

function project_path {
  echo "$_PROJECT_DIR_EXPOSED_FOR_HELPERS/$1"
}

function commands_path {
  echo "$_COMMAND_DIR_EXPOSED_FOR_HELPERS/$1"
}

function project_name {
  echo "$_PROJECT_NAME_EXPOSED_FOR_HELPERS"
}

export -f require
export -f require_relative
export -f execute_command

export -f commands_path
export -f project_path
export -f project_name

export _LIB_DIR_EXPOSED_FOR_HELPERS
export _COMMAND_DIR_EXPOSED_FOR_HELPERS
export _PROJECT_DIR_EXPOSED_FOR_HELPERS
export _PROJECT_NAME_EXPOSED_FOR_HELPERS
