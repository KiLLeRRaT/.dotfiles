#!/bin/bash
set -euo pipefail

image="$(find "$HOME/.dotfiles/images" -maxdepth 1 -type f | shuf -n 1)"

if [[ -z "${image}" ]]; then
  exit 0
fi

exec swaymsg output '*' bg "$image" fill
