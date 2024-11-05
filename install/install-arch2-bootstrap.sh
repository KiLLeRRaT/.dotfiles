#!/bin/bash
set -e

curl -LOJ https://u.gouws.org/install/install-arch2.10-partition.sh
curl -LOJ https://u.gouws.org/install/install-arch2.20-mount.sh
curl -LOJ https://u.gouws.org/install/install-arch2.30-install.sh
curl -LOJ https://u.gouws.org/install/install-arch2.50-arch-chroot.sh
curl -LOJ https://u.gouws.org/install/install-arch2.90-umount.sh
chmod u+x *.sh
echo "Done"

