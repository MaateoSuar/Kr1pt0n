#!/bin/bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES_DIR="$BASE_DIR/modules"
UTILS_DIR="$BASE_DIR/utils"
LANG_DIR="$BASE_DIR/lang"
CONFIG_FILE="$BASE_DIR/.config"

if [[ -f "$UTILS_DIR/colors.sh" ]]; then
  source "$UTILS_DIR/colors.sh"
fi

if [[ -f "$UTILS_DIR/common.sh" ]]; then
  source "$UTILS_DIR/common.sh"
fi

if [[ -f "$UTILS_DIR/banner.sh" ]]; then
  source "$UTILS_DIR/banner.sh"
fi

RED="${RED:-}"
GREEN="${GREEN:-}"
BLUE="${BLUE:-}"
YELLOW="${YELLOW:-}"
CYAN="${CYAN:-}"
BOLD="${BOLD:-}"
RESET="${RESET:-}"

APP_LANG="${APP_LANG:-}"
KR1PT0N_QUICK="${KR1PT0N_QUICK:-0}"
KR1PT0N_NO_ANIMATION="${KR1PT0N_NO_ANIMATION:-0}"

REQUESTED_MODULE=""
REQUESTED_ACTION="menu"
REQUESTED_ACTION_ARG=""

set_quick_mode() {
  KR1PT0N_QUICK="$1"
  export KR1PT0N_QUICK
}

resolve_module_script() {
  local module_key="$1"

  case "$module_key" in
    enum)
      echo "enum.sh"
      ;;
    privesc)
      echo "privesc.sh"
      ;;
    reverse)
      echo "reverse.sh"
      ;;
    upgrade)
      echo "upgrade.sh"
      ;;
    auto)
      echo "auto_recon.sh"
      ;;
    cron)
      echo "cron.sh"
      ;;
    perms)
      echo "perms.sh"
      ;;
    services)
      echo "services.sh"
      ;;
    *)
      return 1
      ;;
  esac
}

parse_args() {
  set_quick_mode 0

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --quick)
        set_quick_mode 1
        shift
        ;;
      --no-animation)
        KR1PT0N_NO_ANIMATION=1
        export KR1PT0N_NO_ANIMATION
        shift
        ;;
      --module)
        if [[ -z "${2:-}" ]]; then
          print_error "Missing module name for --module"
          exit 1
        fi
        REQUESTED_ACTION="module"
        REQUESTED_MODULE="$2"
        shift 2
        ;;
      --help)
        REQUESTED_ACTION="help"
        if [[ -n "${2:-}" && "${2:0:2}" != "--" ]]; then
          REQUESTED_ACTION_ARG="$2"
          shift 2
        else
          REQUESTED_ACTION_ARG=""
          shift
        fi
        ;;
      --menu)
        REQUESTED_ACTION="menu"
        shift
        ;;
      --enum)
        REQUESTED_ACTION="module"
        REQUESTED_MODULE="enum"
        shift
        ;;
      --privesc)
        REQUESTED_ACTION="module"
        REQUESTED_MODULE="privesc"
        shift
        ;;
      --reverse)
        REQUESTED_ACTION="module"
        REQUESTED_MODULE="reverse"
        shift
        ;;
      --upgrade)
        REQUESTED_ACTION="module"
        REQUESTED_MODULE="upgrade"
        shift
        ;;
      --auto)
        REQUESTED_ACTION="module"
        REQUESTED_MODULE="auto"
        shift
        ;;
      --lang)
        if [[ -z "${2:-}" ]]; then
          print_error "Missing language code for --lang"
          exit 1
        fi
        REQUESTED_ACTION="lang"
        REQUESTED_ACTION_ARG="${2:-}"
        shift 2
        ;;
      --creds)
        REQUESTED_ACTION="creds"
        shift
        ;;
      --transfer)
        REQUESTED_ACTION="transfer"
        shift
        ;;
      --learn)
        if [[ -z "${2:-}" ]]; then
          print_error "Missing topic for --learn"
          exit 1
        fi
        REQUESTED_ACTION="learn"
        REQUESTED_ACTION_ARG="${2:-}"
        shift 2
        ;;
      --hint)
        if [[ -z "${2:-}" ]]; then
          print_error "Missing topic for --hint"
          exit 1
        fi
        REQUESTED_ACTION="hint"
        REQUESTED_ACTION_ARG="${2:-}"
        shift 2
        ;;
      *)
        REQUESTED_ACTION="menu"
        shift
        ;;
    esac
  done
}

