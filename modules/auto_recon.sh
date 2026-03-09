#!/bin/bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UTILS_DIR="$BASE_DIR/utils"
MODULES_DIR="$BASE_DIR/modules"

if [[ -f "$UTILS_DIR/common.sh" ]]; then
  source "$UTILS_DIR/common.sh"
elif [[ -f "$UTILS_DIR/colors.sh" ]]; then
  source "$UTILS_DIR/colors.sh"
fi

load_current_language

run_safe_module() {
  local script_name="$1"
  local friendly_name="$2"
  local failure_message="$3"
  local module_path="$MODULES_DIR/$script_name"

  if ! quick_enabled; then
    print_step "$friendly_name"
  fi

  unset -f run_module 2>/dev/null || true
  source "$module_path"
  if ! declare -F run_module >/dev/null 2>&1; then
    print_error "$failure_message"
    append_report "ERROR" "$failure_message"
    return
  fi

  if ! run_module; then
    print_error "$failure_message"
    append_report "ERROR" "$failure_message"
  fi
}

main() {
  ensure_runtime
  register_module "auto_recon"
  print_header "$TXT_AUTO_HEADER"
  print_warning "$TXT_AUTO_WARNING"
  log_message "INFO" "Auto Recon started"

  run_safe_module "enum.sh" "$TXT_AUTO_RUN_ENUM" "$TXT_AUTO_FAIL_ENUM"
  run_safe_module "privesc.sh" "$TXT_AUTO_RUN_PRIVESC" "$TXT_AUTO_FAIL_PRIVESC"
  run_safe_module "cron.sh" "$TXT_AUTO_RUN_CRON" "$TXT_AUTO_FAIL_CRON"
  run_safe_module "perms.sh" "$TXT_AUTO_RUN_PERMS" "$TXT_AUTO_FAIL_PERMS"
  run_safe_module "services.sh" "$TXT_AUTO_RUN_SERVICES" "$TXT_AUTO_FAIL_SERVICES"

  print_header "$TXT_AUTO_SUMMARY_HEADER"
  print_info "$TXT_AUTO_SUMMARY_DONE"
  print_info "$TXT_AUTO_SUMMARY_REPORT"
  append_report "INFO" "$TXT_AUTO_REPORT"
}

run_module() {
  main
}
