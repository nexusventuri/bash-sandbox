#!/bin/bash

_LIB_DIR_EXPOSED_FOR_REQUIRE="$PWD/${BASH_SOURCE%/*}"

echo "helpers.sh $PWD $my_folder"

function require {
  target_file="$1"
  target_file_name=$(basename $1)
  current_file="$0"
  current_file_dir=$(dirname $0)

  echo "# require"
  echo ""
  echo "target_file: $target_file"
  echo "current_file: $current_file"
  echo "current_file_dir: $current_file_dir"
  echo "LIB_DIR: $_LIB_DIR_EXPOSED_FOR_REQUIRE"

  source "$_LIB_DIR_EXPOSED_FOR_REQUIRE/$target_file_name"
  echo ""
}

function require_relative {
  current_file="$0"
  current_file_dir=$(dirname "${BASH_SOURCE[1]}")
  required_file="$PWD/$current_file_dir/$1"

  echo "# require_relative"
  echo ""
  echo "current_file: $current_file"
  echo "current_file_dir: $current_file_dir"
  echo "bash_source: ${BASH_SOURCE[1]}"

  source "$required_file"
}

export -f require
export -f require_relative
export _LIB_DIR_EXPOSED_FOR_REQUIRE
