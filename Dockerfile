FROM ubuntu:18.04

# Install minimal tools to get started via regular apt
RUN apt-get update && apt-get install -y python3-pip git wget

# Download, install and configure IPFS (not available via apt yet)
RUN wget https://dist.ipfs.io/go-ipfs/v0.4.19/go-ipfs_v0.4.19_linux-amd64.tar.gz
RUN tar xvfz go-ipfs_v0.4.19_linux-amd64.tar.gz
RUN mv go-ipfs/ipfs /usr/local/bin/ipfs
RUN ipfs init

# Download and install the python IPFS http API library via pip
RUN pip3 install ipfsapi

# Download and install apt-transport-ipfs from GitHub
RUN git clone https://github.com/JaquerEspeis/apt-transport-ipfs && cd apt-transport-ipfs && cp ipfs /usr/lib/apt/methods/ipfs

# Setup a working directory
ENV SRC_DIR /usr/src/
COPY . $SRC_DIR
WORKDIR $SRC_DIR

# Update the apt sources file to point at the IPFS mirror
RUN mv sources.list /etc/apt/sources.list

# start the IPFS daemon and then install jq via apt using IPFS
RUN (ipfs daemon &) && sleep 5 && apt-get update && apt-get install -y jq

# run jq to see it's installed
RUN ["jq", "--version"]
