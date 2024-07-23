#!/bin/bash

# Exit when any command fails
set -e

echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Installing Arch Linux\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"

echo Setting root password to \"root\"
echo "root" | passwd --stdin # SET A ROOT PASSWORD SO WE CAN SSH IN TEMPOARILY
timedatectl set-ntp true
pacman --noconfirm -Sy archlinux-keyring

echo "Set up partitions and figure out where you're going to install Arch"
exit 1

# lsblk
# cfdisk /dev/nvme0n1
# # MAKE A PARTITION WITH 128MB BETWEEN APPLE AND LINUX PARTITION
# # SET THE TYPE TO LVM
# cryptsetup luksFormat /dev/nvme0n1p4
# cryptsetup luksOpen /dev/nvme0n1p4 lvm

# pvcreate /dev/mapper/lvm
# vgcreate vgcrypt /dev/mapper/lvm

# lvcreate --size 20G --name swap vgcrypt
# lvcreate --extents +100%FREE --name root vgcrypt

# mkswap -L swap /dev/mapper/vgcrypt-swap
# swapon -L swap

# mkfs.btrfs --label system /dev/mapper/vgcrypt-root
# mount -t btrfs LABEL=system /mnt

# btrfs subvolume create /mnt/@
# btrfs subvolume create /mnt/@home
# btrfs subvolume create /mnt/@snapshots
# umount -R /mnt

# mount -t btrfs -o defaults,x-mount.mkdir,compress=zstd,ssd,noatime,subvol=@ LABEL=system /mnt
# mount -t btrfs -o defaults,x-mount.mkdir,compress=zstd,ssd,noatime,subvol=@home LABEL=system /mnt/home
# mount -t btrfs -o defaults,x-mount.mkdir,compress=zstd,ssd,noatime,subvol=@snapshots LABEL=system /mnt/.snapshots

# mkdir -p /mnt/boot
# mount /dev/nvme0n1p1 /mnt/boot

# Now we need to set up the refind.conf file properly with the new partition UUID
# THIS ENTRY WORKS WITH THE FOLLOWING BLKID
#menuentry "Arch Linux Albert" {
#    icon     /EFI/refind/icons/os_arch.png
#    volume   "Arch Linux"
#    loader   /vmlinuz-linux
#    initrd   /initramfs-linux.img
#    #options "cryptdevice=UUID=<luks-part-UUID, e.g. /dev/nvme0n1p5's UUID>:<volume-group, obtained via vgdisplay> root=/dev/mapper/<volume-group>-<logical-volume> rootflags=subvol=@"
#    options "cryptdevice=UUID=d3b198f7-c54d-45ac-8905-94fa12894335:vgcrypt root=/dev/mapper/vgcrypt-root rootflags=subvol=@"
#    submenuentry "Boot using fallback initramfs" {
#        initrd /boot/initramfs-linux-fallback.img
#    }
#}
# blkid
# /dev/mapper/vgcrypt-swap: LABEL="swap" UUID="6b63bb6c-4afd-4591-8788-cf8d73ff1a38" TYPE="swap"
# /dev/nvme0n1p5: UUID="d3b198f7-c54d-45ac-8905-94fa12894335" TYPE="crypto_LUKS" PARTUUID="fd095bbd-a6eb-48da-a55b-1923f7d3193f"
# /dev/nvme0n1p3: LABEL="OSXRESERVED" UUID="64FB-89C7" BLOCK_SIZE="4096" TYPE="exfat" PARTUUID="b46a23c3-50c5-4e19-b8db-463fa216605f"
# /dev/nvme0n1p1: LABEL_FATBOOT="EFI" LABEL="EFI" UUID="5F66-17ED" BLOCK_SIZE="4096" TYPE="vfat" PARTLABEL="EFI System Partition" PARTUUID="92727bbf-942c-400f-a9d4-583cddd43c5e"
# /dev/nvme0n1p4: LABEL="BOOTCAMP" BLOCK_SIZE="4096" UUID="34F5EE1202469FF7" TYPE="ntfs" PARTUUID="27bbceeb-e685-49c9-bb38-18aa662e3593"
# /dev/nvme0n1p2: UUID="40dcefc5-5c37-4bd9-950b-babddf7ba441" BLOCK_SIZE="4096" TYPE="apfs" PARTUUID="ab455abf-29b8-46e0-b56f-06e850648696"
# /dev/mapper/vgcrypt-root: LABEL="system" UUID="6023169f-40ed-40c1-8290-4c9cd481d6d5" UUID_SUB="acdd011b-0779-44c0-b6c4-000852b90405" BLOCK_SIZE="4096" TYPE="btrfs"
# /dev/mapper/vgcrypt: UUID="TvEh9e-pVkM-3Toi-jG9b-Z2p9-heks-Twsz9D" TYPE="LVM2_member"


