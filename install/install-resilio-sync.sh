#!/bin/bash

dockerComposeFile="/home/albert/resilio-sync/docker-compose.yml"
# Make a heredoc that echos the docker-compose file
cat <<EOF > $dockerComposeFile
services:
  resilio-sync:
    image: lscr.io/linuxserver/resilio-sync:latest
    container_name: resilio-sync
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Pacific/Auckland
    volumes:
      - /home/albert/resilio-sync/config:/config
      - /home/albert/resilio-sync/downloads:/downloads
      - /home/albert/resilio-sync/sync:/sync
    # ports:
    #   - 8888:8888
    #   - 55555:55555
    network_mode: host # Helps so I don't have to use a relay, keeps things on the same subnet
    restart: unless-stopped
EOF

# Should we start the container?
read -p "Do you want to start the container now? [y/N] " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	docker-compose -f $dockerComposeFile up -d
fi
