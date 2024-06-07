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

  while [ $count -lt "$retries" ]; do
    echo -e "$CYAN Attempt $((count + 1)) of $retries... $NC"
    # Evaluate the command
    if eval "$1"; then
      success=true
      break
    else
      ((count++))
      sleep 5 # Adjust the sleep duration as needed
    fi
  done

  if [ "$success" = true ]; then
    echo -e "$GREEN Success: $1 $NC"
  else
    echo -e "$RED Failed after $retries attempts: $1 $NC"
  fi
}

