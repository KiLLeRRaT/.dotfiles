#!/bin/bash
set -e

source install-arch2.variables.sh

echo "DEV_ROOT="$(GET_VAR DEV_ROOT '/dev/$(lsblk --list | fzf --header-lines=1 --prompt="Please select DEV_ROOT: " | cut -d" " -f1)')
echo "DEVICE_UUID="$(GET_VAR DEVICE_UUID '$(blkid | fzf --prompt="Please select the DEV_ROOT device for cryptsetup: " | sed -E "s/^.*UUID=\"(.{36})\" .*$/\1/")')
echo "LUKS_PASSWORD=$(GET_VAR LUKS_PASSWORD)"
echo "NEW_HOSTNAME=$(GET_VAR NEW_HOSTNAME)"
echo "ROOT_PASSWORD=$(GET_VAR ROOT_PASSWORD)"
echo "USERNAME=$(GET_VAR USERNAME)"
echo "USER_PASSWORD=$(GET_VAR USER_PASSWORD)"
echo "CONFIGURE_PACMAN_HOOKS=$(GET_VAR CONFIGURE_PACMAN_HOOKS)"
echo "CONFIGURE_QEMU=$(GET_VAR CONFIGURE_QEMU)"
echo "CONFIGURE_XORG_TAPTOCLICK=$(GET_VAR CONFIGURE_XORG_TAPTOCLICK)"
source ./variables

echo -e "${GREEN}Press any key to start installation...${RESET}"
read -n 1

pacstrap -K /mnt base linux linux-lts linux-firmware \
	alacritty \
	aspnet-runtime \
	base-devel \
	bat \
	bc \
	bluez bluez-utils blueman \
	btop \
	btrfs-progs \
	cmake \
	curl \
	dhcpcd \
	dmenu \
	docker docker-compose docker-scan \
	dosbox \
	dotnet-runtime \
	dotnet-sdk \
	dunst \
	efibootmgr \
	fbset \
	fd \
	feh \
	flameshot xdotool \
	fzf \
	git \
	gnome-keyring seahorse lxsession-gtk3 \
	grub-btrfs \
	i3 \
	inotify-tools \
	iotop \
	jq \
	less \
	lightdm \
	lightdm-slick-greeter \
	man \
	mono \
	mono-msbuild \
	ncdu \
	neovim \
	network-manager-applet \
	networkmanager \
	networkmanager-l2tp strongswan \
	nginx \
	noto-fonts \
	noto-fonts-emoji \
	nuget \
	numlockx \
	openfortivpn \
	openssh \
	pacman-contrib \
	pam-u2f \
	pcmanfm \
	picom \
	polkit \
	ranger ueberzug \
	redshift \
	remmina freerdp libvncserver \
	ripgrep \
	rsync \
	sbctl \
	signal-desktop discord \
	silicon \
	snap-pac \
	snapper \
	spotify-launcher \
	sshfs \
	stow \
	sudo \
	systemd \
	timeshift \
	tmux \
	tokei \
	tree \
	ttf-cascadia-code-nerd \
	ufw \
	unzip \
	wget \
	wireplumber pipewire-pulse pavucontrol playerctl \
	xautolock \
	xclip \
	xorg \
	xorg-xinit \
	xorg-xrandr \
	zathura zathura-pdf-poppler \
	zip \
	zoxide \
	zsh


echo -e "${GREEN}Generate fstab${RESET}"
genfstab -U /mnt >> /mnt/etc/fstab

echo -e "${GREEN}Executing in chroot from here${RESET}"

arch-chroot /mnt ln -sf /usr/share/zoneinfo/Pacific/Auckland /etc/localtime
arch-chroot /mnt hwclock --systohc
arch-chroot /mnt sed -i 's/#en_NZ.UTF-8 UTF-8/en_NZ.UTF-8 UTF-8/g' /etc/locale.gen
arch-chroot /mnt locale-gen
arch-chroot /mnt echo "LANG=en_NZ.UTF-8" > /etc/locale.conf

echo "$NEW_HOSTNAME" > /mnt/etc/hostname
echo "127.0.0.1	 localhost.localdomain   localhost   $NEW_HOSTNAME" >> /mnt/etc/hosts
echo "::1	 localhost.localdomain   localhost   $NEW_HOSTNAME" >> /mnt/etc/hosts

sed -i 's/^#Color/Color/g' /mnt/etc/pacman.conf
sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 10/g' /mnt/etc/pacman.conf
sed -i.bak '/^HOOKS=/s/block/block encrypt/' /mnt/etc/mkinitcpio.conf

echo -e "${GREEN}Generate key for unlocking root${RESET}"
dd bs=512 count=4 if=/dev/random iflag=fullblock | arch-chroot /mnt install -m 0600 /dev/stdin /etc/cryptsetup-keys.d/root.key
echo -n "$LUKS_PASSWORD" | cryptsetup luksAddKey --key-file - $DEV_ROOT /mnt/etc/cryptsetup-keys.d/root.key
sed -i.bak '/^FILES=/s|(.*)|(/etc/cryptsetup-keys.d/root.key)|' /mnt/etc/mkinitcpio.conf

