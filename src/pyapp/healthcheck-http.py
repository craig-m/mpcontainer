#
# Error if we don't get a http 200 back from mpcpyapp.py ping url
#

import http.client
import sys

conn = http.client.HTTPConnection('localhost', 8888, timeout=10)
conn.request("GET", "/host/ping/stat")
r1 = conn.getresponse()
rstat = r1.status
conn.close()

if rstat != 200:
    sys.exit("ERROR connecting to mpcpyapp on localhost")