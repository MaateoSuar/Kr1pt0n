#!/bin/bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UTILS_DIR="$BASE_DIR/utils"

if [[ -f "$UTILS_DIR/common.sh" ]]; then
  source "$UTILS_DIR/common.sh"
elif [[ -f "$UTILS_DIR/colors.sh" ]]; then
  source "$UTILS_DIR/colors.sh"
fi

report_path_list() {
  local severity="$1"
  local title="$2"
  local path_list="$3"
  local path_entry

  while IFS= read -r path_entry; do
    [[ -z "$path_entry" ]] && continue
    print_warning "$title: $path_entry"
    append_report "WARNING" "$title: $path_entry"
    register_finding "$severity" "$title: $path_entry"
  done <<< "$path_list"
}

main() {
  local world_writable_files world_writable_dirs root_owned_writable suspicious_scripts

  ensure_runtime
  register_module "perms"
  print_header "Permission Review"

  if ! quick_enabled; then
    print_info "Checking for world-writable files, writable directories, root-owned writable files, and suspicious writable scripts."
  fi

  if ! quick_enabled; then
    print_step "Reviewing world-writable files..."
  fi
  world_writable_files="$(find / -type f -perm -0002 2>/dev/null | head -n 25)"
  [[ -n "$world_writable_files" ]] && report_path_list "HIGH" "World writable file" "$world_writable_files"

  if ! quick_enabled; then
    print_step "Reviewing world-writable directories..."
  fi
  world_writable_dirs="$(find / -type d -perm -0002 2>/dev/null | head -n 25)"
  [[ -n "$world_writable_dirs" ]] && report_path_list "HIGH" "World writable directory" "$world_writable_dirs"

  if ! quick_enabled; then
    print_step "Reviewing writable files owned by root..."
  fi
  root_owned_writable="$(find / -type f -user root -writable 2>/dev/null | head -n 25)"
  [[ -n "$root_owned_writable" ]] && report_path_list "MEDIUM" "Writable file owned by root" "$root_owned_writable"

  if ! quick_enabled; then
    print_step "Reviewing suspicious writable scripts..."
  fi
  suspicious_scripts="$(find / -type f \( -name '*.sh' -o -name '*.py' -o -name '*.pl' \) -writable 2>/dev/null | head -n 25)"
  [[ -n "$suspicious_scripts" ]] && report_path_list "MEDIUM" "Suspicious writable script" "$suspicious_scripts"

  if [[ -z "$world_writable_files$world_writable_dirs$root_owned_writable$suspicious_scripts" ]]; then
    print_info "No obvious insecure permissions were detected in the reviewed sample set."
  fi

  print_warning "Permission review completed."
}

main