echo "Are you ready to install? Make sure that you have your new partition mounted in /mnt, AND mounted /mnt/boot (y/n)"
read install_base
if [ "$install_base" == "y" ]; then
	pacstrap -K /mnt base linux linux-firmware neovim
fi

swapon -L swap

echo "Do you want to generate an fstab? (y/n)"
read generate_fstab
if [ "$generate_fstab" == "y" ]; then
	genfstab -p /mnt >> /mnt/etc/fstab
fi

echo "Do you want to add a swap entry to crypttab? (y/n)"
read add_swap
if [ "$add_swap" == "y" ]; then
	echo "swap /dev/mapper/vgcrypt-swap /dev/urandom swap,offset=2048,cipher=aes-xts-plain64,size=256" >> /mnt/etc/crypttab
fi

echo "Make sure your /mnt/etc/fstab looks something like this with crypt tab mapper"
echo UUID=0cc4f593-dcd5-44a2-b4a4-23458b9e4fc9 LABEL=swap
echo /dev/mapper/swap        none            swap            defaults        0 0
echo "Current fstab:"
cat /mnt/etc/fstab


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Jump into the new System\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"
echo "Copying this install file into the new system /install-arch.sh"
cp install-arch.sh /mnt/install-arch.sh
arch-chroot /mnt


echo "Continue script inside the new system"
exit 1


echo "Setting up timezone"
ln -sf /usr/share/zoneinfo/Pacific/Auckland /etc/localtime

echo "Set hardware clock"
hwclock --systohc

echo "Set locale"
sed -i 's/#en_NZ.UTF-8 UTF-8/en_NZ.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
echo "LANG=en_NZ.UTF-8" > /etc/locale.conf

echo "What is your hostname? (e.g. arch-agouwsmacbookpro)"
read hostname
echo "$hostname" > /etc/hostname
echo "127.0.0.1   localhost.localdomain   localhost   $hostname" >> /etc/hosts
echo "::1   localhost.localdomain   localhost   $hostname" >> /etc/hosts

echo "Installing more packages"
pacman --noconfirm -Syu \
networkmanager \
base-devel \
btrfs-progs \
gptfdisk \
neovim \
zsh \
sudo \
sbctl \
polkit \
lvm2 \
dhcpcd \
systemd \
snapper \
snap-pac \
fzf \
ripgrep \
fd \
feh \
network-manager-applet \
tree \
bc \
spotify-launcher \
networkmanager \
base-devel \
btrfs-progs \
gptfdisk \
neovim \
zsh \
sudo \
sbctl \
polkit \
lvm2 \
dhcpcd \
systemd \
openssh \
ranger \
flameshot \
xclip \
gnome-keyring seahorse \
picom \
xorg \
xorg-xinit \
alacritty \
ttf-cascadia-code-nerd \
i3 \
linux-headers \
dmenu \
redshift \
git \
stow \
zoxide \
zip \
unzip \
curl \
wget \
tmux \
rsync \
fbset \
dunst \
bluez bluez-utils blueman \
pcmanfm \
xautolock \
spotify-launcher \
dotnet-sdk \
dotnet-runtime \
aspnet-runtime \
nuget \
mono \
mono-msbuild \
nginx \
docker docker-compose docker-scan \
remmina freerdp \
dosbox \
btop \
networkmanager-l2tp strongswan

# Disabled:
# polkit-gnome # For now, I think I may have installed this to get the 1Password 2FA auth working
# but it's not really needed, I just needed to config seahorse

echo "Starting sshd"
sudo systemctl start sshd
sudo systemctl enable sshd


