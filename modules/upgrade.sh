#!/bin/bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UTILS_DIR="$BASE_DIR/utils"

if [[ -f "$UTILS_DIR/common.sh" ]]; then
  source "$UTILS_DIR/common.sh"
elif [[ -f "$UTILS_DIR/colors.sh" ]]; then
  source "$UTILS_DIR/colors.sh"
fi

load_current_language

GREEN="${GREEN:-}"
YELLOW="${YELLOW:-}"
CYAN="${CYAN:-}"
BOLD="${BOLD:-}"
RESET="${RESET:-}"

print_technique() {
  local title="$1"
  local command="$2"
  local explanation="$3"

  print_info "$title"
  echo "    ${TXT_UPGRADE_COMMAND_LABEL} $command"
  echo -e "${YELLOW}    ${TXT_UPGRADE_WHAT_IT_DOES}${RESET} ${explanation}"
  echo
  log_message "INFO" "Upgrade guidance shown: $title"
}

main() {
  ensure_runtime
  register_module "upgrade"
  print_header "$TXT_UPGRADE_HEADER"
  print_technique "$TXT_UPGRADE_PYTHON_TITLE" "python3 -c 'import pty; pty.spawn(\"/bin/bash\")'" "$TXT_UPGRADE_PYTHON_EXPLAIN"
  print_technique "$TXT_UPGRADE_TERM_TITLE" "export TERM=xterm" "$TXT_UPGRADE_TERM_EXPLAIN"
  print_technique "$TXT_UPGRADE_STTY_TITLE" "stty raw -echo" "$TXT_UPGRADE_STTY_EXPLAIN"
  print_technique "$TXT_UPGRADE_FG_TITLE" "fg" "$TXT_UPGRADE_FG_EXPLAIN"
  print_technique "$TXT_UPGRADE_RESIZE_TITLE" "stty rows <ROWS> columns <COLS>" "$TXT_UPGRADE_RESIZE_EXPLAIN"
  append_report "INFO" "$TXT_UPGRADE_REPORT"
}

run_module() {
  main
}
