#!/bin/bash
set -e

GREEN="\033[32m"
RESET="\033[0m"

timedatectl set-ntp true
sed -i 's/^#Color/Color/g' /etc/pacman.conf
sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 10/g' /etc/pacman.conf
pacman -Sy --noconfirm --needed archlinux-keyring git fzf

# Function to get a variable value
GET_VAR() {
	local var_name="$1"
	local read_command="$2"
	local variables_file="variables"

	# Check if the variable is already set in the environment or the variables file
	if [[ -z "${!var_name}" ]]; then
		# Check if the variable exists in the variables file
		if grep -q "^${var_name}=" "$variables_file" 2>/dev/null; then
			# Source the variable from the file
			source "$variables_file"
		else
			# Ask the user for input if the variable is not set
			# read -p "Enter value for $var_name: " value
			if [ -z "$read_command" ]; then
				read -p "Enter value for $var_name: " value
			else
				value=$(eval echo $read_command)
			fi

			# Declare and set the variable in the current environment
			declare -g "$var_name"="$value"

			# Append the variable and its value to the variables file
			echo "$var_name=\"$value\"" >> "$variables_file"
		fi
	fi

	# Display the variable's value
	echo "${!var_name}"
}
# EXAMPLES: 
# echo "Age: $(GET_VAR AGE)"
# echo "DEV_BOOT="$(GET_VAR DEV_BOOT '/dev/$(lsblk --list | fzf --prompt="Please select DEV_BOOT: " | cut -d" " -f1)')

# echo "DEV_BOOT="$(GET_VAR DEV_BOOT '/dev/$(lsblk --list | fzf --header-lines=1 --prompt="Please select DEV_BOOT: " | cut -d" " -f1)')
# echo "DEV_ROOT="$(GET_VAR DEV_ROOT '/dev/$(lsblk --list | fzf --header-lines=1 --prompt="Please select DEV_ROOT: " | cut -d" " -f1)')
# echo "DEVICE_UUID="$(GET_VAR DEVICE_UUID '$(blkid | fzf --prompt="Please select the DEV_ROOT device for cryptsetup: " | sed -E "s/^.*UUID=\"(.{36})\" .*$/\1/")')
# echo "LUKS_PASSWORD=$(GET_VAR LUKS_PASSWORD)"
# echo "NEW_HOSTNAME=$(GET_VAR NEW_HOSTNAME)"
# echo "ROOT_PASSWORD=$(GET_VAR ROOT_PASSWORD)"
# echo "USERNAME=$(GET_VAR USERNAME)"
# echo "USER_PASSWORD=$(GET_VAR USER_PASSWORD)"
# echo "CONFIGURE_PACMAN_HOOKS=$(GET_VAR CONFIGURE_PACMAN_HOOKS)"
# echo "CONFIGURE_QEMU=$(GET_VAR CONFIGURE_QEMU)"
# echo "CONFIGURE_XORG_TAPTOCLICK=$(GET_VAR CONFIGURE_XORG_TAPTOCLICK)"

echo -e "${GREEN}Done setting variables${RESET}"
