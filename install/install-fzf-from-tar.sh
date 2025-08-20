#!/bin/bash
set -e

mkdir /tmp/fzf
pushd /tmp/fzf

curl -L -o fzf.tar.gz https://github.com/junegunn/fzf/releases/download/v0.62.0/fzf-0.62.0-linux_amd64.tar.gz
tar -xzf fzf.tar.gz
sudo cp fzf /usr/local/bin
rm -rf fzf fzf.tar.gz

popd


