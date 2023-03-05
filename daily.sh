#!/bin/sh

RED='\033[0;31m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

usage() {
  cat << EOF
Usage: $0 [-c CONFIG_FILE] [-h]

Run daily tasks.

Options:
  -c, --config CONFIG_FILE   Use CONFIG_FILE instead of the default config file.
  -h, --help                 Show this help message and exit.
  -v, --version              Print version and exit.
EOF
}

day_of_week=$(date +%A)

config_file="${XDG_CONFIG_HOME:-$HOME/.config}/tasks/tasks.sh"
[ $# -gt 0 ] && { [ "$1" = "-c" ] || [ "$1" = "--config" ] && config_file="$2"; } || { [ "$1" = "--help" ] || [ "$1" = "-h" ] && { usage; exit 0; } } || { [ "$1" = "--version" ] || [ "$1" = "-v" ] && { printf '1.0'; exit 0; } }
[ ! -f "$config_file" ] && printf "%bError: %s not found.%b\n" "$RED" "$config_file" "$NC" && exit 1 # Check if config file exists, if not print error message and exit

run_task() {
  # Usage: run_task "<comment>"

  # shellcheck source=/dev/null
  . "$config_file"
  [ "$1" != "" ] && keyword="() { # $1" || keyword="() {"
     while IFS= read -r line || [ -n "$line" ]; do # read file line by line
      case $line in
         *"$keyword")
            task_name="${line%%"$keyword"}"
            if [ ! -e /tmp/"$(date +%d.%m.%y)-$task_name" ];then printf "%bExecuting task: %s%b\n" "$CYAN" "$task_name" "$NC" && $task_name && :> /tmp/"$(date +%d.%m.%y)-$task_name";else printf '%bTask %s already executed today.%b\n' "$CYAN" "$task_name" "$NC";fi
         ;;
         *)
         ;;
      esac
   done < "$config_file"
}

printf '%bRunning tasks for %s:%b\n' "$YELLOW" "$day_of_week" "$NC"
run_task "$day_of_week"

printf "%bRunning daily tasks:%b\n" "$YELLOW" "$NC"
run_task
