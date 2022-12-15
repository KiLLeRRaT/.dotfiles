FROM manjarolinux/base AS base

# YOU SERIOUSLY CAN USE PACMAN INSTEAD OF PAMAC DUDE!
# RUN pacman -Syu pamac-cli --noconfirm

RUN pacman -Syu

RUN pacman -S --noconfirm git \
	wget \
	curl \
	stow \
	neovim \
	xclip \
	ripgrep \
	fd \
	tmux \
	btop \
	unzip \
	zip \
	zoxide \
	python-pip \
	aws-cli \
	dnsutils \
	sshfs \
	vifm \
	ranger \
	nuget \
	mono \
	mono-msbuild \
	dotnet-sdk \
	jq \
	zsh \
	gcc \
	make \
	openssh \
	upterm \
	fzf


WORKDIR /root
RUN echo -e "\033[32m Install oh-my-posh\033[0m" && \
	wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh && \
	chmod +x /usr/local/bin/oh-my-posh


RUN echo -e "\033[32m Install NVM\033[0m" && \
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash && \
    . /root/.nvm/nvm.sh && \
    nvm install 16.16.0


RUN echo -e "\033[32m Clone zsh-vi-mode\033[0m" && \
	git clone https://github.com/jeffreytse/zsh-vi-mode.git $HOME/.zsh-vi-mode


RUN echo -e "\033[32m Clone KiLLeRRaT dotfiles\033[0m" && \
	git clone https://github.com/KiLLeRRaT/.dotfiles
WORKDIR /root/.dotfiles
# RUN ls -lkha


# SET UNICODE LOCALE
RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'


#SET PASSWORD FOR ROOT
# RUN echo 'root:Docker!' | chpasswd


RUN echo echo -e "\033[32m Configure SSH Keys\033[0m" && \
	ssh-keygen -t ed25519 -C "albert@docker" -f /root/.ssh/id_ed25519


RUN echo -e "\033[32m Configure Git\033[0m" && \
	git config --global user.email albert@gouws.org && \
	git config --global user.name Albert Gouws && \
	git config --global alias.logo "log --pretty=tformat:'%C(auto,red)%m %C(auto,yellow)%h%C(auto,magenta) %G? %C(auto,blue)%>(12,trunc)%ad %C(auto,green)%<(15,trunc)%aN%C(auto,reset)%s%C(auto,red) %gD %D' --date=short" && \
	git config --global pull.rebase true && \
	git config --global submodule.recurse true && \
	git config --global core.editor "nvim" && \
	git config --global core.excludesfile ~/.gitignore && \
	git config --global init.defaultBranch master


	# WE DON'T WANT TO STOW GITCONFIG IN HERE! IT'S ALBERT's OWN GITCONFIG!
	# rm /root/.gitconfig && stow gitconfig && \
WORKDIR /root/.dotfiles
RUN echo -e "\033[32m Run Stow\033[0m" && \
	stow bashrc && \
	stow fonts && \
	stow nvim-lua && \
	stow oh-my-posh && \
	stow tmux && \
	stow zshrc


RUN echo -e "\033[32m Change Default Shell\033[0m" && \
	chsh -s /bin/zsh root


# RUN nvim --headless +PackerSync +qall

RUN echo -e "\033[32m PackerSync, to install Packer\033[0m" && \
	nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'


RUN echo -e "\033[32m PackerSync, to install the plugins\033[0m" && \
	nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'


# RUN cd /root/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim && make


RUN echo -e "\033[32m Nuget credential provider for Azure DevOps\033[0m" && \
	wget -qO- https://aka.ms/install-artifacts-credprovider.sh | bash


RUN echo -e "\033[32m Make norg dummy directories\033[0m" && \
mkdir -p /root/GBox/Notes/neorg/work && \
	touch /root/GBox/Notes/neorg/work/inbox.norg && \
	touch /root/GBox/Notes/neorg/work/index.norg

# THIS IS WHERE WE WILL MOUNT OUR HOST PROJECT VOLUME
RUN mkdir -p /mnt/c/Projects.Git

# Avoid container exit.
CMD ["tail", "-f", "/dev/null"]
