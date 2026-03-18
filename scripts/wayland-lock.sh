#!/bin/bash
set -euo pipefail

exec swaylock -f \
  --color 1a1b26 \
  --font "SF Pro Display" \
  --font-size 24 \
  --indicator-radius 120 \
  --indicator-thickness 10 \
  --ring-color 7aa2f7 \
  --ring-clear-color e0af68 \
  --ring-ver-color 9ece6a \
  --ring-wrong-color f7768e \
  --inside-color 1a1b26dd \
  --inside-clear-color 1a1b26dd \
  --inside-ver-color 1a1b26dd \
  --inside-wrong-color 1a1b26dd \
  --line-color 00000000 \
  --separator-color 00000000 \
  --text-color a9b1d6 \
  --text-clear-color a9b1d6 \
  --text-ver-color 9ece6a \
  --text-wrong-color f7768e \
  --key-hl-color 9ece6a \
  --bs-hl-color e0af68 \
  --caps-lock-key-hl-color e0af68 \
  --caps-lock-bs-hl-color e0af68 \
  --indicator-caps-lock \
  --show-failed-attempts
