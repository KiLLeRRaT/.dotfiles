#!/bin/bash

# Get rotation parameter from the command line
rotation=$1

# Check if the rotation parameter is empty
if [ -z $rotation ]; then
		echo "Usage: $0 <rotation>"
		exit 1
fi

# Rotate display using xrandr
xrandr -o $rotation

# char *COOR[]  = {"0 1 0 -1 0 1 0 0 1", 	"0 -1 1 1 0 0 0 0 1","1 0 0 0 1 0 0 0 1",  	"-1 0 1 0 -1 1 0 0 1"};
case $rotation in
	0)
		rotationForTouch="1 0 0 0 1 0 0 0 1"
		;;
	1)
		rotationForTouch="0 -1 1 1 0 0 0 0 1"
		;;
	2)
		rotationForTouch="-1 0 1 0 -1 1 0 0 1"
		;;
	3)
		rotationForTouch="0 1 0 -1 0 1 0 0 1"
		;;
	*)
		echo "Invalid rotation parameter"
		exit 1
		;;
esac
xinput set-prop "ELAN22A6:00 04F3:22A6" "Coordinate Transformation Matrix" $rotationForTouch
