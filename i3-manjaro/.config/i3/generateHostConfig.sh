#!/bin/zsh

# RUN SED SCRIPT TO STRIP HOST SPECIFIC PARTS FROM i3status CONFIG FILE
pushd ~/.config/i3status
# echo "host is $HOST"
rm config
sed '/# <hostSpecificConfig>/,/# <\/hostSpecificConfig>/ {/# <config hostname="'$HOST'">/,/# <\/config>/!d}' config.allHosts > config
popd


# RUN SED SCRIPT TO STRIP HOST SPECIFIC PARTS FROM i3 CONFIG FILE
pushd ~/.config/i3
# echo "host is $HOST"
rm config
sed '/# <hostSpecificConfig>/,/# <\/hostSpecificConfig>/ {/# <config hostname="'$HOST'">/,/# <\/config>/!d}' config.allHosts > config
popd


# RUN SED SCRIPT TO STRIP HOST SPECIFIC PARTS FROM alacritty CONFIG FILE
pushd ~/.config/alacritty/
# echo "host is $HOST"
rm alacritty.yml
sed '/# <hostSpecificConfig>/,/# <\/hostSpecificConfig>/ {/# <config hostname="'$HOST'">/,/# <\/config>/!d}' alacritty.allHosts.yml > alacritty.yml
popd


