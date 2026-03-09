#!/bin/bash

show_animated_intro() {
  local skip_animation="${KR1PT0N_NO_ANIMATION:-0}"
  local lines
  local line

  if [[ "$skip_animation" -eq 1 ]]; then
    return
  fi

  lines=(
    "Initializing Kr1pt0n framework..."
    "Loading audit modules..."
    "Preparing enumeration engine..."
  )

  for line in "${lines[@]}"; do
    echo -ne "${BLUE}[>]${RESET} "
    while IFS= read -r -n1 char; do
      [[ -z "$char" ]] && continue
      printf '%s' "$char"
      sleep 0.01
    done <<< "$line"
    echo
    sleep 0.08
  done

  echo
}
