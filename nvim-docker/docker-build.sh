#!/bin/zsh

if [ "$EUID" -ne 0 ]
	then echo "Please run using sudo"
	exit
fi


function getParams() {
	# FROM: https://gist.github.com/mattmc3/804a8111c4feba7d95b6d7b984f12a53
	local positional=()
	# local flag_verbose=false
	# local filename=myfile
	# flag_verbose=false
	# filename=myfile
	git_email=""
	git_name=""

	local usage=(
		"docker-build [-h|--help]"
		# "docker-build [-v|--verbose] [-f|--filename=<file>] [<message...>]"
		"docker-build --git-email=<email> --git-name=<name>"
	)
	opterr() { echo >&2 "docker-build: Unknown option '$1'" }

	while (( $# )); do
		case $1 in
			--)									shift; positional+=("${@[@]}"); break  ;;
			-h|--help)					printf "%s\n" $usage && return				 ;;
			# -v|--verbose)				flag_verbose=true											 ;;
			# -f|--filename)			shift; filename=$1										 ;;
			# -f=*|--filename=*)	filename="${1#*=}"										 ;;
			--git-email)				shift; git_email=$1											;;
			--git-email=*)			git_email="${1#*=}"											;;
			--git-name)					shift; git_name=$1											;;
			--git-name=*)				git_name="${1#*=}"											;;
			-*)									opterr $1 && return 2									 ;;
			# *)									positional+=("${@[@]}"); break				 ;;
		esac
		shift
	done

	if [[ -z $git_email || -z $git_name ]]
	then
		echo "Please provide a valid git email and name"
		exit 1
	fi
	
	# echo "--verbose: $flag_verbose"
	# echo "--filename: $filename"
	# echo "positional: $positional"
	# echo "--git-email: $git_email"
	# echo "--git-name: $git_name"
}

getParams "$@"
# exit 1



# GET THE CURRENT COMMIT SHA
export BUILD_DATE=$(git rev-parse HEAD)


# GET DATE IN yyyymmddHHmmss FORMAT
# export BUILD_DATE=$(date +%Y%m%d%H%M%S)

read -q "REPLY?Do you want build with --no-cache? [y/N] "
declare cache=""
if [[ $REPLY =~ ^[Yy]$ ]]
then
		# docker compose --progress=plain build --no-cache --build-arg GIT_EMAIL=$GIT_EMAIL --build-arg GIT_NAME=$GIT_NAME
		cache="--no-cache"
fi

docker compose --progress=plain build $cache --build-arg GIT_EMAIL="$git_email" --build-arg GIT_NAME="$git_name"

if [[ $? -ne 0 ]]
then
		echo "Build failed"
		exit 1
fi

read -q "REPLY?Do you want to push the image? [y/N] "
if [[ $REPLY =~ ^[Yy]$ ]]
then
		docker compose push
fi

# LIST IMAGES/REPOS:
# https://dockerregistry.gouws.org/v2/_catalog
# https://dockerregistry.gouws.org/v2/nvim-docker/tags/list
#
# DELETING IMAGES:
#·https://dockerregistry.gouws.org/v2/nvim-docker/tags/list
# DELETE	/v2/<name>/manifests/<reference>
#
#
# FROM: https://stackoverflow.com/a/43786939/182888
# curl -sSL -u "$(read 'u?Username: ';echo $u)" https://dockerregistry.gouws.org/v2/_catalog
# curl -sSL -u "$(read 'u?Username: ';echo $u)" https://dockerregistry.gouws.org/v2/nvim-docker/tags/list
# curl -sSL -u "$(read 'u?Username: ';echo $u)" -H 'Accept: application/vnd.docker.distribution.manifest.v2+json' -o /dev/null -w '%header{Docker-Content-Digest}' https://dockerregistry.gouws.org/v2/nvim-docker/manifests/<tag>
# curl -sSL -u "$(read 'u?Username: ';echo $u)" -X DELETE https://dockerregistry.gouws.org/v2/nvim-docker/manifests/<digest>
# /bin/registry garbage-collect /etc/docker/registry/config.yml




