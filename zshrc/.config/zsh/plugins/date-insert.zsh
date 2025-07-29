insert-date() {
	formats=(
		"$(date +'%Y-%m-%d')\t\tDefault (YYYY-MM-DD, %Y-%m-%d)"
		"$(date +'%Y%m%d')\t\tCompact (YYYYMMDD, %Y%m%d)"
		"$(date +'%Y-%m-%d-%H%M')\t\tWith time (HHMM, %Y-%m-%d-%H%M)"
		"$(date +'%Y%m%d%H%M')\t\tCompact with time (YYYYMMDDHHMM, %Y%m%d%H%M)"
		"$(date -u +'%Y-%m-%dT%H:%M:%SZ')\tISO 8601 (UTC, -u %Y-%m-%dT%H:%M:%SZ)"
		"$(date +'%A, %d %b')\t\tNZ full (Day, Date Mon, %A, %d %b)"
		"$(date +'%s')\t\tEpoch seconds (%s)"
		"feature/$(date +'%Y%m%d')_ag_\t\tBranch name format (feature/YYYYMMDD_ag_, feature/%Y%m%d_ag_)"
	)
	date=$(printf '%b\n' "${formats[@]}" | fzf --height=~50 --border --header="Select date format" --query "$1" --select-1 --no-sort | awk -F'\t' '{ print $1 }')
	LBUFFER+=$date
	zle redisplay
}

