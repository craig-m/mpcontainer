#
# check mpcpyapp.py is running under gunicorn
#

import sys
import os
from pathlib import Path


# file that contains process id of gunicorn
pidfile = '/tmp/pyapi-gunicorn.pid'
pidfile_i = os.stat(pidfile)

# check file is readable and OK size
if os.path.isfile(pidfile) and os.access(pidfile, os.R_OK) and 8 > pidfile_i.st_size:
    pidfilec = open(pidfile)
    pypid = pidfilec.read().replace("\n", "")
    pidfilec.close()
    # read status
    procstat = os.path.isfile("/proc/" + pypid + "/status")
else:
    procstat = False


# location of socket file
sockfile = '/tmp/pyapp.socket'
# check socket created
sockstat = os.path.exists(sockfile)


if sockstat and procstat:
    if sys.stdout.isatty():
        print( 'OK pid: ' + pypid )
    exit(0)
else:
    if sys.stdout.isatty():
        print( 'ERROR')
    exit(1)