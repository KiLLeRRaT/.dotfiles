#!/bin/bash
set -e

for i in "$@"
do
case $i in
		-c=*|--continue-from-line=*)
		CONTINUE_FROM_LINE="${i#*=}"
		shift # past argument=value
		;;
		-h|--help)
		echo "Usage: install-arch2.sh [OPTION]"
		echo "Options:"
		echo "  -c, --continue-from-line=NUM  Continue from line number NUM"
		echo "  -h, --help                    Display this help message"
		exit 0
		;;
		*)
					# unknown option
		;;
esac
done

if [ ! -z $CONTINUE_FROM_LINE ]
then
	SCRIPT_CONTENTS=$(cat $0 | sed -n "1,/^echo Press any key to continue installation.../p;$CONTINUE_FROM_LINE,\$p")
	echo "$SCRIPT_CONTENTS" > install-arch2.sh.continue
	chmod u+x install-arch2.sh.continue
	cat ./install-arch2.sh.continue
	exit 0
fi

timedatectl set-ntp true
sed -i 's/^#Color/Color/g' /etc/pacman.conf
sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 10/g' /etc/pacman.conf
pacman -Sy --noconfirm --needed archlinux-keyring git fzf

if [ -z $DEV_BOOT ] || [ -z $DEV_ROOT ]
then
	DEV_BOOT=/dev/$(lsblk --list | fzf --prompt="Please select DEV_BOOT: " | cut -d' ' -f1)
	echo ""
	DEV_ROOT=/dev/$(lsblk --list | fzf --prompt="Please select DEV_ROOT: " | cut -d' ' -f1)
	echo ""
fi

lsblk
blkid
DEVICE_UUID=$(blkid | fzf --prompt="Please select the DEV_ROOT device again so we can get the UUID" | sed -E 's/^.*UUID="(.{36})" .*$/\1/')

echo "What is your hostname? (e.g. arch-agouwsmacbookpro)"
read HOSTNAME

echo "What is your username? (e.g. albert)"
read USERNAME

echo "Enter LUKS password for $DEV_ROOT"
read -s LUKS_PASSWORD

echo "Enter root password"
read -s ROOT_PASSWORD

echo "Enter user password"
read -s USER_PASSWORD

echo DEV_BOOT: $DEV_BOOT
echo DEV_ROOT: $DEV_ROOT
echo HOSTNAME: $HOSTNAME
echo USERNAME: $USERNAME
echo DEVICE_UUID: $DEVICE_UUID
echo "Show passwords? (y/n)"
read -n 1 show_passwords
if [ "$show_passwords" == "y" ]; then
	echo LUKS_PASSWORD: $LUKS_PASSWORD
	echo ROOT_PASSWORD: $ROOT_PASSWORD
	echo USER_PASSWORD: $USER_PASSWORD
fi
echo Press any key to continue installation...
read -n 1


# PARTITION SETUP
echo $LUKS_PASSWORD | cryptsetup luksFormat --pbkdf pbkdf2 $DEV_ROOT -
cryptsetup open $DEV_ROOT root
mkfs.btrfs --label system /dev/mapper/root
mount /dev/mapper/root /mnt

btrfs subvol create /mnt/@
btrfs subvol create /mnt/@home
btrfs subvol create /mnt/@swap
btrfs subvol create /mnt/@pkg
btrfs subvol create /mnt/@log
btrfs subvol create /mnt/@docker
btrfs subvol create /mnt/@libvirt

umount -R /mnt
mount -o defaults,noatime,ssd,compress=zstd,subvol=@ /dev/mapper/root /mnt

mkdir -p /mnt/efi
mkdir -p /mnt/home
mkdir -p /mnt/swap
mkdir -p /mnt/var/cache/pacman/pkg
mkdir -p /mnt/var/log
mkdir -p /mnt/var/lib/docker
mkdir -p /mnt/var/lib/libvirt

