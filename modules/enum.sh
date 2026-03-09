#!/bin/bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UTILS_DIR="$BASE_DIR/utils"

if [[ -f "$UTILS_DIR/common.sh" ]]; then
  source "$UTILS_DIR/common.sh"
elif [[ -f "$UTILS_DIR/colors.sh" ]]; then
  source "$UTILS_DIR/colors.sh"
fi

load_current_language

RED="${RED:-}"
GREEN="${GREEN:-}"
YELLOW="${YELLOW:-}"
BLUE="${BLUE:-}"
CYAN="${CYAN:-}"
BOLD="${BOLD:-}"
RESET="${RESET:-}"

quick_enabled() {
  [[ "${KR1PT0N_QUICK:-0}" -eq 1 ]]
}

log_block() {
  local label="$1"
  local value="$2"
  log_message "INFO" "$label"
  while IFS= read -r line; do
    [[ -n "$line" ]] && log_message "INFO" "  $line"
  done <<< "$value"
}

get_os_version() {
  if [[ -r /etc/os-release ]]; then
    grep '^PRETTY_NAME=' /etc/os-release | cut -d'=' -f2- | tr -d '"'
  else
    uname -o 2>/dev/null || echo "Unknown"
  fi
}

get_sudo_permissions() {
  if ! command -v sudo >/dev/null 2>&1; then
    echo "sudo is not installed."
    return
  fi

  sudo -n -l 2>/dev/null || echo "Passwordless sudo rights not available or access denied."
}

get_suid_binaries() {
  find / -perm -4000 -type f 2>/dev/null | sort
}

get_capabilities() {
  if command -v getcap >/dev/null 2>&1; then
    getcap -r / 2>/dev/null | sort
  else
    echo "getcap is not installed."
  fi
}

detect_container() {
  if [[ -f /.dockerenv ]]; then
    echo "Docker container detected. Review capabilities, mounted sockets, and privileged mode for escape risk."
    return
  fi

  if grep -qa 'docker' /proc/1/cgroup 2>/dev/null; then
    echo "Docker-related cgroup markers detected. Review container boundaries."
    return
  fi

  if grep -qa 'lxc' /proc/1/cgroup 2>/dev/null; then
    echo "LXC container detected. Check namespace isolation and privileged configuration."
    return
  fi

  if [[ -n "${KUBERNETES_SERVICE_HOST:-}" ]] || grep -qa 'kubepods' /proc/1/cgroup 2>/dev/null; then
    echo "Kubernetes container context detected. Review service account exposure and mounted secrets."
    return
  fi

  echo "No common container markers detected."
}

assess_kernel_risk() {
  local kernel_version
  kernel_version="$(uname -r)"

  case "$kernel_version" in
    3.*|4.4.*|4.15.*)
      echo "Kernel ${kernel_version} is older and may require manual review for public local privilege escalation advisories."
      ;;
    5.4.*|5.10.*)
      echo "Kernel ${kernel_version} should be reviewed against current vendor patch status if this is an unmaintained system."
      ;;
    *)
      echo "No high-level kernel warning matched. Manual validation is still recommended."
      ;;
  esac
}

