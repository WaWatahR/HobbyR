# -*- coding: utf-8 -*-
"""
Created on Fri Mar  3 10:48:03 2017

@author: WAllworth
"""

import paramiko
from eve import Eve 

client = paramiko.SSHClient()
client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
client.connect(hostname='gvwacce02', username='wallworth', password='W@rren01')
stdin, stdout, stderr = client.exec_command("echo \"count 'AutocarQMSPhotos', \
INTERVAL=>1\" | hbase shell")

output = list()
for line in stdout:
    output.append(line.strip("\n"))

client.close()

app = Eve()
 

import os
from eve import Eve

# Heroku support: bind to PORT if defined, otherwise default to 5000.
if 'PORT' in os.environ:
    port = int(os.environ.get('PORT'))
    # use '0.0.0.0' to ensure your REST API is reachable from all your
    # network (and not only your computer).
    host = '0.0.0.0'
else:
    port = 5050
    host = '127.0.0.1'

app = Eve()


if _name_ == '__main__':
    app.run(host=host, port=port)
    