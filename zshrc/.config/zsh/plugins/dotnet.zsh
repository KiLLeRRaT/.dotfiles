dotnet-outdated-update() {
	dotnet list package --outdated |\
		sed -n '/Top-level Package/,$p' |\
		sed 's/^.*> //' |\
		fzf --header=Latest --multi --header-lines=1 --ansi |\
		cut -f1 -d' ' |\
		xargs -n1 --no-run-if-empty dotnet add package
}

