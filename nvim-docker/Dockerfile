# FROM manjarolinux/base AS base
FROM archlinux AS base

RUN echo "Configuring pacman" \
sed -i 's/#Color/Color/g' /etc/pacman.conf \
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/g' /etc/pacman.conf

RUN pacman -Syu --noconfirm

RUN pacman -S --noconfirm \
	aws-cli \
	bat btop \
	clang cmake curl \
	dnsutils dotnet-sdk \
	fakeroot fd fzf \
	gcc git \
	jq \
	less \
	make mono mono-msbuild \
	ncdu neovim nginx nuget \
	openssh \
	python-pip \
	ranger ripgrep \
	sshfs stow sudo \
	tmux \
	unzip upterm \
	vim \
	wget \
	xclip \
	yq \
	zip zoxide zsh


RUN echo "Configuring makepkg" && \
sed -i 's/^PKGEXT.*/PKGEXT=".pkg.tar"/' /etc/makepkg.conf && \
sed -i 's/\(OPTIONS=.*\)debug/\1!debug/' /etc/makepkg.conf


WORKDIR /root/
RUN echo -e "\033[32m Clone KiLLeRRaT dotfiles\033[0m" && \
	git clone https://github.com/KiLLeRRaT/.dotfiles
WORKDIR /root/.dotfiles
# RUN ls -lkha


# SET UNICODE LOCALE
RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'


#SET PASSWORD FOR ROOT
# RUN echo 'root:Docker!' | chpasswd


# RUN echo echo -e "\034[32m Configure SSH Keys\033[0m" && \
# 	ssh-keygen -t ed25519 -C "$(echo $HOST)@docker" -f /root/.ssh/id_ed25519

ARG GIT_EMAIL
ARG GIT_NAME

# RUN echo "GIT_EMAIL: $GIT_EMAIL"
# RUN echo "GIT_NAME: $GIT_NAME"

RUN echo -e "\033[32m Configure Git\033[0m" && \
	git config --global user.email "$GIT_EMAIL" && \
	git config --global user.name "$GIT_NAME" && \
	git config --global alias.logo "log --pretty=tformat:'%C(auto,red)%m %C(auto,yellow)%h%C(auto,magenta) %G? %C(auto,blue)%>(12,trunc)%ad %C(auto,green)%<(15,trunc)%aN%C(auto,reset)%s%C(auto,red) %gD %D' --date=short" && \
	git config --global alias.adog "log --all --decorate --oneline --graph" && \
	git config --global alias.dog "log --decorate --oneline --graph" && \
	git config --global pull.rebase true && \
	git config --global submodule.recurse true  && \
	git config --global core.editor "nvim" && \
	git config --global core.excludesfile ~/.gitignore && \
	git config --global core.autocrlf input && \
	git config --global init.defaultBranch master && \
	git config --global rerere.enabled true && \
	git config --global merge.tool nvim && \
	git config --global merge.conflictstyle diff3 && \
	git config --global mergetool.nvim.cmd "nvim -d $LOCAL $BASE $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'" && \
	# echo "$(git config --get user.email) namespaces=\"git\" $(cat /root/.ssh/id_ed25519.pub)" > /root/.ssh/allowed_signers && \
	git config --global gpg.ssh.allowedSignersFile /root/.ssh/allowed_signers

# RUN cat /root/.ssh/allowed_signers && echo " XYZ" && ls /root/.ssh/ && cat /root/.ssh/id_ed25519.pub

	# WE DON'T WANT TO STOW GITCONFIG IN HERE! IT'S ALBERT's OWN GITCONFIG!
	# rm /root/.gitconfig && stow gitconfig && \
WORKDIR /root/.dotfiles
RUN echo -e "\033[32m Run Stow\033[0m" && \
	stow bashrc && \
	stow fonts && \
	stow nvim-lua && \
	stow oh-my-posh && \
	stow ranger && \
	stow ssh && \
	stow tmux && \
	stow zshrc


RUN echo -e "\033[32m Change Default Shell\033[0m" && \
	chsh -s /bin/zsh root


# This is not yet there, until we run nvim for the first time...
# RUN cd /root/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim && make
# RUN cd /root/.local/share/nvim/lazy/telescope-fzf-native.nvim && make

RUN useradd builduser -m # Create the builduser
RUN passwd -d builduser # Delete the buildusers password
RUN printf 'builduser ALL=(ALL) ALL\n' | tee -a /etc/sudoers # Allow the builduser passwordless sudo

RUN echo -e "\033[32m Install oh-my-posh\033[0m" && \
	sudo -u builduser bash -c 'cd ~ && git clone https://aur.archlinux.org/oh-my-posh oh-my-posh && cd oh-my-posh && makepkg -is --noconfirm' # Clone and build a package

RUN echo -e "\033[32m Install NVM\033[0m" && \
	sudo -u builduser bash -c 'cd ~ && git clone https://aur.archlinux.org/nvm nvm && cd nvm && makepkg -is --noconfirm' # Clone and build a package

RUN echo -e "\033[32m Clone zsh-vi-mode\033[0m" && \
	git clone https://github.com/jeffreytse/zsh-vi-mode.git $HOME/.zsh-vi-mode


RUN echo -e "\033[32m Nuget credential provider for .NET Core Azure DevOps\033[0m" && \
	wget -qO- https://aka.ms/install-artifacts-credprovider.sh | bash
RUN echo -e "\033[32m Nuget credential provider for .NET Framework Azure DevOps\033[0m" && \
	if ! curl -H "Accept: application/octet-stream" -s -S -L "https://github.com/microsoft/artifacts-credprovider/releases/download/v1.0.0/Microsoft.NuGet.CredentialProvider.tar.gz" | tar xz -C "$HOME/.nuget/" "plugins/netfx"; then exit 1 ; fi


RUN echo -e "\033[32m Make norg dummy directories\033[0m" && \
mkdir -p /root/notes/neorg/work && \
	touch /root/notes/neorg/work/inbox.norg && \
	touch /root/notes/neorg/work/index.norg


# THIS IS WHERE WE WILL MOUNT OUR HOST PROJECT VOLUME
RUN mkdir -p /mnt/c/Projects.Git


# Avoid container exit.
CMD ["tail", "-f", "/dev/null"]