mount -o defaults,noatime,ssd,compress=zstd,subvol=@home /dev/mapper/root /mnt/home
mount -o defaults,noatime,ssd,compress=zstd,subvol=@swap /dev/mapper/root /mnt/swap
mount -o defaults,noatime,ssd,compress=zstd,subvol=@pkg /dev/mapper/root /mnt/var/cache/pacman/pkg
mount -o defaults,noatime,ssd,compress=zstd,subvol=@log /dev/mapper/root /mnt/var/log
mount -o defaults,noatime,ssd,compress=zstd,subvol=@docker /dev/mapper/root /mnt/var/lib/docker
mount -o defaults,noatime,ssd,compress=zstd,subvol=@libvirt /dev/mapper/root /mnt/var/lib/libvirt

mount $DEV_BOOT /mnt/efi

echo "Create and activate swapfile"
btrfs filesystem mkswapfile --size 4g --uuid clear /mnt/swap/swapfile
swapon /mnt/swap/swapfile

pacstrap -K /mnt base linux linux-lts linux-firmware

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
arch-chroot /mnt pacman --noconfirm --needed -Syu \
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
	inotify-tools \
	iotop \
	jq \
	less \
	man \
	mono \
	mono-msbuild \
	ncdu \
	neovim \
	network-manager-applet \
	networkmanager \
	networkmanager-l2tp strongswan \
	nginx \
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

arch-chroot /mnt sed -i.bak '/^HOOKS=/s/block/block encrypt/' /etc/mkinitcpio.conf
# GENERATE KEY FOR UNLOCKING ROOT
dd bs=512 count=4 if=/dev/random iflag=fullblock | arch-chroot /mnt install -m 0600 /dev/stdin /etc/cryptsetup-keys.d/root.key
arch-chroot /mnt cryptsetup luksAddKey $DEV_ROOT /etc/cryptsetup-keys.d/root.key
arch-chroot /mnt sed -i.bak2 '/^FILES=/s|(.*)|(/etc/cryptsetup-keys.d/root.key)|' /etc/mkinitcpio.conf
arch-chroot /mnt mkinitcpio -P
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
{
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
} | arch-chroot /mnt

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
echo "kernel.sysrq=1" | arch-chroot /mnt tee /etc/sysctl.d/99-sysctl.conf

echo "Configuring ufw rules"
arch-chroot /mnt ufw allow from 192.168.111.0/24 to any app SSH
arch-chroot /mnt ufw allow from 192.168.114.0/24 to any app SSH
echo "Enable ufw? (y/n)"
read enable_ufw
if [ "$enable_ufw" == "y" ]; then
	arch-chroot /mnt ufw enable
fi


arch-chroot /mnt -u $USERNAME git clone https://github.com/killerrat/.dotfiles /home/$USERNAME/.dotfiles
arch-chroot /mnt -u $USERNAME /home/.dotfiles/nvim-lua/.config/nvim/generateHostConfig.sh


echo "Running stow"
arch-chroot /mnt cd /home/$USERNAME/.dotfiles/hosts/arch-agouws && stow -t ~ xinitrc
arch-chroot /mnt mv /etc/lightdm/lightdm-gtk-greeter.conf{,.bak}
arch-chroot /mnt cd /home/$USERNAME/.dotfiles && stow -t / lightdm


