# -*- coding: utf-8 -*-
"""
Created on Thu Feb 16 16:00:07 2017

@author: WAllworth
"""

import jaydebeapi
import jpype
import pandas as pd

# Create a connection to the DB2 instance on AS400
jar = 'C:/R/lib/jt400.jar' # location of the jdbc driver jar
args='-Djava.class.path=%s' % jar
jvm = jpype.getDefaultJVMPath()
jpype.startJVM(jvm, args)

dbcon = jaydebeapi.connect('com.ibm.as400.access.AS400JDBCDriver','jdbc:as400://10.22.0.2/acfiles',['R50USER','R50USER'])

#Read in a list of tables and schemas
df = pd.read_csv('C:/Users/wallworth/Documents/Parts/TableList.csv')
commands = dict('SELECT COUNT(*) FROM ' + df['Schema'] + '.' + df['TableName'])

curs = dbcon.cursor()

rowcount = list()
for c in commands:
    print(c)
    curs.execute(commands[c])
    temp =     
    rowcount.append(temp[0][0])



df1 = pd.DataFrame(rowcount, columns=["RowCount"])
df1.to_csv('C:/Users/wallworth/Documents/Parts/rowcount.csv', index=False)