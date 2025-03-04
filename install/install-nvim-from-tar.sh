#!/bin/bash
set -e

pushd ~/Downloads

# Download latest release of neovim
curl -L -o nvim.tar.gz https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz

# Extract the tarball
tar -xzf nvim.tar.gz

# Move the extracted stuff to /usr/local/bin, and /usr/local/share
rsync -auv nvim-linux-x86_64/ /usr/local/

rm -rf nvim-linux-x86_64 nvim.tar.gz

popd