echo "Starting Bluetooth"
sudo systemctl start bluetooth
sudo systemctl enable bluetooth


echo "If running on the MacBook, you need to update mkinitcpio.conf. Do you want to update mkinitcpio.conf? (y/n)"
read update_mkinitcpio
if [ "$update_mkinitcpio" == "y" ]; then
	sed -i.bak '/^HOOKS=(/c\HOOKS=(base keyboard udev autodetect modconf block lvm2 encrypt btrfs filesystems fsck)' /etc/mkinitcpio.conf
	sed -i.bak2 '/^MODULES=(/c\MODULES=(intel_lpss_pci)' /etc/mkinitcpio.conf
	mkinitcpio -P
fi

echo "Set password for root"
passwd

echo "Reboot now, and continue the script from the new system as root"
exit 1


echo "Starting NetworkManager"
sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service

echo "Set up user"
echo "What is your username? (e.g. albert)"
read username
useradd -m -G wheel,storage,power -g users -s /bin/zsh $username
passwd $username

echo "Set up sudoers"
sed -i.bak 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /etc/sudoers

echo "Cloning dotfiles"
pushd /home/$username
git clone https://github.com/killerrat/.dotfiles
popd


echo "From here, run as the user in the new system"
exit 1

echo "Running stow"
pushd ~/.dotfiles/hosts/arch-agouwsmacbookpro
stow -t ~ xinitrc
popd

pushd ~/.dotfiles
stow alacritty dmenurc dosbox dunst flameshot fonts gitconfig gtk-2.0 gtk-3.0 gtk-4.0 i3-manjaro nvim-lua oh-my-posh picom ranger tmux zshrc
popd


echo "Generate host specific configs"
~/.dotfiles/nvim-lua/.config/nvim/generateHostConfig.sh


echo "Let's copy our gtk configs to /root, so that root has the same theme"
sudo cp /home/albert/.dotfiles/gtk-2.0/.gtkrc-2.0 /root
sudo mkdir -p /root/.config
sudo cp -r /home/albert/.dotfiles/gtk-3.0/.config/gtk-3.0 /root/.config
sudo cp -r /home/albert/.dotfiles/gtk-4.0/.config/gtk-4.0 /root/.config


sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service
echo "If running on the MacBook, you need to set up brcmfmac43602-pcie. Do you want to set up brcmfmac43602-pcie? (y/n)"
read setup_brcmfmac43602_pcie
if [ "$setup_brcmfmac43602_pcie" == "y" ]; then
	sudo cp /home/$USER/.dotfiles/hosts/arch-agouwsmacbookpro/brcmfmac43602-pcie.txt /lib/firmware/brcm/.
	sudo cp /home/$USER/.dotfiles/hosts/arch-agouwsmacbookpro/brcmfmac43602-pcie.txt /lib/firmware/brcm/brcmfmac43602-pcie.Apple\ Inc.-MacBookPro13,3.txt
fi
sudo systemctl restart NetworkManager.service


echo "From here, run as the user in X"
exit 1


echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Installing AUR Packages\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"

mkdir ~/source-aur

installAurPackage() {
	pushd ~/source-aur
	echo "Installing $1"
	git clone https://aur.archlinux.org/$1.git
	cd $1
	makepkg --noconfirm -is
	popd
}

installAurPackage oh-my-posh
installAurPackage brave-bin

echo "If running on the MacBook, you probably want to install macbook12-spi-driver-dkms. Also swap fn and ctrl, and permanently make the F keys display on the touchbar. Do you want to do this? (y/n)"
read update_mkinitcpio_fnremap
if [ "$update_mkinitcpio_fnremap" == "y" ]; then
	installAurPackage macbook12-spi-driver-dkms
	sudo sed -i.bak3 '/^MODULES=(/c\MODULES=(apple_ib_tb applespi intel_lpss_pci spi_pxa2xx_platform)' /etc/mkinitcpio.conf
	echo 'options apple_ib_tb fnmode=2' | sudo tee /etc/modprobe.d/apple_ib_tb.conf
	echo 'options apple_ib_tb idle_timeout=60' | sudo tee --append /etc/modprobe.d/apple_ib_tb.conf
	echo 'options applespi fnremap=1' | sudo tee /etc/modprobe.d/applespi.conf
	sudo mkinitcpio -P
