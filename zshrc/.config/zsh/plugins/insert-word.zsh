# Like using w in VIM
insert-word-small() {
	insert-word "\w+"
}

# Like using W in VIM
insert-word-large() {
	insert-word "[\w\d_\-\.\/]+"
}

insert-word() {
	REGEX=$1
	word=$(tmux capture-pane -pS -100000 |      # Dump the tmux buffer.
		  tac |                              # Reverse so duplicates use the first match.
		  grep -P -o "$REGEX" |      # Extract the words.
		  awk '{ if (!seen[$0]++) print }' | # De-duplicate them with awk, then pass to fzf.
		  fzf --no-sort --select-1           # Pass to fzf for completion.
	  )

	LBUFFER+=$word
	zle redisplay
}
