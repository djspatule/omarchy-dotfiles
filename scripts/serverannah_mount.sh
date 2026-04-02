#!/bin/bash

set -euo pipefail

mountpoint="$HOME/mnt/serverannah"
remote="lion@192.168.1.7:/mnt/"

mkdir -p "$mountpoint"

if mountpoint -q "$mountpoint"; then
  echo "Already mounted: $mountpoint"
  exit 0
fi

exec sshfs "$remote" "$mountpoint" \
  -o reconnect \
  -o ServerAliveInterval=15 \
  -o ServerAliveCountMax=3 \
  -o follow_symlinks \
  -o idmap=user