arch-chroot /mnt mkdir -p /usr/share/backgrounds/albert
# arch-chroot /mnt chmod o+x /usr/share/backgrounds/albert
arch-chroot /mnt cd /home/$USERNAME/.dotfiles && stow -t /usr/share/backgrounds/albert images
arch-chroot /mnt chmod o+r /usr/share/backgrounds/albert/*
arch-chroot /mnt -u $USERNAME cd /home/$USERNAME/.dotfiles && stow alacritty dmenurc dosbox dunst flameshot fonts gitconfig gtk-2.0 gtk-3.0 gtk-4.0 i3-manjaro nvim-lua oh-my-posh picom ranger tmux zshrc


echo "Configure bat and silicon themes"
arch-chroot /mnt -u $USERNAME mkdir -p "$(bat --config-dir)/themes"
arch-chroot /mnt -u $USERNAME mkdir -p "$(bat --config-dir)/syntaxes"
arch-chroot /mnt -u $USERNAME ln -s /home/$USERNAME/.local/share/nvim/lazy/tokyonight.nvim/extras/sublime/tokyonight_day.tmTheme /home/$USERNAME/.config/bat/themes/tokyonight_day.tmTheme
arch-chroot /mnt -u $USERNAME ln -s /home/$USERNAME/.local/share/nvim/lazy/tokyonight.nvim/extras/sublime/tokyonight_night.tmTheme /home/$USERNAME/.config/bat/themes/tokyonight_night.tmTheme
arch-chroot /mnt -u $USERNAME ln -s /home/$USERNAME/.local/share/nvim/lazy/tokyonight.nvim/extras/sublime/tokyonight_moon.tmTheme /home/$USERNAME/.config/bat/themes/tokyonight_moon.tmTheme
arch-chroot /mnt -u $USERNAME ln -s /home/$USERNAME/.local/share/nvim/lazy/tokyonight.nvim/extras/sublime/tokyonight_storm.tmTheme /home/$USERNAME/.config/bat/themes/tokyonight_storm.tmTheme
arch-chroot /mnt -u $USERNAME bat cache --build
arch-chroot /mnt -u $USERNAME silicon --build-cache


echo "Let's copy our gtk configs to /root, so that root has the same theme"
cp /mnt/home/$USERNAME/.dotfiles/gtk-2.0/.gtkrc-2.0 /mnt/root
mkdir -p /mnt/root/.config
cp -r /mnt/home/$USERNAME/.dotfiles/gtk-3.0/.config/gtk-3.0 /mnt/root/.config
cp -r /mnt/home/$USERNAME/.dotfiles/gtk-4.0/.config/gtk-4.0 /mnt/root/.config


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Installing AUR Packages\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"

mkdir -p /mnt/home/$USERNAME/source-aur

{
	source /home/$USERNAME/.dotfiles/scripts/functions/aur-helpers.sh
	installAurPackage oh-my-posh-bin
	installAurPackage brave-bin

	curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --import
	installAurPackage 1password
	echo Need to make sure gnome-keyring is correctly setup otherwise 2fa keys wont be remembered.

	cp /etc/pam.d/login /tmp/login.tmp
	echo -e "$password" | sudo -v -S
	if [ ! -f /tmp/login.tmp ] # Don't run it again if we have the login.tmp file already
	then
		sudo bash -c "cat > /etc/pam.d/login" << 'EOF'
		#%PAM-1.0
		auth       required     pam_securetty.so
		auth       requisite    pam_nologin.so
		auth       include      system-local-login
		auth       optional     pam_gnome_keyring.so
		account    include      system-local-login
		session    include      system-local-login
		session    optional     pam_gnome_keyring.so auto_start
		password   include      system-local-login
		EOF

	fi
} | arch-chroot /mnt -u $USERNAME

cp /mnt/usr/lib/pam.d/polkit-1 /mnt/etc/pam.d/polkit-1

{
	source /home/$USERNAME/.dotfiles/scripts/functions/aur-helpers.sh
	installAurPackage otf-san-francisco
	installAurPackage otf-san-francisco-mono
	installAurPackage pa-applet-git
	installAurPackage dracula-gtk-theme
	installAurPackage dracula-icons-git
	installAurPackage snapper-gui-git
	installAurPackage netcoredbg
	installAurPackage nvm
	installAurPackage emote # Emoji picker, launch with Ctrl + Alt + E
} | arch-chroot /mnt -u $USERNAME

arch-chroot /mnt pacman -R --noconfirm i3lock

{
	source /home/$USERNAME/.dotfiles/scripts/functions/aur-helpers.sh
	installAurPackage i3lock-color
	installAurPackage i3exit
	installAurPackage betterlockscreen
	betterlockscreen -u ~/.dotfiles/images
} | arch-chroot /mnt -u $USERNAME

arch-chroot /mnt systemctl enable betterlockscreen@$USERNAME
# lock on sleep/suspend


{
	source /usr/share/nvm/init-nvm.sh
	nvm install --lts
	nvm use --lts
	mkdir -p /home/$USERNAME/Pictures/screenshots
} | arch-chroot /mnt -u $USERNAME

arch-chroot /mnt ln -s /home/$USERNAME/.dotfiles/scripts/dmenu_recency /usr/local/bin/dmenu_recency


# TODO: 
# - [ ] GREETER CUSTOMISATION
# - [ ] Continue from cloning dotfiles
# - [ ] YubiKey