finalize_session() {
  ensure_runtime
  generate_markdown_report
  generate_json_report
}

save_language_config() {
  local lang_code="$1"
  printf 'LANG=%s\n' "$lang_code" > "$CONFIG_FILE"
}

load_language_file() {
  local lang_code="$1"
  local lang_file="$LANG_DIR/${lang_code}.sh"

  if [[ ! -f "$lang_file" ]]; then
    lang_file="$LANG_DIR/en.sh"
    lang_code="en"
  fi

  source "$lang_file"
  APP_LANG="$lang_code"
  export APP_LANG
}

prompt_for_language() {
  local language_choice

  echo "$LANGUAGE_SELECT_TITLE"
  echo "$LANGUAGE_OPTION_EN"
  echo "$LANGUAGE_OPTION_ES"
  read -r -p "$LANGUAGE_PROMPT" language_choice

  case "$language_choice" in
    2)
      save_language_config "es"
      load_language_file "es"
      echo "$LANGUAGE_SAVED_ES"
      ;;
    1|*)
      if [[ "$language_choice" != "1" && -n "$language_choice" ]]; then
        echo "$LANGUAGE_INVALID"
      fi
      save_language_config "en"
      load_language_file "en"
      echo "$LANGUAGE_SAVED_EN"
      ;;
  esac
}

initialize_language() {
  local configured_lang=""
  local interactive_prompt="${1:-no_prompt}"

  if [[ -z "$APP_LANG" && -f "$CONFIG_FILE" ]]; then
    configured_lang="$(grep '^LANG=' "$CONFIG_FILE" 2>/dev/null | cut -d'=' -f2)"
    APP_LANG="$configured_lang"
  fi

  if [[ -z "$APP_LANG" ]]; then
    load_language_file "en"
    if [[ "$interactive_prompt" == "prompt" ]]; then
      prompt_for_language
    fi
  else
    load_language_file "$APP_LANG"
  fi
}

set_language() {
  local lang_code="$1"

  case "$lang_code" in
    en|es)
      save_language_config "$lang_code"
      load_language_file "$lang_code"
      echo "$LANGUAGE_CHANGED_PREFIX $lang_code"
      ;;
    *)
      echo "$LANGUAGE_UNSUPPORTED"
      return 1
      ;;
  esac
}

load_language_file "en"

show_tool_intro() {
  echo "$TOOL_INTRO_TITLE"
  echo "$TOOL_INTRO_SUBTITLE"
  echo
}

show_general_help() {
  show_tool_intro
  echo "$HELP_GENERAL"
}

show_module_help() {
  local module="$1"

  show_tool_intro

  case "$module" in
    enum)
      echo "$HELP_ENUM"
      ;;
    privesc)
      echo "$HELP_PRIVESC"
      ;;
    cron)
      echo "$HELP_CRON"
      ;;
    perms)
      echo "$HELP_PERMS"
      ;;
    services)
      echo "$HELP_SERVICES"
      ;;
    reverse)
      echo "$HELP_REVERSE"
      ;;
    upgrade|tty)
      echo "$HELP_UPGRADE"
      ;;
    auto)
      echo "$HELP_AUTO"
      ;;
    creds)
      echo "$HELP_CREDS"
      ;;
    transfer)
      echo "$HELP_TRANSFER"
      ;;
    *)
      print_warning "$HELP_UNAVAILABLE"
      ;;
  esac
}

run_direct_module() {
  local module_name="$1"
  local module_path="$MODULES_DIR/$module_name"

  ensure_runtime
  register_module "${module_name%.sh}"

  if [[ ! -f "$module_path" ]]; then
    print_error "$MODULE_NOT_AVAILABLE $module_name"
    log_message "ERROR" "Requested unavailable module: $module_name"
    return 1
  fi

  log_message "INFO" "Running direct module: $module_name"
  unset -f run_module 2>/dev/null || true
  source "$module_path"
  if ! declare -F run_module >/dev/null 2>&1; then
    print_error "Module entrypoint run_module() not found: $module_name"
    log_message "ERROR" "Module entrypoint run_module() not found: $module_name"
    return 1
  fi
  run_module
}

