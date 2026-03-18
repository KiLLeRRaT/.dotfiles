#!/bin/bash
set -euo pipefail

output_dir="$HOME/Pictures/screenshots"
mkdir -p "$output_dir"

region="$(slurp)"
output_file="$output_dir/$(date +%Y-%m-%d_%H-%M-%S).png"

grim -g "$region" "$output_file"
wl-copy < "$output_file"
notify-send "Screenshot saved" "$output_file"
