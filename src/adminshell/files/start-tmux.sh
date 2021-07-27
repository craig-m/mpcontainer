#!/bin/bash

tmux ls

if [ $? == 1 ]; then
    # start new
    tmux new -A -c /usr/bin/bash -s djconsole /usr/bin/ncmpcpp
else
    # attach existing
    tmux a
fi