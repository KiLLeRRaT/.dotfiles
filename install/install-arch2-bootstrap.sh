#!/bin/bash
set -e

curl -H 'Cache-Control: no-cache, no-store' -LOJ https://u.gouws.org/install/install-arch2.10-partition.sh
curl -H 'Cache-Control: no-cache, no-store' -LOJ https://u.gouws.org/install/install-arch2.20-mount.sh
curl -H 'Cache-Control: no-cache, no-store' -LOJ https://u.gouws.org/install/install-arch2.30-install.sh
curl -H 'Cache-Control: no-cache, no-store' -LOJ https://u.gouws.org/install/install-arch2.50-arch-chroot.sh
curl -H 'Cache-Control: no-cache, no-store' -LOJ https://u.gouws.org/install/install-arch2.90-umount.sh
curl -H 'Cache-Control: no-cache, no-store' -LOJ https://u.gouws.org/install/install-arch2.variables.sh
chmod u+x *.sh
echo "Done"

