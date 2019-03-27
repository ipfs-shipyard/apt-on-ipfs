#!/bin/bash

rsync -q --recursive --times --links --safe-links --hard-links --exclude "Packages*" --exclude "Sources*" --exclude "Release*" --exclude "InRelease" rsync://archive.ubuntu.com/ubuntu /data/apt/

rsync -q --recursive --times --links --safe-links --hard-links --delete --delete-after rsync://archive.ubuntu.com/ubuntu /data/apt/

export IPFS_PATH=/data/.ipfs

hash="$(ipfs add -r --quieter --raw-leaves /data/apt | tail -n1)"

ipfs name publish "$hash"
