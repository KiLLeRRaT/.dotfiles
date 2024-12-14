#!/bin/bash
# FROM: https://github.com/dunst-project/dunst/issues/865#issuecomment-1553502505

if [ "$1" != "dnd_start" ] && [ "$1" != "dnd_stop" ]; then
	echo "Usage: $0 [dnd_start|dnd_stop]"
	exit 1
fi

function show_history() {
	hist_size=$(dunstctl history | jq '.data[0] | length')
	for i in `seq $hist_size`; do
		dunstctl history-pop
	done
}

function dnd_stop() {
	dunstctl rule dnd disable
	show_history
}

function dnd_start() {
	dunstctl history-clear
	dunstctl rule dnd enable
}

$1
