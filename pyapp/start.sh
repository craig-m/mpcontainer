#!/bin/bash

# start the MPContainer pyapp (mpcpyapp.py) under Gunicorn 
#
# desc: "Green Unicorn" is a Python WSGI HTTP Server for UNIX
# doc: https://docs.gunicorn.org/en/latest/index.html

thedate=$(date)
thehost=$(hostname)
echo "--- starting mpcpyapp on: ${thehost} ${thedate} ---";


#
# checks before starting
#

if [[ pyapp = "$(whoami)" ]]; then
  echo "running as pyapp (good)";
else
  echo "ERROR: not running as pyapp";
  exit 1;
fi

if [ ! -f /pyapp/mpcpyapp.py ]; then
  echo "ERROR: missing app";
  exit 1;
fi


#
# start gunicorn
#

# -- prod --
gmpco_start_opt="--preload"
# -- dev --
#gmpco_start_opt="--reload --reload-engine auto"
#env_mpcpyapp_loglev="debug"

# run:
gunicorn mpcpyapp:app \
  --pid /tmp/pyapi-gunicorn.pid \
  --bind unix:/tmp/pyapp.socket \
  --bind 0.0.0.0:8888 \
  --workers 2 \
  --threads 4 \
  --timeout 30 \
  --backlog 400 \
  --limit-request-fields 50 \
  --worker-tmp-dir /dev/shm \
  --error-logfile - \
  --access-logfile - \
  --log-level ${env_mpcpyapp_loglev} \
  ${gmpco_start_opt};
