#!/bin/bash

# Exit when any command fails
set -e

echo -e "\033[32m ----------------------------------------\033[0m"
echo -e "\033[32m Installing Arch Linux\033[0m"
echo -e "\033[32m ----------------------------------------\033[0m"

echo Setting root password to \"root\"
echo "root" | passwd --stdin # SET A ROOT PASSWORD SO WE CAN SSH IN
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


echo "Are you ready to install? Make sure that you have your new partition mounted in /mnt, AND mounted /mnt/boot"
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
fbset


echo "If running on the MacBook, you need to update mkinitcpio.conf. Do you want to update mkinitcpio.conf? (y/n)"
read update_mkinitcpio
if [ "$update_mkinitcpio" == "y" ]; then
	sed -i.bak '/^HOOKS=(/c\HOOKS=(base keyboard udev autodetect modconf block lvm2 encrypt btrfs filesystems fsck)' /etc/mkinitcpio.conf
	sed -i.bak2 '/^MODULES=(/c\MODULES=(intel_lpss_pci)' /etc/mkinitcpio.conf
	mkinitcpio -P
fi

echo "Set password for root"
passwd

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


# echo "Set up DHCP"
# ip link
# echo "What is your network interface? (e.g. enp0s31f6)"
# read network_interface
# systemctl enable dhcpcd@$network_interface.service
systemctl enable NetworkManager.service
systemctl start NetworkManager.service
echo "If running on the MacBook, you need to set up brcmfmac43602-pcie. Do you want to set up brcmfmac43602-pcie? (y/n)"
read setup_brcmfmac43602_pcie
if [ "$setup_brcmfmac43602_pcie" == "y" ]; then
	cp /home/$username/.dotfiles/hosts/arch-agouwsmacbookpro/brcmfmac43602-pcie.txt /lib/firmware/brcm/.
	cp /home/$username/.dotfiles/hosts/arch-agouwsmacbookpro/brcmfmac43602-pcie.txt /lib/firmware/brcm/brcmfmac43602-pcie.Apple\ Inc.-MacBookPro13,3.txt
fi
systemctl restart NetworkManager.service

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

installAurPackage macbook12-spi-driver-dkms
sudo sed -i.bak3 '/^MODULES=(/c\MODULES=(apple_ib_tb applespi intel_lpss_pci spi_pxa2xx_platform)' /etc/mkinitcpio.conf
sudo mkinitcpio -P
echo 'options apple_ib_tb fnmode=2' | sudo tee /etc/modprobe.d/apple_ib_tb.conf
echo 'options apple_ib_tb idle_timeout=60' | sudo tee /etc/modprobe.d/apple_ib_tb.conf


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
nvim -d /etc/pam.d/login /tmp/login.tmp

installAurPackage i3exit

sudo pacman --noconfirm -S python-antlr4 python-semantic-version python-systemd python-tomlkit python-typeguard python-watchdog refind
installAurPackage python-injector
installAurPackage python-pid
installAurPackage python-transitions
installAurPackage refind-btrfs
installAurPackage gmux_backlight
installAurPackage otf-san-francisco


echo Configure dmenu
sudo ln -s ~/.dotfiles/scripts/dmenu_recency /usr/local/bin/dmenu_recency


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



