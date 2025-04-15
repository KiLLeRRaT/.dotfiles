#!/bin/bash
set -e

pushd ~/Downloads

curl -L -o fzf.tar.gz https://github.com/junegunn/fzf/releases/latest/download/fzf-0.61.1-linux_amd64.tar.gz
tar -xzf fzf.tar.gz
sudo cp fzf /usr/local/bin
rm -rf fzf fzf.tar.gz

popd


