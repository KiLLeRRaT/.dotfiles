#!/bin/bash

read -p "Use read-only (public) registry? (n to use local built image) [y/N]: " useReadOnlyRegistry
useReadOnlyRegistry=${useReadOnlyRegistry:-N}
if [ "$useReadOnlyRegistry" == "Y" ] || [ "$useReadOnlyRegistry" == "y" ]; then
	dockerRegistry="dockerregistry-ro.gouws.org"
else
	dockerRegistry="dockerregistry.gouws.org"
fi

sudo docker run -d \
	--name nvim-docker \
	-e TZ=Pacific/Auckland \
	-v ~/source:/root/source \
	-v ~/notes:/root/notes \
	-v ~/.dotfiles:/root/.dotfiles-phy \
	$dockerRegistry/nvim-docker:latest
