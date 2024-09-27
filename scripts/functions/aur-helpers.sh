installAurPackage() {
	pushd ~/source-aur
	echo "Installing $1"
	if [ ! -d $1 ]; then
		git clone https://aur.archlinux.org/$1.git
		cd $1
	else
		cd $1
		git pull
	fi
	echo -e "$password" | sudo -v -S
	makepkg --noconfirm -is --needed
	popd
}
