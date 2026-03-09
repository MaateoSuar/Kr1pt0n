#!/bin/bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
UTILS_DIR="$BASE_DIR/utils"
LOG_DIR="$BASE_DIR/logs"
REPORTS_DIR="$BASE_DIR/reports"
LANG_DIR="$BASE_DIR/lang"
CORE_DIR="$BASE_DIR/core"

if [[ -f "$UTILS_DIR/colors.sh" ]]; then
  source "$UTILS_DIR/colors.sh"
fi

if [[ -f "$CORE_DIR/findings.sh" ]]; then
  source "$CORE_DIR/findings.sh"
fi

if [[ -f "$CORE_DIR/output.sh" ]]; then
  source "$CORE_DIR/output.sh"
fi

if [[ -f "$CORE_DIR/report.sh" ]]; then
  source "$CORE_DIR/report.sh"
fi

RED="${RED:-}"
GREEN="${GREEN:-}"
YELLOW="${YELLOW:-}"
BLUE="${BLUE:-}"
CYAN="${CYAN:-}"
BOLD="${BOLD:-}"
RESET="${RESET:-}"

KR1PT0N_QUICK="${KR1PT0N_QUICK:-0}"
KR1PT0N_FINDINGS_FILE="${KR1PT0N_FINDINGS_FILE:-}"
KR1PT0N_MODULES_FILE="${KR1PT0N_MODULES_FILE:-}"
KR1PT0N_MARKDOWN_REPORT="${KR1PT0N_MARKDOWN_REPORT:-}"
KR1PT0N_JSON_REPORT="${KR1PT0N_JSON_REPORT:-}"
KR1PT0N_HIGH_COUNT="${KR1PT0N_HIGH_COUNT:-0}"
KR1PT0N_MEDIUM_COUNT="${KR1PT0N_MEDIUM_COUNT:-0}"
KR1PT0N_LOW_COUNT="${KR1PT0N_LOW_COUNT:-0}"

current_date_human() {
  date +%d/%m/%Y
}

current_date_file() {
  date +%d-%m-%Y
}

load_current_language() {
  local lang_code="${APP_LANG:-en}"
  local lang_file="$LANG_DIR/${lang_code}.sh"

  if [[ ! -f "$lang_file" ]]; then
    lang_file="$LANG_DIR/en.sh"
  fi

  source "$lang_file"
}

ensure_runtime() {
  mkdir -p "$LOG_DIR" "$REPORTS_DIR"

  if [[ -z "${KR1PT0N_SESSION_ID:-}" ]]; then
    KR1PT0N_SESSION_ID="$(date +%Y-%m-%d_%H-%M-%S)"
    export KR1PT0N_SESSION_ID
  fi

  if [[ -z "${KR1PT0N_LOGFILE:-}" ]]; then
    KR1PT0N_LOGFILE="$LOG_DIR/kr1pt0n_${KR1PT0N_SESSION_ID}.log"
    export KR1PT0N_LOGFILE
  fi

  if [[ -z "${KR1PT0N_REPORT_FILE:-}" ]]; then
    KR1PT0N_REPORT_FILE="$LOG_DIR/kr1pt0n_${KR1PT0N_SESSION_ID}.report"
    export KR1PT0N_REPORT_FILE
  fi

  if [[ -z "${KR1PT0N_FINDINGS_FILE:-}" ]]; then
    KR1PT0N_FINDINGS_FILE="$LOG_DIR/kr1pt0n_${KR1PT0N_SESSION_ID}.findings"
    export KR1PT0N_FINDINGS_FILE
  fi

  if [[ -z "${KR1PT0N_MODULES_FILE:-}" ]]; then
    KR1PT0N_MODULES_FILE="$LOG_DIR/kr1pt0n_${KR1PT0N_SESSION_ID}.modules"
    export KR1PT0N_MODULES_FILE
  fi

  if [[ -z "${KR1PT0N_MARKDOWN_REPORT:-}" ]]; then
    KR1PT0N_MARKDOWN_REPORT="$REPORTS_DIR/kr1pt0n_$(current_date_file).md"
    export KR1PT0N_MARKDOWN_REPORT
  fi

  if [[ -z "${KR1PT0N_JSON_REPORT:-}" ]]; then
    KR1PT0N_JSON_REPORT="$REPORTS_DIR/kr1pt0n_$(current_date_file).json"
    export KR1PT0N_JSON_REPORT
  fi

  export KR1PT0N_QUICK
  export KR1PT0N_HIGH_COUNT
  export KR1PT0N_MEDIUM_COUNT
  export KR1PT0N_LOW_COUNT

  touch "$KR1PT0N_LOGFILE" "$KR1PT0N_REPORT_FILE" "$KR1PT0N_FINDINGS_FILE" "$KR1PT0N_MODULES_FILE"
}

