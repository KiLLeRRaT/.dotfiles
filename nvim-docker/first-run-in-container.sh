#!/bin/zsh
GREEN='\033[0;32m'
NC='\033[0m' # No Color

set -e

source ~/.zshrc

echo "${GREEN}Installing node using nvm...${NC}"
nvm install --lts && \
	nvm use --lts && \
	source ~/.zshrc && \
	node --version


echo "${GREEN}Running nvim to install plugins...${NC}"
nvim --headless +Lazy! +qa

echo "${GREEN}Building telescope-fzf-native...${NC}"
pushd ~/.local/share/nvim/lazy/telescope-fzf-native.nvim
make
popd

echo "${GREEN}Running nvim again to install TreeSitter parsers${NC}"
# FROM: https://github.com/nvim-treesitter/nvim-treesitter/issues/3579
# Had to also do a sync_install for treesitter to work properly, then you just start nvim and it
# installs correctly without specifically running TSInstall and exits when done.
nvim --headless +qa
