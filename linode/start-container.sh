#!/bin/bash

echo "starting mpcontainer-sysadmin"

# build if image is missing
docker images mpcontainer-sysadmin | \
    grep "mpcontainer-sysadmin" | \
    awk '{print $2}' | grep -q "latest" || docker build -t mpcontainer-sysadmin:latest .

# run and attach
docker run -it \
    --mount type=bind,source="$(pwd)"/terraform,target=/opt/terraform \
    --mount type=bind,source="$(pwd)"/../kubernetes,target=/opt/kubernetes \
    mpcontainer-sysadmin /bin/bash
