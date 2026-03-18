#!/bin/bash
set -euo pipefail

workspace='10:0 󰃭'
url="${1:-$(wl-paste -n)}"

if [[ -z "${url}" ]]; then
  notify-send "Clipboard is empty" "Nothing to open."
  exit 1
fi

swaymsg workspace "$workspace" > /dev/null
brave --new-window --profile-directory="Profile 1" "$url" > /dev/null 2>&1 &
