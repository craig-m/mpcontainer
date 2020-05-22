#!/bin/bash
# docker only (not podman)
docker container update --pids-limit=200 --memory-reservation="10m" --memory="20m" --memory-swap="20m" --cpus=2 --restart=on-failure:3 vagrant_frontend_1;
docker container update --pids-limit=200 --memory-reservation="10m" --memory="25m" --memory-swap="25m" --cpus=2 --restart=on-failure:3 vagrant_backendweb_1;
docker container update --pids-limit=200 --memory-reservation="10m" --memory="25m" --memory-swap="25m" --cpus=2 --restart=on-failure:3 backendmpd;
docker container update --pids-limit=200 --memory-reservation="10m" --memory="20m" --memory-swap="20m" --cpus=2 --restart=on-failure:3 adminmmpd;