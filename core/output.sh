#!/bin/bash

print_info() {
  local message="$1"

  if [[ "${KR1PT0N_QUICK:-0}" -eq 1 ]]; then
    return
  fi

  echo -e "${GREEN}[+]${RESET} ${message}"
}

print_warning() {
  local message="$1"

  if [[ "${KR1PT0N_QUICK:-0}" -eq 1 ]]; then
    return
  fi

  echo -e "${YELLOW}[!]${RESET} ${message}"
}

print_error() {
  local message="$1"
  echo -e "${RED}[-]${RESET} ${message}"
}

print_step() {
  local message="$1"

  if [[ "${KR1PT0N_QUICK:-0}" -eq 1 ]]; then
    return
  fi

  echo -e "${BLUE}[>]${RESET} ${message}"
}

print_header() {
  local title="$1"

  if [[ "${KR1PT0N_QUICK:-0}" -eq 1 ]]; then
    return
  fi

  echo
  echo -e "${CYAN}${BOLD}== ${title} ==${RESET}"
}

print_value_block() {
  local label="$1"
  local value="$2"

  if [[ "${KR1PT0N_QUICK:-0}" -eq 1 ]]; then
    return
  fi

  print_info "$label"
  if [[ -n "$value" ]]; then
    while IFS= read -r line; do
      echo "    $line"
    done <<< "$value"
  else
    echo "    No data found."
  fi
}

print_finding() {
  local message="$1"
  echo -e "${YELLOW}[!]${RESET} ${message}"
}
