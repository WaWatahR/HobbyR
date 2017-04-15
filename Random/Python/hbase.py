# -*- coding: utf-8 -*-
"""
Created on Mon Feb 20 15:22:27 2017

@author: WAllworth
"""
import os
import base64
import requests
import json
import happybase

# change workding directory
os.chdir("D:/HBase")

a = 'eW91ciB0ZXh0'
base64.b64decode(a).decode()

# list of tables
query = 'http://gvwacce02:8080/'
headers = {'Accept': 'application/json'}
r = requests.get(query, headers=headers)
payload = json.loads(str(r.content.decode()))

tablelist = list()
for i in range(len(payload['table'])):
    tablelist.append(payload['table'][i]['name'])

# Get picture
query = "http://gvwacce03:8080/AutocarQMSPhotos/20013352.*/DefectPhoto?column"
headers = {'Accept': 'application/json'}
r = requests.get(query, headers=headers)
payload = json.loads(str(r.content.decode()))

key = base64.b64decode(payload['Row'][0]['key']).decode()

image = base64.b64decode(payload['Row'][0]['Cell'][0]['$'])

# Get all truck photos
query = "http://gvwacce03:8080/AutocarQMSPhotos/20012921*"
headers = {'Accept': 'application/json'}
r = requests.get(query, headers=headers)
payload = json.loads(str(r.content.decode()))


for i in range(0, len(payload['Row'])):
    # print(base64.b64decode(payload['Row'][i]['key']).decode())
    for j in range(0, len(payload['Row'][i]['Cell'])):
        fh = open(base64.b64decode(payload['Row'][i]['key']).decode() + "_" + str(j)+".png", "wb")
        fh.write(base64.b64decode(payload['Row'][i]['Cell'][j]['$']))
        fh.close()
        
    
