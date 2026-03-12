#!/usr/bin/env bash

# Set all d3cold_allowed under /sys/devices/ to 0
echo "Disabling d3cold_allowed for all devices..."
for f in $(find /sys/devices/ -name d3cold_allowed); do
  echo 0 | sudo tee "$f" > /dev/null
done

# Explicitly set specific Thunderbolt / NVMe devices individually as well
echo "Specific device also being configured individually..."
for device in \
  0000:01:00.0 \
  0000:1c:00.0 \
  0000:05:00.0 \
  0000:05:01.0 \
  0000:05:02.0 \
  0000:06:00.0
do
  if [ -e /sys/bus/pci/devices/$device/d3cold_allowed ]; then
	echo 0 | sudo tee /sys/bus/pci/devices/$device/d3cold_allowed > /dev/null
  fi
done

echo "d3cold configuration complete, can suspend."
