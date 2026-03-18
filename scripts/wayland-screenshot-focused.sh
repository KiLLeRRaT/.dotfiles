#!/bin/bash
set -euo pipefail

output_dir="$HOME/Pictures/screenshots"
mkdir -p "$output_dir"

output_file="$output_dir/$(date +%Y-%m-%d_%H-%M-%S).png"
geometry="$(
  swaymsg -t get_tree | jq -r '
    recurse(.nodes[]?, .floating_nodes[]?)
    | select(.focused == true and (.type == "con" or .type == "floating_con"))
    | "\(.rect.x),\(.rect.y) \(.rect.width)x\(.rect.height)"
  ' | head -n 1
)"

if [[ -z "${geometry}" || "${geometry}" == "null" ]]; then
  notify-send "Screenshot failed" "Could not find the focused window geometry."
  exit 1
fi

grim -g "$geometry" "$output_file"
wl-copy < "$output_file"
notify-send "Screenshot saved" "$output_file"
