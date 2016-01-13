#!/bin/sh

VERSION=`cat VERSION`

docker build \
       -t theoplementation.net:5000/thaim/submin:${VERSION} \
	.