show_learning_mode() {
  local topic="$1"

  clear
  print_header "Learning Mode"

  case "$topic" in
    suid)
      print_info "SUID means Set User ID."
      echo "    It lets a binary run with the file owner's privileges instead of the current user's privileges."
      echo
      print_warning "Why it can be dangerous"
      echo "    If a SUID binary exposes shell execution or unsafe features, it may let a local user act with elevated rights."
      echo
      print_info "How defenders and pentesters look for it"
      echo "    Use: find / -perm -4000 -type f 2>/dev/null"
      echo
      print_info "What to study next"
      echo "    Review the binary purpose, its permissions, and public GTFOBins references for defensive understanding."
      ;;
    sudo)
      print_info "sudo allows controlled privilege delegation."
      echo "    Misconfigured sudo rules may expose commands that should not be delegated to low-privileged users."
      echo
      print_info "Typical review step"
      echo "    Use: sudo -l"
      ;;
    reverse-shell)
      print_info "A reverse shell is a connection initiated from the target back to an operator-controlled host."
      echo "    In security training and incident response, the concept is important because it explains how remote command channels can be established."
      echo
      print_info "Why defenders study it"
      echo "    It helps defenders recognize suspicious outbound connections, shell spawns, and unusual child processes."
      ;;
    tty)
      print_info "A TTY is an interactive terminal session."
      echo "    Basic shells often lack job control, terminal resizing, and proper interactive behavior."
      echo
      print_info "Why shell stabilization matters"
      echo "    Better terminal behavior improves command-line usability and helps explain why some sessions behave differently from a normal login shell."
      ;;
    container)
      print_info "Containers isolate processes, but isolation may be weak if the runtime or configuration is unsafe."
      echo "    Review capabilities, mounts, and whether the container is privileged."
      ;;
    *)
      print_warning "$LEARN_UNSUPPORTED"
      ;;
  esac
}

show_hint_mode() {
  local topic="$1"

  clear
  print_header "CTF Hint Mode"

  case "$topic" in
    suid)
      echo "Hint: Some binaries may have special permissions."
      echo "Try searching for files that run with their owner's privileges."
      ;;
    sudo)
      echo "Hint: Your current user may have delegated privileges."
      echo "Try checking what commands can be run with elevated rights."
      ;;
    path)
      echo "Hint: Command lookup order matters."
      echo "Look for directories in PATH that should not be writable."
      ;;
    *)
      print_warning "$HINT_UNSUPPORTED"
      ;;
  esac
}

show_banner() {
  clear
  if declare -F show_animated_intro >/dev/null 2>&1; then
    show_animated_intro
  fi
  echo -e "${GREEN}${BOLD}██╗  ██╗ ██████╗     ██╗ ██████╗ ████████╗ ██████╗ ███╗   ██╗${RESET}"
  echo -e "${GREEN}██║ ██╔╝██╔══██╗   ███║██╔══██╗╚══██╔══╝██╔═████╗████╗  ██║${RESET}"
  echo -e "${CYAN}█████╔╝ ██████╔╝   ╚██║██████╔╝   ██║   ██║██╔██║██╔██╗ ██║${RESET}"
  echo -e "${GREEN}██╔═██╗ ██╔══██╗    ██║██╔═══╝    ██║   ████╔╝██║██║╚██╗██║${RESET}"
  echo -e "${YELLOW}██║  ██╗██║  ██║    ██║██║        ██║   ╚██████╔╝██║ ╚████║${RESET}"
  echo -e "${BLUE}╚═╝  ╚═╝╚═╝  ╚═╝    ╚═╝╚═╝        ╚═╝    ╚═════╝ ╚═╝  ╚═══╝${RESET}"
  echo
  echo -e "${CYAN}[ ${BOLD}${BANNER_TITLE}${RESET}${CYAN} ]${RESET} ${BLUE}v1.0.0${RESET}"
  echo -e "${YELLOW}${BANNER_WARNING}${RESET}"
  if [[ -n "${KR1PT0N_LOGFILE:-}" ]]; then
    echo -e "${BLUE}${BANNER_SESSION_LOG}${RESET} $KR1PT0N_LOGFILE"
  fi
  echo
}

