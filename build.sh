#!/bin/sh

VERSION=`cat VERSION`

docker build \
	-t thaim/submin:${VERSION} \
	-t thaim/submin \
	.
