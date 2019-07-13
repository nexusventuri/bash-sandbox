#!/bin/bash

_LIB_DIR_EXPOSED_FOR_REQUIRE="$PWD/${BASH_SOURCE%/*}"

function require {
  target_file="$1"
  target_file_name=$(basename $1)
  current_file="$0"
  current_file_dir=$(dirname $0)

  source "$_LIB_DIR_EXPOSED_FOR_REQUIRE/$target_file_name"
}

function require_relative {
  current_file="$0"
  current_file_dir=$(dirname "${BASH_SOURCE[1]}")
  required_file="$PWD/$current_file_dir/$1"

  source "$required_file"
}

export -f require
export -f require_relative
export _LIB_DIR_EXPOSED_FOR_REQUIRE