run_module() {
  local module_name="$1"
  local module_path="$MODULES_DIR/$module_name"

  ensure_runtime
  register_module "${module_name%.sh}"

  if [[ ! -f "$module_path" ]]; then
    print_error "$MODULE_NOT_FOUND $module_name"
    log_message "ERROR" "Module not found: $module_name"
    read -r -p "$PROMPT_CONTINUE" _
    return
  fi

  log_message "INFO" "Running module: $module_name"
  unset -f run_module 2>/dev/null || true
  source "$module_path"
  if ! declare -F run_module >/dev/null 2>&1; then
    print_error "Module entrypoint run_module() not found: $module_name"
    log_message "ERROR" "Module entrypoint run_module() not found: $module_name"
    read -r -p "$PROMPT_CONTINUE" _
    return
  fi
  if ! run_module; then
    print_error "$MODULE_EXEC_FAILED $module_name"
    log_message "ERROR" "Module execution failed: $module_name"
  fi
  echo
  read -r -p "$PROMPT_CONTINUE" _
}

show_menu() {
  echo -e "${BLUE}----------------------------------------${RESET}"
  echo -e "${GREEN}1)${RESET} $MENU_OPTION_1"
  echo -e "${GREEN}2)${RESET} $MENU_OPTION_2"
  echo -e "${GREEN}3)${RESET} $MENU_OPTION_3"
  echo -e "${GREEN}4)${RESET} $MENU_OPTION_4"
  echo -e "${GREEN}5)${RESET} $MENU_OPTION_5"
  echo -e "${GREEN}6)${RESET} $MENU_OPTION_6"
  echo -e "${GREEN}7)${RESET} $MENU_OPTION_7"
  echo -e "${GREEN}8)${RESET} $MENU_OPTION_8"
  echo -e "${GREEN}9)${RESET} $MENU_OPTION_9"
  echo -e "${GREEN}0)${RESET} $MENU_OPTION_0"
  echo -e "${BLUE}----------------------------------------${RESET}"
  echo
}

initialize_session() {
  ensure_runtime
  : > "$KR1PT0N_REPORT_FILE"
  : > "$KR1PT0N_FINDINGS_FILE"
  : > "$KR1PT0N_MODULES_FILE"
  KR1PT0N_HIGH_COUNT=0
  KR1PT0N_MEDIUM_COUNT=0
  KR1PT0N_LOW_COUNT=0
  export KR1PT0N_HIGH_COUNT
  export KR1PT0N_MEDIUM_COUNT
  export KR1PT0N_LOW_COUNT
  log_message "INFO" "Kr1pt0n session initialized"
}

main() {
  initialize_language "prompt"
  initialize_session

  while true; do
    show_banner
    show_menu
    read -r -p "$MENU_PROMPT" option

    case "$option" in
      1)
        run_module "enum.sh"
        ;;
      2)
        run_module "privesc.sh"
        ;;
      3)
        run_module "cron.sh"
        ;;
      4)
        run_module "perms.sh"
        ;;
      5)
        run_module "services.sh"
        ;;
      6)
        run_module "reverse.sh"
        ;;
      7)
        run_module "upgrade.sh"
        ;;
      8)
        run_module "auto_recon.sh"
        ;;
      9)
        show_report_summary
        echo
        read -r -p "$PROMPT_CONTINUE" _
        ;;
      0)
        finalize_session
        show_log_location
        echo -e "${BLUE}${MENU_GOODBYE}${RESET}"
        exit 0
        ;;
      *)
        print_error "$MENU_INVALID"
        read -r -p "$PROMPT_CONTINUE" _
        ;;
    esac
  done
}

parse_args "$@"

case "$REQUESTED_ACTION" in
  help)
    initialize_language
    ensure_runtime
    if [[ -n "$REQUESTED_ACTION_ARG" ]]; then
      show_module_help "$REQUESTED_ACTION_ARG"
    else
      show_general_help
    fi
    ;;
  menu)
    main
    ;;
  module)
    initialize_language
    initialize_session
    module_script="$(resolve_module_script "$REQUESTED_MODULE")" || {
      print_error "Unsupported module: $REQUESTED_MODULE"
      exit 1
    }
    run_direct_module "$module_script"
    finalize_session
    ;;
  lang)
    load_language_file "en"
    set_language "$REQUESTED_ACTION_ARG"
    ;;
  creds)
    initialize_language
    ensure_runtime
    print_warning "$CREDS_RESERVED"
    ;;
  transfer)
    initialize_language
    ensure_runtime
    print_warning "$TRANSFER_RESERVED"
    ;;
  learn)
    initialize_language
    ensure_runtime
    show_learning_mode "$REQUESTED_ACTION_ARG"
    ;;
  hint)
    initialize_language
    ensure_runtime
    show_hint_mode "$REQUESTED_ACTION_ARG"
    ;;
  *)
    main
    ;;
esac
