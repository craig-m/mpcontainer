#!/bin/bash

# sanity check
if [[ dj != "$(whoami)" ]]; then
  echo "ERROR: wrong user";
  exit 1;
fi

# kick off db update on MPD container
mpc update

# start ttyd
ttyd --port 7681 --max-clients 10 --base-path /admin/shell /usr/bin/tmux new -A -s djconsole ncmpcpp