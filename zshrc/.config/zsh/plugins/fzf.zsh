# fzf git checkout
fgco() {
	# git branch --all --sort=-committerdate |\
	# 	fzf --height=~50 -e --select-1 --no-sort --query "$1" |\
	# 	sed 's/remotes\/origin\///' |\
	# 	xargs --no-run-if-empty git checkout
	
	branch=$(git branch --all --sort=-committerdate |\
		fzf --height=~50 -e --select-1 --no-sort --query "$1" |\
		sed 's/remotes\/origin\///')

	# echo "Checking out branch: $branch"
	cmd="git checkout $branch"
	print -z -- "$cmd"
}

# # KILL USING FZF AS SELECTOR
# fkk() {
# 	sig=$1
# 	cmd=$(ps -aux | sort -nr | fzf --multi -e --select-1 --no-sort --query "$2" )
# 	echo Killing the following:
# 	echo $cmd
# 	for pid in $(echo $cmd | awk '{ print $2 }')
# 	do
# 		if [ $sig -eq 9 ]
# 		then
# 			# echo "Killing $pid with -9"
# 			kill -9 $pid
# 		else
# 			# echo "Killing $pid with -15"
# 			kill -15 $pid
# 		fi
# 	done
# }
# # KILL USING FZF AS SELECTOR
# fk9() {
# 	fkk 9 $1
# }
# # KILL USING FZF AS SELECTOR
# fk() {
# 	fkk 15 $1
# }

# RUN THE COMMAND FROM HISTORY, USING FZF AS SELECTOR
fh() {
	cmd=$(history 0 | sort -nr | cut -c 8- | fzf -e --select-1 --no-sort --query "$1" )
	if [ -z "$cmd" ]; then
		return 1
	fi
	print -z -- "$cmd"
}

# REMMINA USING THE CONNECTION FILE SELECTED USING FZF
fr() {
	pushd -q ~/.local/share/remmina
	subcmd=$(ls $PWD/* | fzf --ignore-case -e --select-1 --no-sort --query "$1")
	cmd="remmina -c '"$subcmd"'"
	# push the command into the history
	# print -S $cmd
	# eval $cmd > /dev/null 2>&1 &
	# disown
	print -z -- "$cmd > /dev/null 2>&1 & disown"
	popd -q
}

# fzf time zone time
alias ftz='TZ=$(timedatectl list-timezones | fzf) date'

# fzf CBM bookmarks
fcbm() {
	pushd -q ~/scripts/Sandfield # We want to do this because there are other files we need in this location
	./CBM-CentralBookmarksManager-export-textfiles.sh "$1"
	popd -q
}
# alias fcbm='pushd ~/scripts/Sandfield > /dev/null 2>&1; ./CBM-CentralBookmarksManager-export-textfiles.sh; popd -q

# SUPERCEDED BY USING nvim **<tab> instead
# fn() {
# 	local results=$(fzf --multi --preview 'bat --color=always {}')
# 	[ -z $results ] && return
# 	echo "$results"
# 	echo "$results" | xargs --no-run-if-empty -d'\n' nvim
# }

# fzf i3 key binds, and run the command
fi3() {
	cmd=$(sed '/^bindsym/!d' ~/.config/i3/config | fzf --query "$1" --select-1)
	cmd=$(cut -f 3- -d' ' <<< $cmd)
	i3-msg $cmd > /dev/null
}

# FZF to lsblk, then mount it to a mount point, echo the command to let the user edit it and then
# run it
fm() {
	# cmd=$(history 0 | sort -nr | cut -c 8- | fzf -e --select-1 --no-sort --query "$1" )
	device=/dev/$(lsblk --filter 'TYPE == "part"' | fzf --header-lines=1 --query "$1" --select-1 --no-sort | awk '{ print $1 }')
	# push the command into the history
	# print -S $cmd
	# echo $cmd
	# read -q "REPLY?Run command? "
	# [[ "$REPLY" == "y" ]] && eval $cmd

	default=/run/media/usb
	echo "Please enter the mount point [$default]: "
	read input
	MOUNTPOINT=${input:-$default}

	if ( ! [ -d $MOUNTPOINT ] )
	then
		echo "Mount point $MOUNTPOINT does not exist, create it? (y/n)"
		read -q "REPLY? "
		[[ "$REPLY" == "y" ]] && sudo mkdir -p $MOUNTPOINT
	fi

	# echo "Mounting $device to $MOUNTPOINT"
	cmd="sudo mount $device $MOUNTPOINT"
	print -z -- "$cmd"
}

f-cycling() {
  f=$(fd . '/mnt/data2-temp/tdarr/data-media/sport/Tour de France/Season 2025/' | fzf --query "$1" --select-1 --multi)
  if [ -n "$f" ]; then
	cmd="vlc '$f' & disown"
	print -z -- "$cmd"
  else
	echo "No file selected."
  fi
}