fi


echo "Set up seahorse and create a default keyring. This is needed for 1Password otherwise it keeps asking the 2FA prompt again and again."
# FROM: https://1password.community/discussion/127523/1password-and-gnome-keyring-for-2fa-saving-on-archlinux
seahorse


curl -sS https://downloads.1password.com/linux/keys/1password.asc | gpg --import
installAurPackage 1password
echo Need to make sure gnome-keyring is correctly setup otherwise 2fa keys wont be remembered.

cp /etc/pam.d/login /tmp/login.tmp
sudo bash -c "cat > /etc/pam.d/login" << 'EOF'
#%PAM-1.0
auth       required     pam_securetty.so
auth       requisite    pam_nologin.so
auth       include      system-local-login
auth       optional     pam_gnome_keyring.so # ADD THIS LINE AT END OF AUTH
account    include      system-local-login
session    include      system-local-login
session    optional     pam_gnome_keyring.so auto_start # ADD THIS LINE AT END OF SESSION
password   include      system-local-login
EOF

read -p "Let's verify the changes. Press enter to continue"
sudo nvim -d /etc/pam.d/login /tmp/login.tmp

installAurPackage i3exit

sudo pacman --noconfirm -S python-antlr4 python-semantic-version python-systemd python-tomlkit python-typeguard python-watchdog refind
installAurPackage python-injector
installAurPackage python-pid
installAurPackage python-transitions
installAurPackage refind-btrfs
installAurPackage refind-theme-dracula
installAurPackage gmux_backlight
installAurPackage otf-san-francisco
installAurPackage otf-san-francisco-mono
installAurPackage pa-applet-git
installAurPackage dracula-gtk-theme
installAurPackage dracula-icons-git
installAurPackage azuredatastudio-bin
installAurPackage snapper-gui-git
# installAurPackage forticlient-vpn
# sudo pacman -S networkmanager-fortisslvpn
installAurPackage openfortivpn

installAurPackage nvm
source /usr/share/nvm/init-nvm.sh
nvm install --lts
nvm use --lts


echo "If running on the MacBook, you need to install snd_hda_macbookpro. Do you want to do this? (y/n)"
read snd_hda_macbookpro
if [ "$snd_hda_macbookpro" == "y" ]; then
	pushd ~/source-aur
	git clone https://github.com/davidjo/snd_hda_macbookpro.git
	cd snd_hda_macbookpro/
	#run the following command as root or with sudo
	sudo ./install.cirrus.driver.sh
	echo "You need to reboot after doing the Sound Install. Do you want to reboot? (y/n)"
	read reboot
	if [ "$reboot" == "y" ]; then
		sudo reboot now
	fi
fi
sudo pacman -S wireplumber pipewire-pulse pulseaudio pavucontrol playerctl
popd


echo Configure dmenu
sudo ln -s ~/.dotfiles/scripts/dmenu_recency /usr/local/bin/dmenu_recency


echo "Enable and start Docker? (y/n)"
read enable_docker
if [ "$enable_docker" == "y" ]; then
	sudo systemctl enable docker
	sudo systemctl start docker
fi

echo "Sort out the terminal TTY screen buffer size"
sudo cp ~/.dotfiles/hosts/arch-agouwsmacbookpro/etc/systemd/system/set-display-resolution.service /etc/systemd/system/set-display-resolution.service
sudo systemctl enable set-display-resolution.service
sudo systemctl start set-display-resolution.service

# sudo cp ~/.dotfiles/hosts/arch-agouwsmacbookpro/etc/systemd/system/disable-dgpu.service /etc/systemd/system/disable-dgpu.service
# sudo systemctl enable disable-dgpu.service
# sudo systemctl start disable-dgpu.service

echo Configure graphics to use Intel only
echo "blacklist amdgpu" | sudo tee /etc/modprobe.d/blacklist-amdgpu.conf
pushd ~/source-aur
git clone https://github.com/0xbb/gpu-switch
cd gpu-switch
sudo ./gpu-switch -i
echo "You need to reboot after doing the Graphics Config to blacklist AMD GPU. Do you want to reboot? (y/n)"
read reboot
if [ "$reboot" == "y" ]; then
	sudo reboot now
fi
popd



