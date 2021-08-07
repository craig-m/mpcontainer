#!/bin/bash

thedate=$(date)
thehost=$(hostname)
gmpco_start_opt=""

#
# checks before starting
#

if [[ pyapp = "$(whoami)" ]]; then
  echo "starting mpcpyapp at ${thehost} on ${thedate}";
else
  echo "ERROR: not running as pyapp";
  exit 1;
fi


#
# run gunicorn
#

# Start with Dev or Prod options? container default is Prod
if [[ $env_mpcpyapp_dev == "true" ]]; then

  echo "------- dev mode ON!! -------";
  gmpco_start_opt="--log-level info --reload --reload-engine auto"
  echo "gmpco_start_opt: ${gmpco_start_opt}";
  export mpypyapp_debug="True"
  export FLASK_ENV=development
  echo "----------------------------";

else

  echo "production settings";
  gmpco_start_opt="--log-level warning --preload"
  echo "gmpco_start_opt: ${gmpco_start_opt}";
  export mpypyapp_debug="False" 
  export FLASK_ENV=production

  # production checks
  if [[ ! 644 = $(stat -c '%a' /pyapp/mpcpyapp.py) ]]; then
    echo "ERROR: file perm not safe"
    exit 1;
  fi
fi


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