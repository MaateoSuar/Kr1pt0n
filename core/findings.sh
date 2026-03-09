#!/bin/bash

declare -ag KR1PT0N_FINDINGS
declare -ag KR1PT0N_SEVERITY

declare -ag KR1PT0N_MODULES_RUN

declare -g KR1PT0N_FINDINGS_FILE="${KR1PT0N_FINDINGS_FILE:-}"

declare -g KR1PT0N_MODULES_FILE="${KR1PT0N_MODULES_FILE:-}"

add_finding() {
  local severity="$1"
  local message="$2"

  KR1PT0N_FINDINGS+=("$message")
  KR1PT0N_SEVERITY+=("$severity")

  if [[ -n "$KR1PT0N_FINDINGS_FILE" ]]; then
    printf '%s|%s\n' "$severity" "$message" >> "$KR1PT0N_FINDINGS_FILE"
  fi
}

register_module_run() {
  local module_name="$1"
  local entry

  for entry in "${KR1PT0N_MODULES_RUN[@]}"; do
    [[ "$entry" == "$module_name" ]] && return
  done

  KR1PT0N_MODULES_RUN+=("$module_name")

  if [[ -n "$KR1PT0N_MODULES_FILE" ]]; then
    printf '%s\n' "$module_name" >> "$KR1PT0N_MODULES_FILE"
  fi
}

reset_findings() {
  KR1PT0N_FINDINGS=()
  KR1PT0N_SEVERITY=()
  KR1PT0N_MODULES_RUN=()

  if [[ -n "$KR1PT0N_FINDINGS_FILE" ]]; then
    : > "$KR1PT0N_FINDINGS_FILE"
  fi

  if [[ -n "$KR1PT0N_MODULES_FILE" ]]; then
    : > "$KR1PT0N_MODULES_FILE"
  fi
}
