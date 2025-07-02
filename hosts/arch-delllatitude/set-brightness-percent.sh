#!/bin/bash
set -e

echo "testing"

echo $@
# param is in the format of +10 or -10
direction=$(echo $@ | grep -oE '^\+|-')
echo "Direction: $direction"
valuePercentChange=$(echo $@ | grep -oE '[0-9]+$')
echo "ValuePercentChange: $valuePercentChange"


# Get current values
brightness_current=$(cat /sys/class/backlight/intel_backlight/brightness)
brightness_max=$(cat /sys/class/backlight/intel_backlight/max_brightness)

# Calculate new brightness

# If the value is negative, we need to subtract it
# If the value is positive, we need to add it
if [[ $direction == "+" ]]; then
	brightness_new=$(($brightness_current + $valuePercentChange * $brightness_max / 100))
elif [[ $direction == "-" ]]; then
	brightness_new=$(($brightness_current - $valuePercentChange * $brightness_max / 100))
else
	echo "Invalid direction. Use + or -."
	exit 1
fi

echo "Brightness new: $brightness_new"


# brightness_new=$(($brightness_current $@))

# if [[ $@ == *"+"* ]]; then
# 	brightness_new=$(($brightness_new > $brightness_max ? $brightness_max : $brightness_new))
# elif [[ $@ == *"-"* ]]; then
# 	brightness_new=$(($brightness_new < 0 ? 0 : $brightness_new))
# fi

 if [[ $brightness_new -lt 0 ]]; then
	brightness_new=0
elif [[ $brightness_new -gt $brightness_max ]]; then
	brightness_new=$brightness_max
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

echo $brightness_new > /sys/class/backlight/intel_backlight/brightness
# gmux_backlight $@ > /dev/null
