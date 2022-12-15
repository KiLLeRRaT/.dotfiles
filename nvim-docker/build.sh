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


