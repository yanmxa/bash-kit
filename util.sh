#!/bin/bash

# Define ANSI escape codes for colors
NC='\033[0m' # No Color
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD_GREEN='\033[1;32m'

# Function: retry
# Description: Retries a given command a specified number of times.
# Parameters:
#   $1 - The command to execute.
#   $2 - The number of retries (optional). Defaults to 3 if not provided.
# Usage: retry "command" [number_of_retries]
retry() {
  local retries=${2:-3}
  local count=0
  local success=false

  echo -e "${CYAN}$1 $NC "
  while [ $count -lt "$retries" ]; do
    echo -ne "\r$YELLOW Attempt $((count + 1)) of $retries... $NC"
    if eval "$1"; then
      success=true
      break
    else
      ((count++))
      sleep 5 # Adjust the sleep duration as needed
    fi
  done

  if [ "$success" = true ]; then
    echo -e "${GREEN}$1: Success!$NC"
  else
    echo -e "${RED}$1: Failed after $retries attempts.$NC"
  fi
}

wait_cmd() {
  local command=$1
  local seconds=${2:-"600"}
  local interval=1         # Interval for updating the waiting message
  local command_interval=4 # Interval for executing the command
  local signs=(🙉 🙈 🙊)
  local elapsed=0
  local last_command_run=0

  if eval "${command}"; then
    return 0 
  fi

  while [ $elapsed -le "$seconds" ]; do
    if [ $((elapsed - last_command_run)) -ge $command_interval ]; then
      if eval "${command}" > /dev/null 2>&1; then
        return 0 # Return success status code
      fi
      last_command_run=$elapsed
    fi

    local index=$(((elapsed / interval % ${#signs[@]}) + 1))
    echo -ne "\r ${signs[$index]} Waiting $elapsed seconds ..."
    sleep $interval
    ((elapsed += interval))
  done

  echo -e "$RED Timeout $seconds seconds $NC: $command"
  return 1
}