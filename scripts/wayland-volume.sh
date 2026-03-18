#!/bin/sh

set -eu

action="${1:-}"
if [ -z "$action" ]; then
  printf 'usage: wayland-volume.sh up|down|mute-toggle|mic-toggle\n' >&2
  exit 1
fi
sink="@DEFAULT_SINK@"
source_dev="@DEFAULT_SOURCE@"
sink_tag="wayland-volume"
source_tag="wayland-microphone"

get_percent() {
  pactl "$1" "$2" | awk -F'/' 'NR == 1 { gsub(/ /, "", $2); gsub(/%/, "", $2); print $2; exit }'
}

get_mute() {
  pactl "$1" "$2" | awk '{ print $2 }'
}

clamp_percent() {
  value="$1"
  if [ "$value" -lt 0 ]; then
    printf '0\n'
  elif [ "$value" -gt 100 ]; then
    printf '100\n'
  else
    printf '%s\n' "$value"
  fi
}

notify_sink() {
  volume="$(get_percent get-sink-volume "$sink")"
  muted="$(get_mute get-sink-mute "$sink")"

  if [ "$muted" = "yes" ]; then
    dunstify \
      -a "set-volume" \
      -u low \
      -h string:x-dunst-stack-tag:"$sink_tag" \
      "Volume muted"
    return
  fi

  dunstify \
    -a "set-volume" \
    -u low \
    -h string:x-dunst-stack-tag:"$sink_tag" \
    -h int:value:"$volume" \
    "Volume: ${volume}%"
}

notify_source() {
  muted="$(get_mute get-source-mute "$source_dev")"

  if [ "$muted" = "yes" ]; then
    dunstify \
      -a "set-volume" \
      -u low \
      -h string:x-dunst-stack-tag:"$source_tag" \
      "Microphone muted"
    return
  fi

  volume="$(get_percent get-source-volume "$source_dev")"
  dunstify \
    -a "set-volume" \
    -u low \
    -h string:x-dunst-stack-tag:"$source_tag" \
    -h int:value:"$volume" \
    "Microphone: ${volume}%"
}

case "$action" in
  up)
    current="$(get_percent get-sink-volume "$sink")"
    if [ "$current" -ge 100 ]; then
      target=100
    else
      target="$(clamp_percent $((current + 5)))"
    fi
    pactl set-sink-mute "$sink" 0
    pactl set-sink-volume "$sink" "${target}%"
    notify_sink
    ;;
  down)
    current="$(get_percent get-sink-volume "$sink")"
    if [ "$current" -gt 100 ]; then
      target=100
    else
      target="$(clamp_percent $((current - 5)))"
    fi
    pactl set-sink-mute "$sink" 0
    pactl set-sink-volume "$sink" "${target}%"
    notify_sink
    ;;
  mute-toggle)
    pactl set-sink-mute "$sink" toggle
    notify_sink
    ;;
  mic-toggle)
    pactl set-source-mute "$source_dev" toggle
    notify_source
    ;;
  *)
    printf 'Unknown action: %s\n' "$action" >&2
    exit 1
    ;;
esac
