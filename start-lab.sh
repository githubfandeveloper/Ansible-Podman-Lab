#!/usr/bin/env bash
# Create the network and (re)create the 3 lab containers, then copy project files in.
set -euo pipefail
cd "$(dirname "$0")"

podman network exists ansible-net || podman network create --subnet 10.10.0.0/24 ansible-net
podman rm -f ansible-control node-1 node-2 >/dev/null 2>&1 || true

podman run -d --network ansible-net --ip 10.10.0.2 --name ansible-control --hostname ansible-control ansible-control sleep infinity
podman run -d --network ansible-net --ip 10.10.0.3 -p 8080:80 --name node-1 --hostname node-1 ansible-node
podman run -d --network ansible-net --ip 10.10.0.4 --name node-2 --hostname node-2 ansible-node

podman exec ansible-control mkdir -p /home/vagrant/ansible
podman cp project/. ansible-control:/home/vagrant/ansible/
podman exec --user root ansible-control chown -R vagrant:vagrant /home/vagrant/ansible

podman ps
echo "Lab started. Next: ./setup-ssh.sh"
