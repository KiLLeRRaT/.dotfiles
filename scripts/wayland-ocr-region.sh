#!/bin/bash
set -euo pipefail

region="$(slurp)"
grim -g "$region" - | tesseract stdin stdout | wl-copy
notify-send "OCR copied" "Recognized text was copied to the clipboard."
