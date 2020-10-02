#!/bin/bash

echo "starting mpd build container"

# build if image is missing
docker images mpd-build | \
    grep "mpd-build" | \
    awk '{print $2}' | grep -q "latest" || docker build -t mpd-build:latest .

# run and attach
docker run -it \
    mpd-build /bin/bash
