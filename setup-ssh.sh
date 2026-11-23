#!/usr/bin/env bash
# Generate the control node key (if missing) and copy it to both managed nodes.
# Old host keys are removed first, so recreated nodes work without errors.
set -euo pipefail

podman exec ansible-control bash -c '
  set -e
  mkdir -p ~/.ssh && chmod 700 ~/.ssh
  [ -f ~/.ssh/id_ed25519 ] || ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N "" -q
  command -v sshpass >/dev/null || (sudo apt-get update -qq && sudo apt-get install -y -qq sshpass)
  for ip in 10.10.0.3 10.10.0.4; do
    ssh-keygen -R "$ip" >/dev/null 2>&1 || true
    sshpass -p vagrant ssh-copy-id -i ~/.ssh/id_ed25519.pub -o StrictHostKeyChecking=no vagrant@$ip
  done
  echo "--- Test ---"
  ssh vagrant@10.10.0.3 hostname
  ssh vagrant@10.10.0.4 hostname
'
