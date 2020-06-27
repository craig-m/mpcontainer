# print out mpd stats
#
# https://github.com/Mic92/python-mpd2/tree/master/examples (base source)
# https://python-mpd2.readthedocs.io/en/latest/index.html

import sys
import pprint

from mpd import (MPDClient, CommandError)
from socket import error as SocketError

# the mpd server conf
from confmpd import *

DEBUG = True

#
# functions
#

def mpdConnect(client, con_id):
    """
    Simple wrapper to connect to MPD.
    """
    client.timeout = 10
    client.idletimeoout = None
    try:
        client.connect(**con_id)
    except SocketError:
        return False
    return True

def mpdAuth(client, secret):
    """
    Authenticate to MPD.
    """
    client.timeout = 10
    client.idletimeoout = None
    try:
        client.password(secret)
    except CommandError:
        return False
    return True

def main():
    # MPD object instance
    client = MPDClient()
    if mpdConnect(client, MPDCON_ID):
        if DEBUG:
            print('Connected to: ' + MPDURL + ' on:',MPDPORT)
    else:
        print('failed to connect to MPD server.')
        sys.exit(1)
    if mpdAuth(client, MPDPASS):
        if DEBUG:
            print('Authenticated')
    else:
        print('error: Authentication failed')
        client.disconnect()
        sys.exit(2)
    # Fancy output
    pp = pprint.PrettyPrinter(indent=4)
    # Print MPD info & disconnect
    print('\nCurrent MPD state:')
    pp.pprint(client.status())
    print('\nMusic Library stats:')
    pp.pprint(client.stats())
    print('\nmpd version:')
    pp.pprint(client.mpd_version)
    client.disconnect()
    sys.exit(0)

#
# Main
#

if __name__ == "__main__":
    main()
