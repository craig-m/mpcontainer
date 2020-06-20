# MPContainer Pyapp
#
# desc: Flask is a micro web framework written in Python
# docs: https://flask.palletsprojects.com/en/1.1.x/

import flask
import logging
import os
import socket
from flask import Flask, request
from flask import Flask, render_template
from mpd import MPDClient

LISTENIP = "0.0.0.0"
LISTENPORT = 8888
DEBUG = False
app = Flask(__name__)


#
# functions
#


#
# routes
#

# default
@app.route('/')
def index():
    html = "pyapp"
    return html.format()

@app.route('/host/hostname/', methods=['GET'])
def hostmyname():
    html = "{hostname}"
    return html.format(hostname=socket.gethostname())

@app.route('/client/ip/', methods=['GET'])
def cliip():
    return request.environ.get('HTTP_X_REAL_IP', request.remote_addr)

@app.route('/hello/')
@app.route('/hello/<name>')
def hello(name=None):
    return render_template('hello.html', name=name)

# pages
@app.route("/pages/about/", methods=['GET'])
def pageabout():
    return render_template('about.html')


#
# Main
#

if __name__ == '__main__':
    app.run(host=LISTENIP, port=LISTENPORT, debug=DEBUG)
