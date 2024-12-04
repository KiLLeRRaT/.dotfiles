set -o noclobber
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#		source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
# export ZSH="/Users/albert/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
# ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# CASE INSENSITIVE COMPLETION
# FROM: https://stackoverflow.com/a/69014927/182888
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit

# autoload bashcompinit && bashcompinit
# if [ -f /usr/bin/aws_completer ]
# then
#		# FROM: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-completion.html
#		complete -C '/usr/bin/aws_completer' aws
# fi


# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

# Enabled on 18 Nov 2022 again on Linux to see if I get more out of zsh completion....)
# plugins=(git zsh-autosuggestions)

# source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#		export EDITOR='vim'
# else
#		export EDITOR='mvim'
# fi
export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000

# export EDITOR="/usr/local/bin/nvim"
export EDITOR="/usr/bin/nvim"
export VISUAL=$EDITOR
export PATH="/home/albert/.ebcli-virtual-env/executables:$PATH"
# export NOW=$(date +"%m-%d-%Y")
export NOW=$(date +"%Y-%m-%d")
export NOWT=$(date +"%Y%m%d%H%M%S")


# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# if command -v pyenv 1>/dev/null 2>&1; then
#		eval "$(pyenv init -)"
# fi

# COLORS
GREEN="\033[0;32m"
RED="\033[0;31m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
MAGENTA="\033[0;35m"
RESET="\033[0m"

oh-my-posh-agnoster() {
	eval "$(oh-my-posh init zsh --config ~/.omp/themes/agnoster.minimal.omp.json)"
}

oh-my-posh-tokyonight() {
	eval "$(oh-my-posh init zsh --config ~/.omp/themes/tokyonight.omp.yaml)"
}

if [[ $TERM_PROGRAM != "Apple_Terminal" ]]; then
	if command -v oh-my-posh &> /dev/null
	then
		oh-my-posh-tokyonight
		# eval "$(oh-my-posh init zsh --config ~/.omp/themes/tokyonight.omp.yaml)"
	fi
fi

# if [[ $TERM_PROGRAM != "Apple_Terminal" ]]; then
#		if { [ -n "$TMUX" ]; } then
#			echo in tmux
#		fi
#		if [[ -n $DISPLAY ]];
#		then
#			if command -v oh-my-posh &> /dev/null
#			then
#				eval "$(oh-my-posh init zsh --config ~/.omp/themes/tokyonight.omp.yaml)"
#			fi
#		else
#			echo "in a tty, don't init oh-my-posh"
#		fi
# fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"	# This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"	# This loads nvm bash_completion

# alias ls='ls -lkh --color=auto' # THIS WAS PREVENTING ME FROM GETTING A LISTING WITH JUST THE FILENAMES!

# color always so that if we pipe to grep, it will be colored
alias ls='ls --color=auto' # TRY THIS AGAIN FOR NOW TO SEE IF IT WORKS, SINCE IT SHOULD SORT OUT WHEN PIPING TO ANOTHER COMMAND...
# alias ls='ls --color=always' # THIS GIVES DRAMA SINCE THE COLOR CODES ARE PART OF THE RESULTS WHEN PIPING TO ANOTHER COMMAND...
alias ll="ls -alkhF"
alias l="ls -1"
alias ncdu="ncdu --color dark"

lst() {
	# echo $@
	# echo $(shift $@)
	# n=$1
	# if [ -z $1 ];then n="cat"; else n="head $1";fi
	# ls -t --color=always | eval $n
	ls -1 -t --color=always
}

llst() {
	# n=$1
	# if [ -z $1 ];then n="cat"; else n="head $1";fi
	# ll -t --color=always | eval $n
	ll -t --color=always
}

alias tmux='tmux -2'
alias grep='grep --color=auto'
alias rl='source ~/.zshrc'
alias df='df -h'
alias xclip='xclip -selection clipboard'

alias db='dotnet build'
alias xc='xclip -se c'

