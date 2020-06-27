#!/bin/bash

echo "MPD build started"

# get source
git clone https://github.com/MusicPlayerDaemon/MPD.git
cd MPD || exit 1

# configure build
meson . output/release --buildtype=debugoptimized \
    -Db_ndebug=true \
    -Dalsa=disabled \
    -Djack=disabled \
    -Dpulse=disabled \
    -Dzeroconf=disabled \
    -Dupnp=disabled \
    -Dsystemd=disabled \
    -Dsmbclient=disabled \
    -Dnfs=disabled \
    -Dsolaris_output=disabled \
    -Dsoundcloud=disabled \
    -Dtest=true

# show build options
meson configure output/release

# compile
ninja -C output/release

# the bin
file ~/MPD/output/release/mpd

echo -e "\nMPD build finished\n"
