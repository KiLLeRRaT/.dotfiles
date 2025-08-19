npm-outdated-update() {
	whatParam=$1
	if [ -z $whatParam ]; then
		whatParam="minor"
	fi
	if [ $whatParam = "major" ]; then
		whatColumn=4
	else
		whatColumn=3
	fi
	packages=$(npm outdated --color=always)

	echo $packages |\
		fzf --ansi --header=$whatParam --multi --header-lines=1 --bind ctrl-a:select-all |\
		awk '{
			print "Updating " $1 " from " $2 " to " $'$whatColumn' > "/dev/stderr";
			print $1"@"$'$whatColumn';
		}' |\
		xargs --no-run-if-empty npm install
}

