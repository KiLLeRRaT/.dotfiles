#!/bin/env bash
# FROM: https://github.com/clayboone/scripts/blob/master/auto_lock_screen.sh

# Settings
declare -a LIST_OF_WINDOW_TITLES_THAT_PREVENT_LOCKING=(
	"YouTube"
	"Meet"
	"Microsoft Teams"
)

# Dependencies
AWK=/usr/bin/awk
GREP=/usr/bin/grep
XPROP=/usr/bin/xprop

# Find active window id
get_active_id() {
	$XPROP -root | $AWK '$1 ~ /_NET_ACTIVE_WINDOW/ { print $5 }'
}

# Determine a window's title text by it's ID
get_window_title() {
	# For mplayer or vlc, we might need to check WM_CLASS(STRING), idk.
	$XPROP -id $1 | $AWK -F '=' '$1 ~ /_NET_WM_NAME\(UTF8_STRING\)/ { print $2 }'
}

# Determine if a window is fullscreen based on it's ID
is_fullscreen() {
	$XPROP -id $1 | $AWK -F '=' '$1 ~ /_NET_WM_STATE\(ATOM\)/ { for (i=2; i<=3; i++) if ($i ~ /FULLSCREEN/) exit 0; exit 1 }'
	return $?
}

# Determine if the locker command should run based on which windows are
# fullscreened.
should_lock() {
	id=$(get_active_id)
	title=$(get_window_title $id)

	# echo "Active window ID: $id"
	# echo "Active window title: $title"

	# if is_fullscreen $id; then
		for i in "${LIST_OF_WINDOW_TITLES_THAT_PREVENT_LOCKING[@]}"; do
			# echo "Comparing $i to $title"
			if [[ $title =~ $i ]]; then
				return 1
			fi
		done

		return 0
	# else
		# return 0
	# fi
}

# main()
if should_lock; then
	# echo "$(date '+%Y-%m-%d %H:%M:%S') Should lock: $(should_lock && echo yes || echo no)" >> /tmp/xautolock.log
	exit 0
else
	echo "$(date '+%Y-%m-%d %H:%M:%S') Should lock: $(should_lock && echo yes || echo no)" >> /tmp/xautolock.log
	exit 1
fi
