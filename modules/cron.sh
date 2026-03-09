#!/bin/bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UTILS_DIR="$BASE_DIR/utils"

if [[ -f "$UTILS_DIR/common.sh" ]]; then
  source "$UTILS_DIR/common.sh"
elif [[ -f "$UTILS_DIR/colors.sh" ]]; then
  source "$UTILS_DIR/colors.sh"
fi

inspect_cron_script() {
  local cron_path="$1"
  local file_owner

  [[ -z "$cron_path" ]] && return
  [[ ! -e "$cron_path" ]] && return

  if [[ -w "$cron_path" ]]; then
    print_finding "Writable cron script detected: $cron_path"
    append_report "WARNING" "Writable cron script detected: $cron_path"
    register_finding "HIGH" "Writable cron script detected: $cron_path"
  elif ! quick_enabled; then
    print_info "Referenced cron path exists: $cron_path"
  fi

  if [[ -d "$cron_path" && -w "$cron_path" ]]; then
    print_finding "Writable cron directory detected: $cron_path"
    append_report "WARNING" "Writable cron directory detected: $cron_path"
    register_finding "HIGH" "Writable cron directory detected: $cron_path"
  fi

  if [[ -f "$cron_path" ]]; then
    file_owner="$(stat -c '%U' "$cron_path" 2>/dev/null)"
    if [[ "$file_owner" == "root" && -w "$cron_path" ]]; then
      print_finding "Root-owned writable cron file detected: $cron_path"
      append_report "WARNING" "Root-owned writable cron file detected: $cron_path"
      register_finding "HIGH" "Root-owned writable cron file detected: $cron_path"
    fi
  fi
}

process_cron_line() {
  local line="$1"
  local cron_source="$2"
  local schedule user_field command_field token resolved_path

  [[ -z "$line" ]] && return
  [[ "$line" =~ ^[[:space:]]*# ]] && return

  if [[ "$line" =~ ^[[:space:]]*(@reboot|@yearly|@annually|@monthly|@weekly|@daily|@hourly)[[:space:]]+([^[:space:]]+)[[:space:]]+(.+)$ ]]; then
    schedule="${BASH_REMATCH[1]}"
    user_field="${BASH_REMATCH[2]}"
    command_field="${BASH_REMATCH[3]}"
  elif [[ "$line" =~ ^[[:space:]]*([^[:space:]]+[[:space:]]+){5}([^[:space:]]+)[[:space:]]+(.+)$ ]]; then
    schedule="cron"
    user_field="${line%%${BASH_REMATCH[2]}*}"
    user_field="${BASH_REMATCH[2]}"
    command_field="${BASH_REMATCH[3]}"
  else
    return
  fi

  if [[ "$user_field" == "root" ]]; then
    print_finding "Cron job running as root found in $cron_source"
    append_report "WARNING" "Cron job running as root found in $cron_source"
    register_finding "MEDIUM" "Cron job running as root found in $cron_source"
  fi

  for token in $command_field; do
    [[ "$token" == /* ]] || continue
    resolved_path="${token%%[;&|]*}"
    inspect_cron_script "$resolved_path"
  done
}

scan_cron_file() {
  local cron_file="$1"
  [[ ! -r "$cron_file" ]] && return

  if ! quick_enabled; then
    print_step "Reviewing $cron_file"
  fi

  while IFS= read -r line; do
    process_cron_line "$line" "$cron_file"
  done < "$cron_file"
}

scan_cron_directory() {
  local cron_dir="$1"
  local cron_file

  [[ ! -d "$cron_dir" ]] && return

  if ! quick_enabled; then
    print_step "Reviewing cron directory $cron_dir"
  fi

  while IFS= read -r cron_file; do
    scan_cron_file "$cron_file"
  done < <(find "$cron_dir" -maxdepth 1 -type f 2>/dev/null | sort)
}

main() {
  ensure_runtime
  register_module "cron"
  print_header "Cron Review"

  if ! quick_enabled; then
    print_info "Checking cron jobs, referenced paths, and permissions for insecure scheduled tasks."
  fi

  scan_cron_file "/etc/crontab"
  scan_cron_directory "/etc/cron.d"
  scan_cron_directory "/var/spool/cron"

  print_warning "Cron review completed."
}

run_module() {
  main
}
