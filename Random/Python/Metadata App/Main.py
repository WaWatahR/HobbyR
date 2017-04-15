# -*- coding: utf-8 -*-
"""
Created on Sun Feb 26 12:21:14 2017

@author: WAllworth
"""
from MetadataAPI import *

solutions = pypyodbc.connect('Driver={SQL Server};Server=gvwac20vm3;Database=AutocarSolutions;uid=Autocar_reader;pwd=NR53yxBN')
sdhop = pypyodbc.connect('Driver={SQL Server};Server=gvwdevdb01;Database=SDHOperational')

# Automate table loading from source
sqlresults = pd.read_sql_query(InfoSchema, solutions)

System('Solutions', 'Autocar Solutions', '', '', 1)
TableList = sqlresults['tablename'].unique()

for t in TableList:
    _temp_ = Table(Name=t, Description='', Active=1)
    _temp2_ = Relationship('System', 'Table', 'HAS_TABLE', 'Solutions', t, Active=1)
    
# List Master Tables from SDHOperational
SqlResults = pd.read_sql_query(InfoSchema, sdhop)

MasterTables = SqlResults[SqlResults["tableschema"]=="Master"]["tablename"].unique()

for i in MasterTables:
    MasterData(Name=i)
    
# Ingest metadata tables in neo4j
q = 'SELECT * \
    FROM [SDHOperational].[Master].[DictionaryTables]'

TableMeta = pd.read_sql_query(q, sdhop)
# TableMeta[TableMeta['description']=='NULL']['description'] = ''

for t in range(0,len(TableMeta)):
    print(t)
    Table(TableMeta.loc[t,'name'], TableMeta.loc[t,'description'], Type=TableMeta.loc[t,'tabletype'],Active=1)
    
# Add in columns
q= 'SELECT \
      dc.[Name] \
      ,[ColumnDataType] \
      ,[ColumnLength] \
      ,[DataPrecision] \
      ,dc.[Description] \
      ,dt.Name as [Table] \
  FROM [SDHOperational].[Master].[DictionaryColumns] dc \
  LEFT JOIN [SDHOperational].[Master].[DictionaryTables] dt ON dc.TableId=dt.TableId'

ColMeta = pd.read_sql_query(q, sdhop)

for c in range(0, len(ColMeta)):
    print(c)
    # Column(ColMeta.loc[c, 'name'], ColMeta.loc[c, 'columndatatype'], ColMeta.loc[c, 'columnlength'], ColMeta.loc[c, 'description'])
    Relationship('Table', 'Column', 'HAS_COLUMN', ColMeta.loc[c, 'table'], ColMeta.loc[c, 'name'])

# OWNS Relationship and creates system
q = "SELECT \
      CompanyName \
      , SystemName \
      ,CASE WHEN [ShortName]='Website' THEN CompanyName + ' Website'  \
	  ELSE [ShortName] END AS [ShortName] \
    FROM [ATACFramework].[dbo].[CompanySystem] cs \
    LEFT JOIN [ATACFramework].[dbo].Company c ON c.CompanyID= cs.CompanyID"
    
OwnsMeta = pd.read_sql_query(q, sdhop)

for o in range(0, len(OwnsMeta)):
    print(o)
    System(OwnsMeta.loc[o,'shortname'],OwnsMeta.loc[o,'systemname'])
    Relationship('Company', 'System', 'OWNS', OwnsMeta.loc[o, 'companyname'], OwnsMeta.loc[o,'shortname'])