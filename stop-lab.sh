#!/usr/bin/env bash
# Stop the lab. Use --remove to delete containers and the network.
set -euo pipefail

if [[ "${1:-}" == "--remove" ]]; then
  podman rm -f ansible-control node-1 node-2 || true
  podman network rm ansible-net || true
  echo "Lab removed."
else
  podman stop ansible-control node-1 node-2 || true
  echo "Lab stopped. Restart with: podman start ansible-control node-1 node-2"
fi