log_message() {
  local level="$1"
  local message="$2"
  ensure_runtime
  printf '[%s] [%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$level" "$message" >> "$KR1PT0N_LOGFILE"
}

append_report() {
  local category="$1"
  local message="$2"
  ensure_runtime
  printf '%s|%s\n' "$category" "$message" >> "$KR1PT0N_REPORT_FILE"
}

register_module() {
  local module_name="$1"
  ensure_runtime
  register_module_run "$module_name"
}

register_finding() {
  local severity="$1"
  local message="$2"
  ensure_runtime
  add_finding "$severity" "$message"
}

json_escape() {
  local value="$1"
  value="${value//\\/\\\\}"
  value="${value//\"/\\\"}"
  value="${value//$'\n'/\\n}"
  value="${value//$'\r'/}"
  printf '%s' "$value"
}

risk_score_total() {
  local high_count medium_count low_count
  ensure_runtime
  high_count=$(grep -c '^HIGH|' "$KR1PT0N_FINDINGS_FILE" 2>/dev/null || echo 0)
  medium_count=$(grep -c '^MEDIUM|' "$KR1PT0N_FINDINGS_FILE" 2>/dev/null || echo 0)
  low_count=$(grep -c '^LOW|' "$KR1PT0N_FINDINGS_FILE" 2>/dev/null || echo 0)
  echo $((high_count * 3 + medium_count * 2 + low_count))
}

risk_summary_text() {
  local total
  total="$(risk_score_total)"
  echo "Kr1pt0n Risk Score: ${total}/10"
}

generate_markdown_report() {
  ensure_runtime
  generate_report
}

generate_json_report() {
  ensure_runtime

  {
    echo "{"
    echo "  \"session\": {"
    echo "    \"user\": \"$(json_escape "$(whoami 2>/dev/null || echo unknown)")\"," 
    echo "    \"hostname\": \"$(json_escape "$(hostname 2>/dev/null || echo unknown)")\"," 
    echo "    \"date\": \"$(current_date_human)\""
    echo "  },"
    echo "  \"modules_run\": ["
    if [[ -s "$KR1PT0N_MODULES_FILE" ]]; then
      local first_module=1
      local module_name
      while IFS= read -r module_name; do
        [[ -z "$module_name" ]] && continue
        if [[ "$first_module" -eq 0 ]]; then
          echo ","
        fi
        printf '    "%s"' "$(json_escape "$module_name")"
        first_module=0
      done < "$KR1PT0N_MODULES_FILE"
      echo
    fi
    echo "  ],"
    echo "  \"findings\": ["
    if [[ -s "$KR1PT0N_FINDINGS_FILE" ]]; then
      local first_finding=1
      local severity message
      while IFS='|' read -r severity message; do
        [[ -z "$message" ]] && continue
        if [[ "$first_finding" -eq 0 ]]; then
          echo ","
        fi
        printf '    {"severity": "%s", "message": "%s"}' "$(json_escape "$severity")" "$(json_escape "$message")"
        first_finding=0
      done < "$KR1PT0N_FINDINGS_FILE"
      echo
    fi
    echo "  ],"
    echo "  \"risk_summary\": \"$(json_escape "$(risk_summary_text)")\""
    echo "}"
  } > "$KR1PT0N_JSON_REPORT"
}

quick_enabled() {
  [[ "${KR1PT0N_QUICK:-0}" -eq 1 ]]
}

show_log_location() {
  ensure_runtime
  echo
  echo -e "${BLUE}Log saved to:${RESET} $KR1PT0N_LOGFILE"
  echo -e "${BLUE}Markdown report:${RESET} $KR1PT0N_MARKDOWN_REPORT"
  echo -e "${BLUE}JSON report:${RESET} $KR1PT0N_JSON_REPORT"
}

show_report_summary() {
  ensure_runtime
  print_header "Final Report"

  if [[ ! -s "$KR1PT0N_REPORT_FILE" ]]; then
    print_warning "No findings were recorded in this session."
    return
  fi

  local category
  local message
  while IFS='|' read -r category message; do
    case "$category" in
      INFO)
        print_info "$message"
        ;;
      WARNING)
        print_warning "$message"
        ;;
      ERROR)
        print_error "$message"
        ;;
      *)
        echo "    $message"
        ;;
    esac
  done < "$KR1PT0N_REPORT_FILE"

  if [[ -s "$KR1PT0N_FINDINGS_FILE" ]]; then
    echo
    print_header "Risk Summary"
    print_warning "$(risk_summary_text)"
  fi
}