echo -e "${GREEN}Set password for root${RESET}"
echo $ROOT_PASSWORD | arch-chroot /mnt passwd --stdin

echo -e "${GREEN}Create user $USERNAME${RESET}"
arch-chroot /mnt useradd -m -G wheel,storage,power -g users -s /bin/zsh $USERNAME
echo $USER_PASSWORD | arch-chroot /mnt passwd $USERNAME --stdin
sed -i.bak 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /mnt/etc/sudoers

echo -e "${GREEN}Configure GRUB${RESET}"
sed -i 's/^#GRUB_ENABLE_CRYPTODISK=/GRUB_ENABLE_CRYPTODISK=/' /mnt/etc/default/grub
sed -i '/^GRUB_PRELOAD_MODULES=/s/part_gpt/btrfs part_gpt/' /mnt/etc/default/grub
sed -i.bak "/^GRUB_CMDLINE_LINUX=/s|\".*\"|\"cryptdevice=UUID=$DEVICE_UUID:root root=/dev/mapper/root cryptkey=rootfs:/etc/cryptsetup-keys.d/root.key\"|" /mnt/etc/default/grub
arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
arch-chroot /mnt mkinitcpio -P

# TODO: This could probably come from stow....?
sed -i.bak 's|^#greeter-session=.*$|greeter-session=lightdm-slick-greeter|' /mnt/etc/lightdm/lightdm.conf

echo -e "${GREEN}Enable services${RESET}"
arch-chroot /mnt /bin/bash -- << EOF
	systemctl enable lightdm.service
	systemctl enable sshd
	systemctl enable bluetooth
	systemctl enable NetworkManager.service
	systemctl enable cronie.service
	systemctl enable paccache.timer
	systemctl enable snapper-timeline.timer
	systemctl enable snapper-cleanup.timer
	systemctl enable snapper-boot.timer
	systemctl enable systemd-resolved.service
	systemctl enable docker
EOF

echo -e "${GREEN}Configuring makepkg${RESET}"
# DISABLE COMPRESSION
arch-chroot /mnt sed -i 's/^PKGEXT.*/PKGEXT=".pkg.tar"/' /etc/makepkg.conf
# DISABLE DEBUGGING
arch-chroot /mnt sed -i 's/\(OPTIONS=.*\)debug/\1!debug/' /etc/makepkg.conf

echo -e "${GREEN}Hardening /tmp and /dev/shm by setting noexec${RESET}"
tmp=$(arch-chroot /mnt findmnt /tmp --output SOURCE,FSTYPE,OPTIONS | tail -n1)
devshm=$(arch-chroot /mnt findmnt /dev/shm --output SOURCE,FSTYPE,OPTIONS | tail -n1)
arch-chroot /mnt bash -c "cat >> /etc/fstab" << EOF
$(echo $tmp | sed "s/^tmpfs/tmpfs    \/tmp/"),noexec 0 0
$(echo $devshm | sed "s/^tmpfs/tmpfs    \/dev\/shm/"),noexec 0 0
EOF

# FROM: https://wiki.archlinux.org/title/Sysctl#Configuration
echo -e "${GREEN}Enable SysRq${RESET}"
echo "kernel.sysrq=1" > /mnt/etc/sysctl.d/99-sysctl.conf

#echo "Configuring ufw rules"
#arch-chroot /mnt ufw allow from 192.168.111.0/24 to any app SSH
#arch-chroot /mnt ufw allow from 192.168.114.0/24 to any app SSH
#echo "Enable ufw? (y/n)"
#read enable_ufw
#if [ "$enable_ufw" == "y" ]; then
	#arch-chroot /mnt ufw enable
#fi


if [ "$CONFIGURE_XORG_TAPTOCLICK" == "y" ]; then
	echo -e "${GREEN}Configure Xorg${RESET}"
	# FROM: https://cravencode.com/post/essentials/enable-tap-to-click-in-i3wm/
	mkdir -p /mnt/etc/X11/xorg.conf.d
	cat << EOF > /mnt/etc/X11/xorg.conf.d/90-touchpad.conf
Section "InputClass"
	Identifier "touchpad"
	MatchIsTouchpad "on"
	Driver "libinput"
	Option "Tapping" "on"
	Option "TappingButtonMap" "lrm"
	Option "NaturalScrolling" "on"
	Option "ScrollMethod" "twofinger"
EndSection
EOF
fi

if [ "$CONFIGURE_QEMU" == "y" ]; then
	echo -e "${GREEN}Configure QEMU${RESET}"
	arch-chroot /mnt pacman --noconfirm --needed -Syu virt-manager libvirt qemu virt-viewer swtpm
fi

# TODO: 
# - [ ] GREETER CUSTOMISATION
# - [ ] YubiKey

echo -e "${GREEN}Done${RESET}"
