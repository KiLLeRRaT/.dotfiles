#!/bin/bash

pushd ~/Downloads

# Download latest release of neovim
curl -LOJ https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz

# Extract the tarball
tar -xzf nvim-linux64.tar.gz

# Move the extracted stuff to /usr/local/bin, and /usr/local/share
rsync -auv nvim-linux64/ /usr/local/

rm -rf nvim-linux64 nvim-linux64.tar.gz

popd
