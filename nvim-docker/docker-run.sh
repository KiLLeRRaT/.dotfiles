#!/bin/zsh

sudo docker run -d \
	--name nvim-docker \
	-v ~/source:/root/source \
	-v ~/notes:/root/notes \
	-v ~/.dotfiles:/root/.dotfiles-phy \
	dockerregistry-ro.gouws.org/nvim-docker:latest
