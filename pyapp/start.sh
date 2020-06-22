#!/bin/bash

# start the MPContainer pyapp (mpcpyapp.py) under Gunicorn 
#
# desc: "Green Unicorn" is a Python WSGI HTTP Server for UNIX
# doc: https://docs.gunicorn.org/en/latest/index.html

thedate=$(date)
thehost=$(hostname)

#
# checks before starting
#

if [[ pyapp = "$(whoami)" ]]; then
  echo "--- starting mpcpyapp on: ${thehost} ${thedate} ---";
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

if [[ $env_mpcpyapp_debug == "true" ]]; then
  # debug mode for dev
  gmpco_start_opt="--log-level info --reload --reload-engine auto"
else
  # prod
  gmpco_start_opt="--log-level warning --preload"
fi

# run
gunicorn mpcpyapp:app \
  --pid /tmp/pyapi-gunicorn.pid \
  --bind unix:/tmp/pyapp.socket \
  --bind 0.0.0.0:8888 \
  --workers 2 \
  --threads 4 \
  --timeout 30 \
  --backlog 400 \
  --limit-request-fields 50 \
  --limit-request-line 4094 \
  --worker-tmp-dir /dev/shm \
  --error-logfile - \
  --access-logfile - \
  ${gmpco_start_opt};
