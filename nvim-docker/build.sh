#!/bin/zsh

# GET THE CURRENT COMMIT SHA
export BUILD_DATE=$(git rev-parse HEAD)


# GET DATE IN yyyymmddHHmmss FORMAT
# export BUILD_DATE=$(date +%Y%m%d%H%M%S)

 # DO YOU WANT TO BUILD WITH NO CACHE?
read -q "REPLY?Do you want build with --no-cache? [y/N] "
if [[ $REPLY =~ ^[Yy]$ ]]
then
		docker-compose build --no-cache
else
		docker-compose build
fi


 # DO YOU WANT TO PUSH THE IMAGE?
read -q "REPLY?Do you want to push the image? [y/N] "
if [[ $REPLY =~ ^[Yy]$ ]]
then
		docker-compose push
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




