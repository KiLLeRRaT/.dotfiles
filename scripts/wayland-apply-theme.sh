#!/bin/sh

set -eu

gsettings set org.gnome.desktop.interface gtk-theme Dracula
gsettings set org.gnome.desktop.interface icon-theme Dracula
gsettings set org.gnome.desktop.interface font-name 'SF Pro Display 11'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
