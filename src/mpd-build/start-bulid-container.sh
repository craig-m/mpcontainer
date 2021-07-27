#!/bin/bash

echo "starting mpd build container"

docker build -t mpd-build:latest .

docker run \
    --mount type=bind,source="$(pwd)"/output,target=/opt/output \
    mpd-build /bin/bash /code/build.sh
