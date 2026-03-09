#!/bin/bash

generate_report() {
  local report_date
  local report_path
  local index

  mkdir -p "$REPORTS_DIR"
  report_date="$(date +%d-%m-%Y)"
  report_path="$REPORTS_DIR/kr1pt0n_${report_date}.md"
  KR1PT0N_MARKDOWN_REPORT="$report_path"
  export KR1PT0N_MARKDOWN_REPORT

  {
    echo "# Kr1pt0n Scan Report"
    echo
    echo "## Session"
    echo "- User: $(whoami 2>/dev/null || echo unknown)"
    echo "- Hostname: $(hostname 2>/dev/null || echo unknown)"
    echo "- Date: $(date +%d/%m/%Y)"
    echo
    echo "## Findings"
    if [[ "${#KR1PT0N_FINDINGS[@]}" -eq 0 ]]; then
      echo "- No findings recorded"
    else
      for ((index=0; index<${#KR1PT0N_FINDINGS[@]}; index++)); do
        echo "- [${KR1PT0N_SEVERITY[$index]}] ${KR1PT0N_FINDINGS[$index]}"
      done
    fi
  } > "$report_path"
}
