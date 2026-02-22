#!/bin/bash
set -e

curl -H 'Cache-Control: no-cache, no-store' -LOJ https://raw.githubusercontent.com/KiLLeRRaT/.dotfiles/refs/heads/master/install/install-arch2.10-partition.sh
curl -H 'Cache-Control: no-cache, no-store' -LOJ https://raw.githubusercontent.com/KiLLeRRaT/.dotfiles/refs/heads/master/install/install-arch2.20-mount.sh
curl -H 'Cache-Control: no-cache, no-store' -LOJ https://raw.githubusercontent.com/KiLLeRRaT/.dotfiles/refs/heads/master/install/install-arch2.30-install.sh
curl -H 'Cache-Control: no-cache, no-store' -LOJ https://raw.githubusercontent.com/KiLLeRRaT/.dotfiles/refs/heads/master/install/install-arch2.50-arch-chroot.sh
curl -H 'Cache-Control: no-cache, no-store' -LOJ https://raw.githubusercontent.com/KiLLeRRaT/.dotfiles/refs/heads/master/install/install-arch2.90-umount.sh
curl -H 'Cache-Control: no-cache, no-store' -LOJ https://raw.githubusercontent.com/KiLLeRRaT/.dotfiles/refs/heads/master/install/install-arch2.variables.sh
curl -H 'Cache-Control: no-cache, no-store' -LOJ https://raw.githubusercontent.com/KiLLeRRaT/.dotfiles/refs/heads/master/install/mount-install-env.sh
curl -H 'Cache-Control: no-cache, no-store' -LOJ https://raw.githubusercontent.com/KiLLeRRaT/.dotfiles/refs/heads/master/install/umount-install-env.sh
curl -H 'Cache-Control: no-cache, no-store' -LOJ https://raw.githubusercontent.com/KiLLeRRaT/.dotfiles/refs/heads/master/install/rescue-arch.sh

chmod u+x *.sh
echo "Done"

