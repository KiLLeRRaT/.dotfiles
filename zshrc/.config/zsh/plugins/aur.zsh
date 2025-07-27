aur() {
	command=$1
	# command can be install <PACKAGE>, update build, or update install
	if [ $command = "install" ]; then
		aur-install $2
	elif [ $command = "update" ]; then
		if [ $2 = "build" ]; then
			aur-update-build-outdated
		elif [ $2 = "install" ]; then
			aur-update-install-outdated
		else
			echo "Invalid command, commands are: build|install"
		fi
	else
		echo "Invalid command, commands are: install <AUR_PACKAGE>|update (build|install)"
	fi
}

aur-install() {
	pushd -q ~/source-aur
	echo "Installing $1"
	if [ ! -d $1 ]; then
		git clone https://aur.archlinux.org/$1.git
		cd $1
	else
		cd $1
		git pull
	fi
	makepkg --noconfirm -is --needed --clean
	popd -q
}

aur-update-build-outdated() {
	pushd -q ~/source-aur

	touch /tmp/aur-update-packages.txt

	gfr |\
		grep behind |\
		cut -d':' -f1 |\
		sed 's|^\./||' |\
		sort |\
		fzf --header="Select packages to upgrade" --multi |\
		sed 's/$/:/' \
	>> /tmp/aur-update-packages.txt

	while read packageLine; do
		package=$(echo $packageLine | cut -d':' -f1)
		built=$(echo $packageLine | grep ":built")

		echo "Checking $package"

		if [ -z "$built" ]; then
		echo "Building $package"
			pushd -q $package
			git rebase
			makepkg -s --clean
			sed -i "s/$package:/$package:built/" /tmp/aur-update-packages.txt
			popd -q
		fi
	done < /tmp/aur-update-packages.txt

	popd -q
}

aur-update-install-outdated() {
	pushd -q ~/source-aur

	echo "Installing the following packages:"
	cat /tmp/aur-update-packages.txt | grep ":built" | cut -d':' -f1

	PKGS=()
	while read packageLine; do
		package=$(echo $packageLine | cut -d':' -f1)
		built=$(echo $packageLine | grep ":built")
		installed=$(echo $packageLine | grep ":installed")

		if [ -z "$built" ]; then
			echo "Package not built yet, skipping"
			continue
		fi

		if [ -z "$installed" ]; then
			echo "Installing $package"
			pushd -q $package
			packageFile=$(ls -dt $PWD/$package-*.pkg.tar | head -1)
			echo "Package file: $packageFile"
			# sudo pacman -U --needed --noconfirm $packageFile
			PKGS+=("$packageFile")
			sed -i "s/$package:built/$package:built:installed/" /tmp/aur-update-packages.txt
			popd -q
		else
			echo "Package already installed, skipping"
		fi
	done < /tmp/aur-update-packages.txt

	sudo pacman -U --needed --noconfirm "${PKGS[@]}"

	echo "Successfully installed all packages, do you want to clear the list of packages? [y/N]"
	read -sq "REPLY? " && rm /tmp/aur-update-packages.txt

	popd -q
}

