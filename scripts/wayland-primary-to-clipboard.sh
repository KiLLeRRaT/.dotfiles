#!/bin/bash
set -euo pipefail

data="$(wl-paste --primary -n 2>/dev/null || true)"

if [[ -z "${data}" ]]; then
  notify-send "Primary selection unavailable" "Nothing was copied to the clipboard."
  exit 1
fi

printf '%s' "$data" | wl-copy
notify-send "Clipboard updated" "Primary selection copied to the clipboard."
