#!/bin/zsh

echo "host is $HOST"

# RUN SED SCRIPT TO STRIP HOST SPECIFIC PARTS FROM i3status CONFIG FILE
pushd ~/.dotfiles/i3-manjaro/.config/i3status
rm config
sed '/# <hostSpecificConfig>/,/# <\/hostSpecificConfig>/ {/# <config hostname="'$HOST'">/,/# <\/config>/!d;}' config.allHosts > config
popd


# RUN SED SCRIPT TO STRIP HOST SPECIFIC PARTS FROM i3 CONFIG FILE
pushd ~/.dotfiles/i3-manjaro/.config/i3
rm config
sed '/# <hostSpecificConfig>/,/# <\/hostSpecificConfig>/ {/# <config hostname="'$HOST'">/,/# <\/config>/!d;}' config.allHosts > config
popd


# RUN SED SCRIPT TO STRIP HOST SPECIFIC PARTS FROM alacritty CONFIG FILE
pushd ~/.dotfiles/alacritty/.config/alacritty/
rm alacritty.yml alacritty.toml
sed '/# <hostSpecificConfig>/,/# <\/hostSpecificConfig>/ {/# <config hostname="'$HOST'">/,/# <\/config>/!d;}' alacritty.allHosts.yml > alacritty.yml
sed '/# <hostSpecificConfig>/,/# <\/hostSpecificConfig>/ {/# <config hostname="'$HOST'">/,/# <\/config>/!d;}' alacritty.allHosts.toml > alacritty.toml
popd


