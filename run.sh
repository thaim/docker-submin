#!/bin/sh

VERSION=`cat VERSION`
hostname="192.168.11.102"
port="8010"

docker run -it \
       --name sample_submin \
       -p "8010:80" \
       -e "SUBMIN_HOSTNAME=${hostname}:${port}" \
       thaim/submin:${VERSION}

