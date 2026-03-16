#!/bin/bash
# Wait for network
while ! ping -c 1 192.168.1.254 &>/dev/null; do sleep 1; done
sudo mount -t cifs -o guest //192.168.1.254/Disque\ dur /mnt/freebox
