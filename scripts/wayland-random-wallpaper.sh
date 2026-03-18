#!/bin/bash
set -euo pipefail

cd "$HOME"

current_wallpaper_link="${XDG_CACHE_HOME:-$HOME/.cache}/current-wallpaper"

mapfile -t images < <(
  find "$HOME/.dotfiles/images" -maxdepth 1 -type f | sort
)

if [[ "${#images[@]}" -eq 0 ]]; then
  exit 0
fi

image="$(printf '%s\n' "${images[@]}" | shuf -n 1)"

if [[ -z "${image}" ]]; then
  exit 0
fi

mkdir -p "$(dirname "$current_wallpaper_link")"
ln -sfn "$image" "$current_wallpaper_link"

exec swaymsg output '*' bg "$image" fill
