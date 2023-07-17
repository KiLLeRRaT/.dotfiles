#!/bin/bash

# Get current values
brightness_current=$(cat /sys/class/backlight/gmux_backlight/brightness)
brightness_max=$(cat /sys/class/backlight/gmux_backlight/max_brightness)
brightness_percent=$((100 * $brightness_current / $brightness_max))

echo "Current brightness is $brightness_current"
echo "Max brightness is $brightness_max"
echo "Percent brightness is $brightness_percent"

# Arbitrary but unique message tag
msgTag="mybrightness"


dunstify \
	-a "set-brightness" \
	-u low \
	-h string:x-dunst-stack-tag:$msgTag \
	-h int:value:"$brightness_percent" "Brightness: ${brightness_percent}%"

gmux_backlight $@ > /dev/null
