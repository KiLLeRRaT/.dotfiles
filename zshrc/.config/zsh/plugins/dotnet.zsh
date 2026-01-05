dotnet-outdated-update() {
	FZF_DIRECTION=up;dotnet list package --outdated --no-restore |\
		sed -n '/Top-level Package/,$p' |\
		sed 's/^.*> //' |\
		fzf --header=Latest --multi --header-lines=1 --ansi |\
		cut -f1 -d' ' |\
		xargs -n1 --no-run-if-empty dotnet add package
}

# FROM: https://learn.microsoft.com/en-us/dotnet/core/tools/enable-tab-autocomplete#zsh
# zsh parameter completion for the dotnet CLI
_dotnet_zsh_complete()
{
  local completions=("$(dotnet complete "$words")")

  # If the completion list is empty, just continue with filename selection
  if [ -z "$completions" ]
  then
	_arguments '*::arguments: _normal'
	return
  fi

  # This is not a variable assignment, don't remove spaces!
  _values = "${(ps:\n:)completions}"
}

compdef _dotnet_zsh_complete dotnet
