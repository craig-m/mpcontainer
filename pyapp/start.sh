#!/bin/bash

echo "start.sh: starting gunicorn";

# checks before starting gunicorn

if [[ pyapp = "$(whoami)" ]]; then
  echo "running as pyapp - good";
else
  echo "ERROR: not running as pyapp";
  exit 1;
fi

if [ ! -f /pyapp/mpcpyapp.py ]; then
  echo "ERROR: missing app";
  exit 1;
fi

gunicorn mpcpyapp:app \
  --pid /tmp/pyapi-gunicorn.pid \
  --bind unix:/tmp/pyapp.socket \
  --bind 0.0.0.0:8888 \
  --workers 2 \
  --preload \
  --timeout 30 \
  --backlog 200 \
  --limit-request-fields 50