alias gs='git status'
alias gf='git fetch'
alias gl='git pull'
alias gp='git push'
alias gpt='git push --tags'
alias gP='git push --force-with-lease'
alias ga='git add'
alias gcam='git commit -am'
alias gd='git diff'
alias gw='git diff --word-diff'
setopt interactive_comments
preexec(){ _lc=$1; }
alias gcm='git commit -m "${_lc#gcm }" #'
alias glog='git logo'
alias gdog='git dog'
alias gadog='git adog'
alias gb='git branch'
alias gr='git rebase'
alias gba='git branch --all'
alias gco='git checkout'
alias gm='git merge'
alias gt='git tag | sort -V | tail'
alias gcd="cd $(git rev-parse --show-toplevel)"

gfr() {
	fd -t d --max-depth=1 -x \
		bash -c "pushd {} &> /dev/null;git fetch;git status | (echo -n ""{}: "";sed '/Your branch/!d');popd &> /dev/null"
}
# alias gtp='fn-gtp() { git tag $1 && git push --tags };fn-gtp'
gtp() { git tag $1 && git push --tags }
# alias gtD='fn-gt() { git tag -d $1 && git push origin -d $1 };fn-gt'
gtD() { git tag -d $1;git push origin -d $1 }
# GIT TAG REMOVE
# gtr(){git tag -d $1 && git push origin -d $1}
#; fn_gtr 3.4.0



	# cmd=$(remmina -c $(ls $PWD/* | fzf -e --select-1 --no-sort --query "$1"))
	# cmd1=$(lssh | fzf --select-1 --query "$1" --height=~50 | cut -f 2)


# alias nvim-lua='export XDG_CONFIG_HOME=${HOME}/.dotfiles/nvim-lua/.config; \
#		export XDG_DATA_HOME=${HOME}/.local-lua/share; \
#		nvim'

alias n='nvim'
alias nt='nvim $(TMPDIR=~/tmp/scratchpads mktemp -u)'

# DOESNT MAKE IT EASIER, BUT IF YOU FORGET THE COMMAND, YOU TYPE ss AND PRESS TAB TO GET THE COMPLETION :)
alias ss-tulpn='ss -tulpn'

alias setxkbmap-ctrl-caps='setxkbmap -option ctrl:nocaps'
alias setxkbmap-alt-win='setxkbmap -option altwin:swap_lalt_lwin'
alias setxkbmap-revert="setxkbmap -option ''"

# FROM: https://linuxreviews.org/HOWTO_use_the_numeric_keyboard_keys_as_mouse_in_XOrg
# to use the mouse, press /*- to select which button you want to use, and press 5 or + to actually click
# that button. 0 to hold, and . to release.
# if you want double click you need to tap / twice, or three times for a triple click.	When you
# then press 5 it clicks that many times.
alias setxkbmap-keypad-pointerkeys="echo 'Enable numlock using shift+numlock, or ctrl+shift+numlock' && \
	setxkbmap -option keypad:pointerkeys"

atail() { tail -f ---disable-inotify "$@"; }
alias atail-t='tail -f -n +1 ---disable-inotify $(ls -t | head -1)'
alias sdc='sudo docker compose'

# find files matching the name, then sort them by last modified
fd-t() {
	fd -t f $1 --exec stat --printf='%Y\t%n\n' | sort -nr
}

# # find files matching the glob, then sort them by last modified
# fd-tg() {
#		fd -t f -g $1 --exec stat --printf='%Y\t%n\n' | sort -nr
# }

# find most recently modified file matching the name, then open it in nvim, 
# mnemonically neovim-time
alias n-t="fd-t | cut -f2 | head -1 | xargs --no-run-if-empty -d'\n' nvim"

# LIST PATHS OF OTHER ZSH SHELLS I HAVE OPEN
lssh() {
	ps au \
		| awk '$11 == "-zsh" || $11 == "/bin/zsh" { print $2 }' \
		| xargs --no-run-if-empty pwdx \
		| awk '{ print $2 }' \
		| sed -n "\|^${2}.*|p" \
		| sort -u \
		| nl
}

# CD TO SHELL NUMBER RETURNED BY LSSH
cdsh() {
	cd $(lssh \
		| sed "$1!d" \
		| cut -f 2)
}

