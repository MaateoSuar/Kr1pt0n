#!/bin/bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UTILS_DIR="$BASE_DIR/utils"
DATA_DIR="$BASE_DIR/data"

if [[ -f "$UTILS_DIR/common.sh" ]]; then
  source "$UTILS_DIR/common.sh"
elif [[ -f "$UTILS_DIR/colors.sh" ]]; then
  source "$UTILS_DIR/colors.sh"
fi

load_current_language

RED="${RED:-}"
GREEN="${GREEN:-}"
YELLOW="${YELLOW:-}"
CYAN="${CYAN:-}"
BOLD="${BOLD:-}"
RESET="${RESET:-}"

quick_enabled() {
  [[ "${KR1PT0N_QUICK:-0}" -eq 1 ]]
}

print_finding() {
  local finding="$1"
  local why="$2"
  local follow_up="$3"

  print_warning "$finding"
  if ! quick_enabled; then
    echo -e "${YELLOW}    ${TXT_PRIVESC_WHY}${RESET} ${why}"
    if [[ -n "$follow_up" ]]; then
      echo -e "${CYAN}    ${TXT_PRIVESC_GUIDANCE}${RESET} ${follow_up}"
    fi
    echo
  fi
  log_message "INFO" "$finding"
  log_message "INFO" "Why this matters: $why"
  [[ -n "$follow_up" ]] && log_message "INFO" "Review guidance: $follow_up"
}

lookup_gtfobin() {
  local binary_name="$1"
  local file="$DATA_DIR/gtfobins.txt"

  if [[ -f "$file" ]]; then
    grep -E "^${binary_name}:" "$file" 2>/dev/null | head -n 1 | cut -d':' -f2- | sed 's/^ //'
  fi
}

check_sudo() {
  if ! command -v sudo >/dev/null 2>&1; then
    print_finding "$TXT_PRIVESC_NO_SUDO" "$TXT_PRIVESC_NO_SUDO_WHY" ""
    return
  fi

  local output
  output="$(sudo -n -l 2>/dev/null)"

  if [[ -z "$output" ]]; then
    print_finding "$TXT_PRIVESC_SUDO_DENIED" "$TXT_PRIVESC_SUDO_DENIED_WHY" "$TXT_PRIVESC_SUDO_DENIED_GUIDANCE"
    return
  fi

  print_finding "$TXT_PRIVESC_SUDO_FOUND" "$TXT_PRIVESC_SUDO_FOUND_WHY" "$TXT_PRIVESC_SUDO_FOUND_GUIDANCE"
  append_report "WARNING" "$TXT_PRIVESC_SUDO_REPORT"
  register_finding "MEDIUM" "$TXT_PRIVESC_SUDO_REPORT"
  if ! quick_enabled; then
    while IFS= read -r line; do
      [[ -n "$line" ]] && echo "    $line"
    done <<< "$output"
    echo
  fi
}

check_suid() {
  local suid_file
  local found_any=0

  while IFS= read -r suid_file; do
    [[ -z "$suid_file" ]] && continue
    found_any=1
    local binary_name
    local exploit
    binary_name="$(basename "$suid_file")"
    exploit="$(lookup_gtfobin "$binary_name")"

    if [[ -n "$exploit" ]]; then
      print_finding "$TXT_PRIVESC_SUID_FOUND: $binary_name ($suid_file)" "$TXT_PRIVESC_SUID_WHY_A" "$TXT_PRIVESC_SUID_REF: $binary_name"
    else
      print_finding "$TXT_PRIVESC_SUID_FOUND: $binary_name ($suid_file)" "$TXT_PRIVESC_SUID_WHY_B" "$TXT_PRIVESC_SUID_SEARCH: $binary_name"
    fi
    append_report "WARNING" "$TXT_PRIVESC_SUID_FOUND: $binary_name ($suid_file)"
    register_finding "MEDIUM" "$TXT_PRIVESC_SUID_FOUND: $binary_name ($suid_file)"
  done < <(find /etc /usr /opt /home /var -perm -4000 -type f 2>/dev/null | sort)

  if [[ "$found_any" -eq 0 ]]; then
    print_finding "$TXT_PRIVESC_NO_SUID" "$TXT_PRIVESC_NO_SUID_WHY" ""
  fi
}

check_writable_path_dirs() {
  local dir
  local found_any=0

  IFS=':' read -r -a path_dirs <<< "$PATH"
  for dir in "${path_dirs[@]}"; do
    [[ -z "$dir" ]] && continue
    if [[ -d "$dir" && -w "$dir" ]]; then
      found_any=1
      print_finding "$TXT_PRIVESC_PATH_FOUND: $dir" "$TXT_PRIVESC_PATH_WHY" "$TXT_PRIVESC_PATH_GUIDANCE"
      append_report "WARNING" "$TXT_PRIVESC_PATH_FOUND: $dir"
      register_finding "HIGH" "$TXT_PRIVESC_PATH_FOUND: $dir"
    fi
  done

  if [[ "$found_any" -eq 0 ]]; then
    print_finding "$TXT_PRIVESC_NO_PATH" "$TXT_PRIVESC_NO_PATH_WHY" ""
  fi
}

main() {
  ensure_runtime
  register_module "privesc"
  print_header "$TXT_PRIVESC_HEADER"
  if ! quick_enabled; then
    print_step "$TXT_PRIVESC_STEP_SUDO"
  fi
  check_sudo
  if ! quick_enabled; then
    print_step "$TXT_PRIVESC_STEP_SUID"
  fi
  check_suid
  if ! quick_enabled; then
    print_step "$TXT_PRIVESC_STEP_PATH"
  fi
  check_writable_path_dirs
}

run_module() {
  main
}
