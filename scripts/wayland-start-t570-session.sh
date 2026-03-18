#!/bin/bash
set -euo pipefail

ws2='2:2 '
ws8='8:8 '

sleep 1

swaymsg "workspace $ws2; append_layout $HOME/.config/sway/workspaces/arch-t570/workspace-2.json" > /dev/null
swaymsg "workspace $ws8; append_layout $HOME/.config/sway/workspaces/arch-t570/workspace-8.json" > /dev/null

swaymsg "workspace $ws8" > /dev/null
brave --profile-directory=Default > /dev/null 2>&1 &

swaymsg "workspace $ws2" > /dev/null
alacritty --title "Terminal Main" --command zsh -c "tmux a || tmux" > /dev/null 2>&1 &
