# alias feh-screenshots='feh --scale-down -d -S mtime ~/Pictures/screenshots'
feh-screenshots() {
	feh \
		--scale-down \
		-d \
		-S mtime \
		--action1 ';xclip -selection clipboard -t image/png -i %F' \
		--action2 ';echo %F | xclip -i -selection clipboard' \
		--draw-actions \
		~/Pictures/screenshots
}

feh-clipboard-base64() {
	data=$(echo "$(xclip -o -selection clipboard)")
	data=$(sed 's/^"\(.*\)"$/\1/' <<< $data) # delete surrounding quotes from Chrome
	echo $data | base64 --decode | feh -Z -
}

feh-background() {
	currentImageCmd=$(cat ~/.fehbg | grep feh)
	image=$(ls ~/.dotfiles/images | fzf --preview="feh --bg-fill ~/.dotfiles/images/{}" --select-1)
	if [ -n "$image" ]; then
		echo "Setting background to $image"
		feh --bg-scale ~/.dotfiles/images/$image
	else
		echo "No image selected, restoring previous background"
		eval $currentImageCmd
	fi
}
