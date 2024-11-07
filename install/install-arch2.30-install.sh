#!/bin/bash
set -e

GREEN=\033[32m
RESET=${RESET}

source install-arch2.variables.sh

echo Press any key to start installation...
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


echo "Generate fstab"
genfstab -U /mnt >> /mnt/etc/fstab

echo "Executing in chroot from here"

arch-chroot /mnt ln -sf /usr/share/zoneinfo/Pacific/Auckland /etc/localtime
arch-chroot /mnt hwclock --systohc
arch-chroot /mnt sed -i 's/#en_NZ.UTF-8 UTF-8/en_NZ.UTF-8 UTF-8/g' /etc/locale.gen
arch-chroot /mnt locale-gen
arch-chroot /mnt echo "LANG=en_NZ.UTF-8" > /etc/locale.conf

arch-chroot /mnt echo "$HOSTNAME" > /etc/hostname
arch-chroot /mnt echo "127.0.0.1   localhost.localdomain   localhost   $hostname" >> /etc/hosts
arch-chroot /mnt echo "::1   localhost.localdomain   localhost   $hostname" >> /etc/hosts

arch-chroot /mnt sed -i 's/#Color/Color/g' /etc/pacman.conf
arch-chroot /mnt sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 10/g' /etc/pacman.conf
arch-chroot /mnt sed -i.bak '/^HOOKS=/s/block/block encrypt/' /etc/mkinitcpio.conf
# GENERATE KEY FOR UNLOCKING ROOT
dd bs=512 count=4 if=/dev/random iflag=fullblock | arch-chroot /mnt install -m 0600 /dev/stdin /etc/cryptsetup-keys.d/root.key
echo -n "$LUKS_PASSWORD" | cryptsetup luksAddKey --key-file - $DEV_ROOT /mnt/etc/cryptsetup-keys.d/root.key
arch-chroot /mnt sed -i.bak2 '/^FILES=/s|(.*)|(/etc/cryptsetup-keys.d/root.key)|' /etc/mkinitcpio.conf
echo "Set password for root"
echo $ROOT_PASSWORD | arch-chroot /mnt passwd --stdin

arch-chroot /mnt useradd -m -G wheel,storage,power -g users -s /bin/zsh $USERNAME
echo $USER_PASSWORD | arch-chroot /mnt passwd $USERNAME --stdin
arch-chroot /mnt sed -i.bak 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /etc/sudoers

arch-chroot /mnt sed -i 's/^#GRUB_ENABLE_CRYPTODISK=/GRUB_ENABLE_CRYPTODISK=/' /etc/default/grub
arch-chroot /mnt sed -i '/^GRUB_PRELOAD_MODULES=/s/part_gpt/btrfs part_gpt/' /etc/default/grub

arch-chroot /mnt sed -i.bak "/^GRUB_CMDLINE_LINUX=/s|\".*\"|\"cryptdevice=UUID=$DEVICE_UUID:root root=/dev/mapper/root cryptkey=rootfs:/etc/cryptsetup-keys.d/root.key\"|" /etc/default/grub
arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg
arch-chroot /mnt mkinitcpio -P

# TODO: This could probably come from stow....?
arch-chroot /mnt sed -i.bak "s|^#greeter-session=.*$|greeter-session=lightdm-slick-greeter|" /etc/lightdm/lightdm.conf

echo "Enable services"
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

echo "Configuring makepkg"
# DISABLE COMPRESSION
arch-chroot /mnt sed -i 's/^PKGEXT.*/PKGEXT=".pkg.tar"/' /etc/makepkg.conf
# DISABLE DEBUGGING
arch-chroot /mnt sed -i 's/\(OPTIONS=.*\)debug/\1!debug/' /etc/makepkg.conf

echo "Hardening /tmp and /dev/shm by setting noexec"
tmp=$(arch-chroot /mnt findmnt /tmp --output SOURCE,FSTYPE,OPTIONS | tail -n1)
devshm=$(arch-chroot /mnt findmnt /dev/shm --output SOURCE,FSTYPE,OPTIONS | tail -n1)
arch-chroot /mnt bash -c "cat >> /etc/fstab" << EOF
$(echo $tmp | sed "s/^tmpfs/tmpfs    \/tmp/"),noexec 0 0
$(echo $devshm | sed "s/^tmpfs/tmpfs    \/dev\/shm/"),noexec 0 0
EOF

# FROM: https://wiki.archlinux.org/title/Sysctl#Configuration
echo "Enable SysRq"
echo "kernel.sysrq=1" > /mnt/etc/sysctl.d/99-sysctl.conf

#echo "Configuring ufw rules"
#arch-chroot /mnt ufw allow from 192.168.111.0/24 to any app SSH
#arch-chroot /mnt ufw allow from 192.168.114.0/24 to any app SSH
#echo "Enable ufw? (y/n)"
#read enable_ufw
#if [ "$enable_ufw" == "y" ]; then
	#arch-chroot /mnt ufw enable
#fi


arch-chroot -u $USERNAME /mnt git clone https://github.com/killerrat/.dotfiles /home/$USERNAME/.dotfiles
# arch-chroot -u $USERNAME /mnt /home/$USERNAME/.dotfiles/nvim-lua/.config/nvim/generateHostConfig.sh

echo "Running stow"
arch-chroot /mnt /bin/bash -c "cd /home/$USERNAME/.dotfiles/hosts/arch-agouws && stow -t ~ xinitrc"
# arch-chroot /mnt mv /etc/lightdm/lightdm-gtk-greeter.conf{,.bak}
arch-chroot /mnt /bin/bash -c "cd /home/$USERNAME/.dotfiles && stow -t / lightdm"


arch-chroot /mnt mkdir -p /usr/share/backgrounds/$USERNAME
# arch-chroot /mnt chmod o+x /usr/share/backgrounds/$USERNAME
arch-chroot /mnt /bin/bash -c "cd /home/$USERNAME/.dotfiles && stow -t /usr/share/backgrounds/$USERNAME images"
# arch-chroot /mnt chmod o+r /usr/share/backgrounds/$USERNAME/*
arch-chroot -u $USERNAME /mnt /bin/bash -c "cd /home/$USERNAME/.dotfiles && stow alacritty dmenurc dosbox dunst flameshot fonts gitconfig gtk-2.0 gtk-3.0 gtk-4.0 i3-manjaro nvim-lua oh-my-posh picom ranger tmux zshrc"


echo "Let's copy our gtk configs to /root, so that root has the same theme"
cp /mnt/home/$USERNAME/.dotfiles/gtk-2.0/.gtkrc-2.0 /mnt/root
mkdir -p /mnt/root/.config
cp -r /mnt/home/$USERNAME/.dotfiles/gtk-3.0/.config/gtk-3.0 /mnt/root/.config
cp -r /mnt/home/$USERNAME/.dotfiles/gtk-4.0/.config/gtk-4.0 /mnt/root/.config

if [ "$CONFIGURE_XORG_TAPTOCLICK" == "y" ]; then
	echo -e "${GREEN}----------------------------------------${RESET}"
	echo -e "${GREEN}Configure Xorg${RESET}"
	echo -e "${GREEN}----------------------------------------${RESET}"
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

if [ "$CONFIGURE_PACMAN_HOOKS" == "y" ]; then
	echo -e "${GREEN}----------------------------------------${RESET}"
	echo -e "${GREEN}Configure Pacman Hooks${RESET}"
	echo -e "${GREEN}----------------------------------------${RESET}"
	mkdir -p /mnt/etc/pacman.d/hooks
	cp /mnt/home/$USERNAME/.dotfiles/pacman/hooks/* /mnt/etc/pacman.d/hooks/
fi

if [ "$CONFIGURE_QEMU" == "y" ]; then
	echo -e "${GREEN}----------------------------------------${RESET}"
	echo -e "${GREEN}Configure QEMU${RESET}"
	echo -e "${GREEN}----------------------------------------${RESET}"
	arch-chroot /mnt pacman --noconfirm --needed -Syu virt-manager libvirt qemu virt-viewer swtpm
fi

# TODO: 
# - [ ] GREETER CUSTOMISATION
# - [ ] YubiKey

echo "Done"
