#!/bin/bash
set -e

curl -H 'Cache-Control: no-cache, no-store' -LOJ "https://raw.githubusercontent.com/KiLLeRRaT/.dotfiles/refs/heads/master/install/install-arch2.10-partition.sh?$(date +%s)"
curl -H 'Cache-Control: no-cache, no-store' -LOJ "https://raw.githubusercontent.com/KiLLeRRaT/.dotfiles/refs/heads/master/install/install-arch2.20-mount.sh?$(date +%s)"
curl -H 'Cache-Control: no-cache, no-store' -LOJ "https://raw.githubusercontent.com/KiLLeRRaT/.dotfiles/refs/heads/master/install/install-arch2.30-install.sh?$(date +%s)"
curl -H 'Cache-Control: no-cache, no-store' -LOJ "https://raw.githubusercontent.com/KiLLeRRaT/.dotfiles/refs/heads/master/install/install-arch2.50-arch-chroot.sh?$(date +%s)"
curl -H 'Cache-Control: no-cache, no-store' -LOJ "https://raw.githubusercontent.com/KiLLeRRaT/.dotfiles/refs/heads/master/install/install-arch2.90-umount.sh?$(date +%s)"
curl -H 'Cache-Control: no-cache, no-store' -LOJ "https://raw.githubusercontent.com/KiLLeRRaT/.dotfiles/refs/heads/master/install/install-arch2.variables.sh?$(date +%s)"
curl -H 'Cache-Control: no-cache, no-store' -LOJ "https://raw.githubusercontent.com/KiLLeRRaT/.dotfiles/refs/heads/master/install/mount-install-env.sh?$(date +%s)"
curl -H 'Cache-Control: no-cache, no-store' -LOJ "https://raw.githubusercontent.com/KiLLeRRaT/.dotfiles/refs/heads/master/install/umount-install-env.sh?$(date +%s)"
curl -H 'Cache-Control: no-cache, no-store' -LOJ "https://raw.githubusercontent.com/KiLLeRRaT/.dotfiles/refs/heads/master/install/rescue-arch.sh?$(date +%s)"

chmod u+x *.sh
echo "Done"

