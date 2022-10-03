#!/bin/zsh

# RUN SED SCRIPT TO STRIP HOST SPECIFIC PARTS FROM i3 CONFIG FILE
pushd ~/.config/i3
# echo "host is $HOST"
rm config
sed '/# <hostSpecificConfig>/,/# <\/hostSpecificConfig>/ {/# <config hostname="'$HOST'">/,/# <\/config>/!d}' config.allHosts > config
popd


