#!/usr/bin/python
from flup.server.fcgi import WSGIServer
from habapi import app

if __name__ == '__main__':
	WSGIServer(app).run()
#	WSGIServer(app, bindAddress=('127.0.0.1', 9000)).run()
