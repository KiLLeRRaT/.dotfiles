#!/bin/zsh

set -eu

host="${HOST:-}"
if [[ -z "$host" ]]; then
	host="$(hostname)"
fi

echo "host is $host"

generate_host_config() {
	local directory="$1"
	local source_file="$2"
	local output_file="$3"
	local marker_mode="${4:-preserve}"

	if [[ ! -f "$directory/$source_file" ]]; then
		return 0
	fi

	(
		cd "$directory"
		local temp_file="${output_file}.tmp.$$"
		trap 'rm -f "$temp_file"' EXIT
		awk -v host="$host" -v marker_mode="$marker_mode" '
			/<hostSpecificConfig>/ {
				in_host_specific = 1
				if (marker_mode != "strip") {
					print
				}
				next
			}
			/<\/hostSpecificConfig>/ {
				in_host_specific = 0
				keep_current_host = 0
				if (marker_mode != "strip") {
					print
				}
				next
			}
			!in_host_specific {
				print
				next
			}
			$0 ~ ("<config hostname=\"" host "\">") {
				keep_current_host = 1
				if (marker_mode != "strip") {
					print
				}
				next
			}
			/<config hostname="/ {
				keep_current_host = 0
				next
			}
			/<\/config>/ {
				if (keep_current_host && marker_mode != "strip") {
					print
				}
				keep_current_host = 0
				next
			}
			keep_current_host {
				if (marker_mode == "strip" && $0 ~ /^[[:space:]]*(\/\/|\/\*|\*|\*\/)/) {
					next
				}
				print
			}
		' "$source_file" > "$temp_file"
		mv "$temp_file" "$output_file"
		trap - EXIT
	)
}

generate_host_config "$HOME/.dotfiles/i3-manjaro/.config/i3status" "config.allHosts" "config"
generate_host_config "$HOME/.dotfiles/i3-manjaro/.config/i3" "config.allHosts" "config"
generate_host_config "$HOME/.dotfiles/alacritty/.config/alacritty" "alacritty.allHosts.toml" "alacritty.toml"
generate_host_config "$HOME/.dotfiles/sway/.config/sway" "config.allHosts" "config"
generate_host_config "$HOME/.dotfiles/waybar/.config/waybar" "config.allHosts" "config" "strip"
