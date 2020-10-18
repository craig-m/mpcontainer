# MPContainer Pyapp
#
# desc: Flask is a micro web framework written in Python
# docs: https://flask.palletsprojects.com/en/1.1.x/

import flask
import logging
import os
import platform
import socket
from datetime import datetime
from flask import Flask, request, render_template
from flask_caching import Cache
from mpd import (MPDClient, CommandError)
from socket import error as SocketError

# config in confmpd/__init__.py
from confmpd import *

app = Flask(__name__)
cache = Cache(app, config={'CACHE_TYPE': 'simple'})

# Pyapp in debug mode?
DEBUG = os.getenv('mpypyapp_debug')

#
# functions
#

def mpdConnect(client, con_id):
    client.timeout = 10
    client.idletimeoout = None
    try:
        client.connect(**con_id)
    except SocketError:
        return False
    return True

def mpdAuth(client, secret):
    client.timeout = 10
    client.idletimeoout = None
    try:
        client.password(secret)
    except CommandError:
        return False
    return True

#
# routes
#

# default

@app.route('/')
def index():
    html = "mpc-pyapp"
    return html.format()

# container info

@app.route('/host/hostname/')
def hostmyname():
    html = "{hostname}"
    return html.format(hostname=socket.gethostname())

@app.route('/host/env/')
def hostenvtest():
    html = "{envinfo}"
    return html.format(envinfo=os.getenv('env_mpypyapp_envtest'))

@app.route('/host/date/')
def thedate():
    html = "{date}"
    return html.format(date=datetime.now())

# health check
@app.route('/host/ping/stat')
def healthping():
    html = "py-pong"
    return html.format()

# client info

@app.route('/client/ip/')
def cliip():
    if request.environ.get('X-Forwarded-For', request.remote_addr):
        return request.environ.get('X-Forwarded-For', request.remote_addr)
    else:
        return request.environ.get('HTTP_X_REAL_IP', request.remote_addr)

@app.route('/client/agent/')
def cliagent():
    return request.headers.get('User-Agent')

# hello
@app.route('/hello/')
@app.route('/hello/<name>')
def hello(name=None):
    return render_template('hello.html', name=name)

# pages
@app.route("/pages/about.html")
@cache.cached(timeout=60)
def pageabout():
    return render_template('about.html')

# MPD

@app.route("/mpd/stat.json")
@cache.cached(timeout=300)
def mpdstat():
    client = MPDClient()
    if mpdConnect(client, MPDCON_ID):
        if DEBUG:
            print('Connected to: ' + MPDURL + ' on:',MPDPORT)
    if mpdAuth(client, MPDPASS):
        if DEBUG:
            print('authed to: ' + MPDURL + ' on:',MPDPORT)
        # output
        return client.stats(), client.disconnect()
    else:
        print('error: mpd connection failed')
        client.disconnect()
        html = "stats error"
        return html.format()

@app.route("/mpd/current.json")
@cache.cached(timeout=60)
def mpdnowplay():
    client = MPDClient()
    mpdConnect(client, MPDCON_ID)
    mpdAuth(client, MPDPASS)
    return client.currentsong(), client.disconnect()

#
# Main
#

if __name__ == '__main__':
    app.run(host=LISTENIP, port=LISTENPORT, debug=DEBUG)