# CD TO PATH OF ANOTHER SHELL, USING FZF AS SELECTOR
cs() {
	# I swear this worked before, but not anymore, it just returns a blank cmd
	# cmd=$(cd $(lssh | fzf --select-1 --query "$1" --height=~50 | cut -f 2))
	cmd1=$(lssh | fzf --select-1 --query "$1" --height=~50 | cut -f 2)
	cmd="cd $cmd1"
	print -S $cmd
	eval $cmd
}

# FROM: /u/xkcd__386
# anc() {
#		cmd=cat
#		[[ $1 == -r ]] && { cmd=tac; shift; }
#		occ=1
#		[[ $2 =~ ^[0-9]+$ ]] && occ=$2
#		p=$PWD
#		cd $(
#			while [[ $p != $HOME ]]; do
#				p=${p%/*}
#				echo $p
#			done | grep -E "$1[^/]*$" | $cmd | sed -ne "${occ}p"
#		)
# }
cdu() {
		p=$PWD
		cd $(
				while [[ $p != $HOME ]]; do
						p=${p%/*}
						echo $p
				# done | grep -E "$1[^/]*$" | fzf -q "$1" +m -1 || echo $PWD
				# done | grep -E "$1[^/]*$" | fzf -q "$1" +m -1 --preview 'ls -lkha --color=always {}' || echo $PWD
				done | grep -E "$1[^/]*$" | fzf -q "$1" +m -1 \
					--preview 'ls -lkha --color=always {}' \
					--preview-window up,80% \
					--bind pgup:preview-half-page-up,pgdn:preview-half-page-down \
					|| echo $PWD
		)
}


# fzf git checkout
fgco() {
	git branch --all --sort=-committerdate |\
		fzf --height=~50 -e --select-1 --no-sort --query "$1" |\
		sed 's/remotes\/origin\///' |\
		xargs --no-run-if-empty git checkout
}

# KILL USING FZF AS SELECTOR
fkk() {
	sig=$1
	cmd=$(ps -aux | sort -nr | fzf --multi -e --select-1 --no-sort --query "$2" )
	echo Killing the following:
	echo $cmd
	for pid in $(echo $cmd | awk '{ print $2 }')
	do
		if [ $sig -eq 9 ]
		then
			# echo "Killing $pid with -9"
			kill -9 $pid
		else
			# echo "Killing $pid with -15"
			kill -15 $pid
		fi
	done
}
# KILL USING FZF AS SELECTOR
fk9() {
	fkk 9 $1
}
# KILL USING FZF AS SELECTOR
fk() {
	fkk 15 $1
}

# RUN THE COMMAND FROM HISTORY, USING FZF AS SELECTOR
fh() {
	cmd=$(history 0 | sort -nr | cut -c 8- | fzf -e --select-1 --no-sort --query "$1" )
	# push the command into the history
	print -S $cmd
	echo $cmd
	read -q "REPLY?Run command? "
	[[ "$REPLY" == "y" ]] && echo "" && eval $cmd
}

# REMMINA USING THE CONNECTION FILE SELECTED USING FZF
fr() {
	pushd -q ~/.local/share/remmina
	subcmd=$(ls $PWD/* | fzf --ignore-case -e --select-1 --no-sort --query "$1")
	cmd="remmina -c '"$subcmd"'"
	# push the command into the history
	print -S $cmd
	eval $cmd > /dev/null 2>&1 &
	disown
	popd -q
}

# fzf time zone time
alias ftz='TZ=$(timedatectl list-timezones | fzf) date'

# fzf CBM bookmarks
fcbm() {
	pushd -q ~/scripts/Sandfield # We want to do this because there are other files we need in this location
	./CBM-CentralBookmarksManager-export-textfiles.sh "$1"
	popd -q
}
# alias fcbm='pushd ~/scripts/Sandfield > /dev/null 2>&1; ./CBM-CentralBookmarksManager-export-textfiles.sh; popd -q

# SUPERCEDED BY USING nvim **<tab> instead
# fn() {
# 	local results=$(fzf --multi --preview 'bat --color=always {}')
# 	[ -z $results ] && return
# 	echo "$results"
# 	echo "$results" | xargs --no-run-if-empty -d'\n' nvim
# }

# fzf i3 key binds, and run the command
fi3() {
	cmd=$(sed '/^bindsym/!d' ~/.config/i3/config | fzf --query "$1" --select-1)
	cmd=$(cut -f 3- -d' ' <<< $cmd)
	i3-msg $cmd > /dev/null
}

# FZF to lsblk, then mount it to a mount point, echo the command to let the user edit it and then
# run it
fm() {
	# cmd=$(history 0 | sort -nr | cut -c 8- | fzf -e --select-1 --no-sort --query "$1" )
	device=/dev/$(lsblk --filter 'TYPE == "part"' | fzf --header-lines=1 --query "$1" --select-1 --no-sort | awk '{ print $1 }')
	# push the command into the history
	# print -S $cmd
	# echo $cmd
	# read -q "REPLY?Run command? "
	# [[ "$REPLY" == "y" ]] && eval $cmd

	default=/run/media/usb
	echo "Please enter the mount point [$default]: "
	read input
	MOUNTPOINT=${input:-$default}

	if ( ! [ -d $MOUNTPOINT ] )
	then
		echo "Mount point $MOUNTPOINT does not exist, create it? (y/n)"
		read -q "REPLY? "
		[[ "$REPLY" == "y" ]] && sudo mkdir -p $MOUNTPOINT
	fi

	echo "Mounting $device to $MOUNTPOINT"
	cmd="sudo mount $device $MOUNTPOINT"
	print -S $cmd
	eval $cmd
}


vmGetDomain() {
	sudo virsh list --all | tail -n +3 | fzf --select-1 --query "$1" --height=~50 | awk '{ print $2 }'
}
# START THE SELECTED VM
vms() {
	domain=$(vmGetDomain $1)
	cmd="sudo virsh start $domain"
	# push the command into the history
	print -S $cmd
	echo $cmd
	eval $cmd
	# Ask if you want to do vmscreenshot
	# read -q "REPLY?Take screenshot? (y/n)"
	# [[ "$REPLY" == "y" ]] && vmscreenshot $1
	vmscreenshot $1
}

# CONNECT TO THE SELECTED VM
vmc() {
	domain=$(vmGetDomain $1)
	cmd="sudo virt-manager --connect qemu:///system --show-domain-console $domain"
	# push the command into the history
	print -S $cmd
	echo $cmd
	eval $cmd
	# read -q "REPLY?Run command? "
	# [[ "$REPLY" == "y" ]] && eval $cmd
}

# SCREENSHOT VM
vmscreenshot() {
	tmpFile=$(mktemp)
	domain=$(vmGetDomain $1)
	# cmd="sudo virsh screenshot $domain /dev/stdout | feh -"
	cmd="sudo virsh screenshot $domain $tmpFile"
	eval $cmd

	# FROM: https://www.reddit.com/r/i3wm/comments/mpehmg/comment/gu9fed3/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
	# FROM: https://stackoverflow.com/q/9560245/182888
	trap 'echo "feh exited, now lets return";kill -INT $$' CHLD
	feh $tmpFile &
	feh_pid=$!
	echo "feh_pid: $feh_pid"
	feh_wid=""
	while [ -z $feh_wid ];
	do
		feh_wid=$(xdotool search --pid "$feh_pid")
		echo "feh_wid: $feh_wid"
		sleep 0.1
	done
	i3-msg "[id=$feh_wid] floating enable, move position center" > /dev/null

	count=0
	while [ $count -lt 300 ]
	do
		count=$((count+1))
		# eval $cmd
		echo -ne "\r$(eval $cmd) at $(date)"
		# echo -ne "\rtaking screenshot at $(date)"
		sleep 1
	done

	# push the command into the history
	print -S $cmd
	echo $cmd
	eval $cmd
	# read -q "REPLY?Run command? "
	# [[ "$REPLY" == "y" ]] && eval $cmd
}

npm-outdated-update() {
	whatParam=$1
	if [ -z $whatParam ]; then
		whatParam="minor"
	fi
	if [ $whatParam = "major" ]; then
		whatColumn=4
	else
		whatColumn=3
	fi
	npm --color=always outdated |\
		fzf --header=$whatParam --multi --header-lines=1 --ansi |\
		awk '{print $1"@"$'$whatColumn'}' |\
		xargs --no-run-if-empty npm install
}

dotnet-outdated-update() {
	dotnet list package --outdated |\
		sed -n '/Top-level Package/,$p' |\
		sed 's/^.*> //' |\
		fzf --header=Latest --multi --header-lines=1 --ansi |\
		cut -f1 -d' ' |\
		xargs -n1 --no-run-if-empty dotnet add package
}

ssh-remove-and-connect(){
	# $1 is in the form of username@hostname
	username=$(cut -d'@' -f1 <<< $1)
	hostname=$(cut -d'@' -f2 <<< $1)
	sed -i.bak "/^$hostname /d" ~/.ssh/known_hosts
	# ssh $username@$hostname
	ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no -o PasswordAuthentication=yes $username@$hostname
}

ssh-with-password(){
	username=$(cut -d'@' -f1 <<< $1)
	hostname=$(cut -d'@' -f2 <<< $1)
	ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no -o PasswordAuthentication=yes $username@$hostname
}

# ;fn_ssh albert 132
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

aur-update-and-install-packages() {
	pushd -q ~/source-aur
	gfr |\
		grep behind |\
		cut -d':' -f1 |\
		sed 's|^\./||' |\
		sort |\
		fzf --header="Select packages to upgrade" --multi |\
		xargs --no-run-if-empty -I {} bash -c "pushd {} && git rebase && makepkg -is --needed --noconfirm --clean"
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
			packageFile=$(ls -t $package-*.pkg.tar | head -1)
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

# alias feh-screenshots='feh --scale-down -d -S mtime ~/Pictures/screenshots'
feh-screenshots() {
	feh \
		--scale-down \
		-d \
		-S mtime \
		--action1 ';xclip -selection clipboard -t image/png -i %F' \
		--action2 ';echo %F | xclip -i -selection clipboard' \
		--draw-actions \
		~/Pictures/screenshots
}


# alias hf='history 0 | cut -c 8- | fzf -e'

#set -o vi
# bind '"jk":vi-movement-mode'
#set bell-style none
#$if mode=vi
#		 set keymap vi-command
#		 "gg": beginning-of-history
#		 "G": end-of-history
#		 set keymap vi-insert				#notice how the "jj" movement is
#		 "jk": vi-movement-mode			#after 'set keymap vi-insert'?
#		 "\C-w": backward-kill-word
#		 "\C-p": history-search-backward
#$endif
#bindkey -e jk \\e
#bindkey '"jk":vi-movement-mode'
bindkey -v
bindkey 'jk' vi-cmd-mode
bindkey '^R' history-incremental-search-backward

# SORT OUT ISSUE WITH HOME AND END KEYS, FROM: https://stackoverflow.com/a/58842892/182888
bindkey "\E[H" beginning-of-line
bindkey "\E[F" end-of-line
bindkey "\E[3~" delete-char

# bindkey "\E." yank-last-arg
bindkey "\E." insert-last-word # alt + .
bindkey "^X*" expand-word # expand glob into items
# READ MORE HERE TOO, OTHER THINGS TO TRY:
# https://superuser.com/questions/582097/zsh-glob-expansion-without-menu

if [ -f /usr/bin/zoxide ]
then
	eval "$(zoxide init zsh)"
fi

setopt GLOB_COMPLETE

# Matches hidden files in completion, from: https://unix.stackexchange.com/a/366137/503193
setopt globdots

# Enable extended globs, for doing things like: mv ^Archive Archive, NOTE that it could conflict
# with filenames with glob characters!
setopt extendedglob


# Zsh vi mode
# FROM: https://github.com/jeffreytse/zsh-vi-mode
if [ ! -d "$HOME/.zsh-vi-mode" ]
then
	echo "Cloning zsh-vi-mode"
	git clone https://github.com/jeffreytse/zsh-vi-mode $HOME/.zsh-vi-mode
fi

ZVM_VI_ESCAPE_BINDKEY="jk"
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT # ZVM_MODE_NORMAL, ZVM_MODE_INSERT, ZVM_MODE_LAST
source $HOME/.zsh-vi-mode/zsh-vi-mode.plugin.zsh

########################################
# FROM: /usr/share/zsh/manjaro-zsh-config
########################################
setopt correct																									# Auto correct mistakes
setopt nocaseglob																								# Case insensitive globbing
setopt appendhistory																						# Immediately append history instead of overwriting
setopt histignorealldups																				# If a new command is a duplicate, remove the older one
setopt hist_ignore_space																				# Ignore commands starting with a space FROM: https://github.com/jbranchaud/til/blob/master/unix/exclude-a-command-from-the-zsh-history-file.md
setopt extendedhistory																				# Save timestamp of command FROM: https://stackoverflow.com/a/68888023/182888
setopt autocd																										# if only directory path is entered, cd there.
setopt inc_append_history																				# save commands are added to the history immediately, otherwise only when shell exits.

# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Navigate words with ctrl+arrow keys
bindkey '^[Oc' forward-word																			#
bindkey '^[Od' backward-word																		#
bindkey '^[[1;5D' backward-word																	#
bindkey '^[[1;5C' forward-word																	#
bindkey '^H' backward-kill-word																	# delete previous word with ctrl+backspace

# Offer to install missing package if command is not found
if [[ -r /usr/share/zsh/functions/command-not-found.zsh ]]; then
		source /usr/share/zsh/functions/command-not-found.zsh
		export PKGFILE_PROMPT_INSTALL_MISSING=1
fi
########################################


########################################
# FROM: /usr/share/zsh/manjaro-zsh-prompt
########################################
# source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# if file exists, then source it
if [ -f ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]
then
	source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

	# bindkey '^Y' autosuggest-accept
	function zvm_after_init() {
		zvm_bindkey viins '^Y' autosuggest-accept

		# FROM: https://stackoverflow.com/questions/28078756/how-to-add-all-tab-completitions-to-my-current-command
		zle -C all-matches complete-word _my_generic
		zstyle ':completion:all-matches::::' completer _all_matches
		zstyle ':completion:all-matches:*' old-matches only
		_my_generic () {
			local ZSH_TRACE_GENERIC_WIDGET=  # works with "setopt nounset"
			_generic "$@"
		}
		# bindkey '^X^a' all-matches
		zvm_bindkey viins '^[*' all-matches

	}
fi

########################################


# WAS CAUSING ISSUES, LETS SEE IF THINGS WORK AFTER REMOVING THIS
# ADDED IT BACK, NOT SURE WHAT THE ISSUE WAS, BUT I DIDNT HAVE NODE ON MY PATH WHEN I DIDNT HAVE
# THIS
if [ -f /usr/share/nvm/init-nvm.sh ]
then
	source /usr/share/nvm/init-nvm.sh
fi

if [ -d /opt/cuda/ ]
then
	export CUDA_HOME=/opt/cuda/
fi


# Add dotnet tools to the path
if [ -d ~/.dotnet/tools ]
then
	export PATH=$PATH:~/.dotnet/tools
fi

export PATH=$PATH:~/.local/bin


# Set up fzf key bindings and fuzzy completion
if [ -f /usr/bin/fzf ]
then
	fzfMinorVersion=$(fzf --version | cut -d' ' -f1 | cut -d. -f2)
	# Shell integration was added in 0.48.0 and later
	if [ $fzfMinorVersion -ge 47 ]
	then
		eval "$(fzf --zsh)"
	fi
fi

# FROM: https://wiki.archlinux.org/title/Zsh#pacman_-F_%22command_not_found%22_handler
# Make sure to also fetch the files database: pacman -Fy
function command_not_found_handler {
	local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
	printf 'zsh: command not found: %s\n' "$1"
	local entries=(
		${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"}
	)
	if (( ${#entries[@]} ))
	then
		printf "${bright}$1${reset} may be found in the following packages:\n"
		local pkg
		for entry in "${entries[@]}"
		do
			# (repo package version file)
			local fields=(
				${(0)entry}
			)
			if [[ "$pkg" != "${fields[2]}" ]]
			then
				printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
		fi
			printf '		/%s\n' "${fields[4]}"
			pkg="${fields[2]}"
		done
	fi
	return 127
}
