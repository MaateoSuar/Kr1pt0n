#!/bin/bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UTILS_DIR="$BASE_DIR/utils"

if [[ -f "$UTILS_DIR/common.sh" ]]; then
  source "$UTILS_DIR/common.sh"
elif [[ -f "$UTILS_DIR/colors.sh" ]]; then
  source "$UTILS_DIR/colors.sh"
fi

load_current_language

get_listening_services() {
  if command -v ss >/dev/null 2>&1; then
    ss -tuln 2>/dev/null
  elif command -v netstat >/dev/null 2>&1; then
    netstat -tuln 2>/dev/null
  else
    echo "No supported socket listing tool found."
  fi
}

extract_exposed_services() {
  local socket_output="$1"

  grep -E 'LISTEN|udp' <<< "$socket_output" | grep -E '(:22|:80|:443|:3306|:5432|:6379|:8080|:9000)\b' || true
}

main() {
  local socket_output exposed_services

  ensure_runtime
  register_module "services"
  print_header "Services Review"

  if ! quick_enabled; then
    print_info "Checking listening ports and exposed local services that may deserve review."
  fi

  socket_output="$(get_listening_services)"
  log_message "INFO" "Listening services review started"

  if [[ "$socket_output" == "No supported socket listing tool found." ]]; then
    print_finding "$socket_output"
    append_report "WARNING" "$socket_output"
    register_finding "LOW" "$socket_output"
    return
  fi

  if ! quick_enabled; then
    print_step "Reviewing listening services..."
    print_value_block "Listening services" "$socket_output"
  fi

  exposed_services="$(extract_exposed_services "$socket_output")"
  if [[ -n "$exposed_services" ]]; then
    while IFS= read -r line; do
      [[ -z "$line" ]] && continue
      print_finding "Potentially sensitive exposed service: $line"
      append_report "WARNING" "Potentially sensitive exposed service: $line"
      register_finding "MEDIUM" "Potentially sensitive exposed service: $line"
    done <<< "$exposed_services"
  else
    print_info "No common high-interest listening services were detected in the reviewed output."
  fi

  append_report "INFO" "Services review completed."
}

run_module() {
  main
}
