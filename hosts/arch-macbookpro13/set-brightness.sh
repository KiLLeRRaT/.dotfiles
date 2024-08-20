#!/bin/bash

# Get current values
brightness_current=$(cat /sys/class/backlight/acpi_video0/brightness)
brightness_max=$(cat /sys/class/backlight/acpi_video0/max_brightness)
brightness_new=$(($brightness_current $@))

if [[ $@ == *"+"* ]]; then
	brightness_new=$(($brightness_new > $brightness_max ? $brightness_max : $brightness_new))
elif [[ $@ == *"-"* ]]; then
	brightness_new=$(($brightness_new < 0 ? 0 : $brightness_new))
fi


brightness_percent=$((100 * $brightness_new / $brightness_max))

echo "Current brightness is $brightness_current"
echo "Max brightness is $brightness_max"
echo "New brightness will be: " $brightness_new
echo "Percent brightness is $brightness_percent"

# Arbitrary but unique message tag
msgTag="mybrightness"


dunstify \
	-a "set-brightness" \
	-u low \
	-h string:x-dunst-stack-tag:$msgTag \
	-h int:value:"$brightness_percent" "Brightness: ${brightness_percent}%"

# gmux_backlight $@ > /dev/null

# ON THE PRO13:
# sudo tee /sys/class/backlight/acpi_video0/brightness <<< 25
echo $brightness_new >> /sys/class/backlight/acpi_video0/brightness