main() {
  ensure_runtime
  register_module "enum"
  print_header "$TXT_ENUM_HEADER"

  local current_user user_details os_version kernel_version sudo_permissions suid_binaries capabilities container_context kernel_warning

  if ! quick_enabled; then
    print_step "$TXT_ENUM_STEP_USER"
  fi
  current_user="$(whoami)"
  if ! quick_enabled; then
    print_value_block "$TXT_ENUM_USER_LABEL" "$current_user"
  else
    print_info "$TXT_ENUM_USER_LABEL: $current_user"
  fi
  log_block "Current user" "$current_user"
  append_report "INFO" "Current user: $current_user"

  if ! quick_enabled; then
    print_step "$TXT_ENUM_STEP_DETAILS"
  fi
  user_details="$(id)"
  if ! quick_enabled; then
    print_value_block "$TXT_ENUM_DETAILS_LABEL" "$user_details"
  fi
  log_block "User and group details" "$user_details"

  if ! quick_enabled; then
    print_step "$TXT_ENUM_STEP_OS"
  fi
  os_version="$(get_os_version)"
  if ! quick_enabled; then
    print_value_block "$TXT_ENUM_OS_LABEL" "$os_version"
  else
    print_info "$TXT_ENUM_OS_LABEL: $os_version"
  fi
  log_block "OS version" "$os_version"
  append_report "INFO" "OS version: $os_version"

  if ! quick_enabled; then
    print_step "$TXT_ENUM_STEP_KERNEL"
  fi
  kernel_version="$(uname -r)"
  if ! quick_enabled; then
    print_value_block "$TXT_ENUM_KERNEL_LABEL" "$kernel_version"
  else
    print_info "$TXT_ENUM_KERNEL_LABEL: $kernel_version"
  fi
  log_block "Kernel version" "$kernel_version"
  append_report "INFO" "Kernel version: $kernel_version"

  if ! quick_enabled; then
    print_step "$TXT_ENUM_STEP_CONTAINER"
  fi
  container_context="$(detect_container)"
  if ! quick_enabled; then
    print_value_block "$TXT_ENUM_CONTAINER_LABEL" "$container_context"
  fi
  log_block "Container detection" "$container_context"
  if [[ "$container_context" != "No common container markers detected." ]]; then
    print_warning "$container_context"
    append_report "WARNING" "$container_context"
    register_finding "MEDIUM" "$container_context"
  fi

  if ! quick_enabled; then
    print_step "$TXT_ENUM_STEP_KERNEL_WARN"
  fi
  kernel_warning="$(assess_kernel_risk)"
  if ! quick_enabled; then
    print_value_block "$TXT_ENUM_KERNEL_WARN_LABEL" "$kernel_warning"
  else
    print_warning "$kernel_warning"
  fi
  log_block "Kernel review warning" "$kernel_warning"
  append_report "WARNING" "$kernel_warning"
  register_finding "LOW" "$kernel_warning"

  if ! quick_enabled; then
    print_step "$TXT_ENUM_STEP_SUDO"
  fi
  sudo_permissions="$(get_sudo_permissions)"
  if ! quick_enabled; then
    print_value_block "$TXT_ENUM_SUDO_LABEL" "$sudo_permissions"
  fi
  log_block "Sudo permissions" "$sudo_permissions"
  if grep -qv "Passwordless sudo rights not available or access denied." <<< "$sudo_permissions" && grep -qv "sudo is not installed." <<< "$sudo_permissions"; then
    print_warning "$TXT_ENUM_SUDO_REVIEW"
    append_report "WARNING" "$TXT_ENUM_SUDO_REVIEW"
    register_finding "MEDIUM" "$TXT_ENUM_SUDO_REVIEW"
  fi

  if ! quick_enabled; then
    print_step "$TXT_ENUM_STEP_SUID"
  fi
  suid_binaries="$(get_suid_binaries)"
  if ! quick_enabled; then
    print_value_block "$TXT_ENUM_SUID_LABEL" "$suid_binaries"
  fi
  log_block "SUID binaries" "$suid_binaries"
  if [[ -n "$suid_binaries" ]]; then
    print_warning "$TXT_ENUM_SUID_REVIEW"
    append_report "WARNING" "$TXT_ENUM_SUID_REVIEW"
    register_finding "MEDIUM" "$TXT_ENUM_SUID_REVIEW"
  fi

  if ! quick_enabled; then
    print_step "$TXT_ENUM_STEP_CAPS"
  fi
  capabilities="$(get_capabilities)"
  if ! quick_enabled; then
    print_value_block "$TXT_ENUM_CAPS_LABEL" "$capabilities"
  fi
  log_block "File capabilities" "$capabilities"
  if [[ -n "$capabilities" && "$capabilities" != "getcap is not installed." ]]; then
    print_warning "$TXT_ENUM_CAPS_REVIEW"
    append_report "WARNING" "$TXT_ENUM_CAPS_REVIEW"
    register_finding "LOW" "$TXT_ENUM_CAPS_REVIEW"
  fi

  echo
  print_warning "$TXT_ENUM_DONE"
}

main
