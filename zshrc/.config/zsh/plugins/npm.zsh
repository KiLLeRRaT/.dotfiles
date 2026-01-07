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

	echo $packages \
		| fzf \
			--ansi \
			--header=$whatParam \
			--multi \
			--header-lines=1 \
			--bind ctrl-a:select-all \
			--bind tab:toggle+up \
			--bind shift-tab:toggle+down \
		| awk '{
			print "Updating " $1 " from " $2 " to " $'$whatColumn' > "/dev/stderr";
			print $1"@"$'$whatColumn';
		}' \
		| xargs \
			--no-run-if-empty \
			npm install
}

if [ -f $HOME/.config/op/npm-env ] && command -v op >/dev/null 2>&1; then
	# If you don't have the file, perhaps create it, and add the following to it:
	# NPM_AUTH_TOKEN="op://VAULT/ITEM/FIELD"
	# Reminder: Make sure the value is base64 encoding, echo -n "NPM_AUTH_TOKEN" | base64

	# alias npm="op run --env-file=$HOME/.config/op/npm-env --no-masking -- env | sort && npm"
	# alias npm="op run --env-file=$HOME/.config/op/npm-env --no-masking -- npm"
	alias npm="op run --env-file=$HOME/.config/op/npm-env -- npm --color=always"
fi
