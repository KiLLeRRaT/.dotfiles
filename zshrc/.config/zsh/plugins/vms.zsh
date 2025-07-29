vmGetDomain() {
	sudo virsh list --all | tail -n +3 | fzf --select-1 --query "$1" --height=~50 | awk '{ print $2 }'
}
# START THE SELECTED VM
vms() {
	domain=$(vmGetDomain $1)
	cmd="sudo virsh start $domain"
	print -z -- "$cmd; vmscreenshot $domain"
}

# CONNECT TO THE SELECTED VM
vmc() {
	domain=$(vmGetDomain $1)
	cmd="sudo virt-manager --connect qemu:///system --show-domain-console $domain"
	print -z -- "$cmd"
}

# SCREENSHOT VM
vmscreenshot() {
	tmpFile=$(mktemp)
	domain=$(vmGetDomain $1)
	# cmd="sudo virsh screenshot $domain /dev/stdout | feh -"
	cmd="sudo virsh screenshot $domain $tmpFile"
	eval $cmd

	# FROM: https://www.reddit.com/r/i3wm/comments/mpehmg/comment/gu9fed3/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
	# FROM: https://stackoverflow.com/q/9560245/182888
	trap 'echo "feh exited, now lets return";kill -INT $$' CHLD
	feh $tmpFile &
	feh_pid=$!
	echo "feh_pid: $feh_pid"
	feh_wid=""
	while [ -z $feh_wid ];
	do
		feh_wid=$(xdotool search --pid "$feh_pid")
		echo "feh_wid: $feh_wid"
		sleep 0.1
	done
	i3-msg "[id=$feh_wid] floating enable, move position center" > /dev/null

	count=0
	while [ $count -lt 300 ]
	do
		count=$((count+1))
		# eval $cmd
		echo -ne "\r$(eval $cmd) at $(date)"
		# echo -ne "\rtaking screenshot at $(date)"
		sleep 1
	done

	# push the command into the history
	print -S $cmd
	echo $cmd
	eval $cmd
	# read -q "REPLY?Run command? "
	# [[ "$REPLY" == "y" ]] && eval $cmd
}

