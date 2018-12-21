#!/bin/bash

# Use this script to batch a series of commands into one bash
# command while still understanding what is going on "under the hood."
#
# For each command fed into execute_cmds(), the script will print the
# command and then execute it. If a command fails, the script will not execute
# the commands following the failure and will output a failure message,
# specifying at which command the list of commands failed at.
#
# Example:
#
#  local cmds=(
#    "export SOME_ENV_VAR=/some/env/var
#    "cd $SOME_ENV_VAR/some/path"
#    "some command"
#    "cd -"
#  )
#  execute_cmds "${cmds[@]}"

STATUS_COLOR='\033[0;36m'  # Cyan
ERROR_COLOR='\033[0;31m'  # Red
CMD_COLOR='\033[0;33m'  # Brown
NC='\033[0m'

# Runs a series of commands passed as an array.
function execute_cmds() {
  local cmds=("$@")
  for (( i = 0; i < ${#cmds[@]}; i++ ));
  do
    run_cmd "${cmds[$i]}" || return 1
  done
  print_status "Done."
}

# Prints command and evaluates, exits with failure messsage if fails.
function run_cmd() {
  local command=$1
  print_cmd "$command"
  eval $command
  [ $? -eq 0 ] || { print_error "Failed: $1."; return 1; }
}

function print_cmd() {
  echo -e "${CMD_COLOR}---\n\$ $1${NC}\n"
}

function print_status() {
  echo -e "${STATUS_COLOR}$1${NC}"
}

function print_error() {
  echo -e "${ERROR_COLOR}$1${NC}"
}

