# IPFS apt mirror

A docker image that installs ubuntu packages via IPFS rather than using http to talk to a mirror

Full credit to https://github.com/JaquerEspeis/apt-transport-ipfs for laying the ground work for this.

See the [Dockerfile](Dockerfile) for a breakdown of how it works, and [sources.list](sources.list) for the current IPFS hash of the mirror.

Run it with the following commands, may take a few minutes depending on how many nodes are connected

```shell
git clone https://github.com/andrew/apt-on-ipfs
cd apt-on-ipfs
docker build .
```

## Running your own mirror

Note: This requires ~2.5TB of free disk space and over 36 hours to complete the first time, subsequent runs take ~3 hours.

Initial setup commands, run once:

```shell

apt-get update
apt-get install -y git wget

wget https://dist.ipfs.io/go-ipfs/v0.4.19/go-ipfs_v0.4.19_linux-amd64.tar.gz
tar xvfz go-ipfs_v0.4.19_linux-amd64.tar.gz
mv go-ipfs/ipfs /usr/local/bin/ipfs

mkdir -p /data/apt

export IPFS_PATH=/data/.ipfs

ipfs init
```

Mirroring commands, can be ran repeatedly to keep up to date:

```shell
rsync -q --recursive --times --links --safe-links --hard-links --exclude "Packages*" --exclude "Sources*" --exclude "Release*" --exclude "InRelease" rsync://archive.ubuntu.com/ubuntu /data/apt/

rsync -q --recursive --times --links --safe-links --hard-links --delete --delete-after rsync://archive.ubuntu.com/ubuntu /data/apt/

export IPFS_PATH=/data/.ipfs

hash="$(ipfs add -r --quieter --raw-leaves /data/apt | tail -n1)"

ipfs name publish "$hash"
```

The first time you run the mirroring commands, a new [IPNS](https://docs.ipfs.io/guides/concepts/ipns/) will be output, update [sources.list](sources.list) with your IPNS and then after each sync that IPNS will be updated to point to the latest IPFS hash of the mirror.

You may wish to pick a different ubuntu mirror that is geographically closer to your server for faster rsyncing: https://launchpad.net/ubuntu/+archivemirrors
