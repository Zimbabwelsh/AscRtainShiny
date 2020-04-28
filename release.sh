#!/bin/bash

set -ex

## See https://medium.com/travis-on-docker/how-to-version-your-docker-images-1d5c577ebf54

# ensure we're up to date
git pull

# bump version
version=`cat version.txt | cut -d " " -f 1`
echo "version: $version"

# run build
docker build -t AscRtain-shiny:latest . --build-arg CACHE_DATE="$(date)"

# run container
docker stop AscRtain-shiny || true
docker rm AscRtain-shiny || true
docker run -d --name AscRtain-shiny -p 8010:3838 --restart=always AscRtain-shiny:latest
