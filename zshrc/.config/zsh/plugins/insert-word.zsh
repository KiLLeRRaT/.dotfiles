insert-word() {
	word=$(tmux capture-pane -pS -100000 |      # Dump the tmux buffer.
		  tac |                              # Reverse so duplicates use the first match.
		  grep -P -o "[\w\d_\-\.\/]+" |      # Extract the words.
		  awk '{ if (!seen[$0]++) print }' | # De-duplicate them with awk, then pass to fzf.
		  fzf --no-sort --select-1           # Pass to fzf for completion.
	  )

	LBUFFER+=$word
	zle redisplay
}

