#!/bin/bash

if pgrep -f 'python3 /usr/bin/nerd-dictation begin'; then
	notify-send 'Stopping dictation'
	nerd-dictation end
else
	notify-send 'Starting dictation'
	nerd-dictation begin &
fi

