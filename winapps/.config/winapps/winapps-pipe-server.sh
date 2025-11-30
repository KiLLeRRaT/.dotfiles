#!/bin/bash

# This script continuously feeds the winapps.conf named pipe
# with secrets injected by 1Password.

# Get the directory of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
FIFO_PATH="$DIR/winapps.conf"
TEMPLATE_PATH="$DIR/winapps.conf.base"

# Cleanup the FIFO on exit
trap 'rm -f "$FIFO_PATH"' EXIT

# Exit if op CLI is not available
if ! command -v op &> /dev/null
then
    echo "1Password CLI 'op' could not be found. Please install it." >&2
    exit 1
fi

# Create the FIFO if it doesn't exist
if [ ! -p "$FIFO_PATH" ]; then
    echo "Creating named pipe at $FIFO_PATH"
    mkfifo -m 600 "$FIFO_PATH"
fi

echo "Starting to serve winapps.conf from winapps.conf.base via 1Password..."
echo "To stop, kill this script."

# Loop forever to serve the config
while true; do
  # op inject will read the template and output the config with secrets
  # The output is redirected to the FIFO, where it can be read by winapps
  if ! op inject -i "$TEMPLATE_PATH" > "$FIFO_PATH"; then
    echo "op inject command failed. Retrying in 5 seconds..." >&2
    sleep 5
  fi
done
