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


#
# run gunicorn
#

# Start with Dev or Prod options?
# note: container default is Prod
if [[ $env_mpcpyapp_dev == "true" ]]; then
  echo "--- env_mpcpyapp_dev ${env_mpcpyapp_dev} (Dev mode ON) ---";

  gmpco_start_opt="--log-level info --reload --reload-engine auto"
  export mpypyapp_debug="True"
  export FLASK_ENV=development

else
  echo "--- production gunicorn settings ---"

  gmpco_start_opt="--log-level warning --preload"
  export mpypyapp_debug="False" 
  export FLASK_ENV=production

  # production checks
  if [[ ! 644 = $(stat -c '%a' /pyapp/mpcpyapp.py) ]]; then
    echo "ERROR: file perm not safe"
    exit 1;
  fi
fi

#export env_mpypyapp_envtest=start_script

# start
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
