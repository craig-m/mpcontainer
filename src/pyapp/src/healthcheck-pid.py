#
# check mpcpyapp.py is running under gunicorn
#

import sys
import os
from pathlib import Path

# check pid file exists
pidfile = open("/tmp/pyapi-gunicorn.pid")
gpid = pidfile.read().replace("\n", "")
pidfile.close()
pidstatefile = os.path.exists("/proc/" + gpid + "/status")

# check socket created
sockfile = os.path.exists('/tmp/pyapp.socket')


if sockfile and pidstatefile:
    #print('all good')
    exit(0)
else:
    exit(1)