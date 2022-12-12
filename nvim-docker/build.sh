#!/bin/zsh

# GET DATE IN yyyymmddHHmmss FORMAT
export BUILD_DATE=$(date +%Y%m%d%H%M%S)

docker-compose build

docker-compose push
