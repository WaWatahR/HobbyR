# -*- coding: utf-8 -*-
"""
Created on Sun Feb 26 12:21:14 2017

@author: WAllworth
"""

import pypyodbc
# from neo4j.v1 import GraphDatabase, basic_auth
# from neo4jrestclient import client
import pandas as pd
from py2neo import Graph
import re


def Employee(Name, Email, Phone):

    EmpExists = graph.run("""
    MATCH (e:Employee) WHERE e.Name = {Name}
    RETURN e
    """, Name=Name)

    if len(EmpExists.data()) == 0:
        query = """
        MERGE (e:Employee {Name: {Name}, Email: {Email}, Phone: {Phone}, LastUpdated: TIMESTAMP()})
        RETURN e
        """
    else:
        query = """
        MATCH (e:Employee)
        WHERE e.Name= {Name}
        SET e.Email = {Email}
        SET e.Phone = {Phone}
        SET e.LastUpdated = TIMESTAMP()
        RETURN e
        """

    result = graph.run(query,
                       Name=Name,
                       Email=Email,
                       Phone=Phone)
    return(result.data())
# EOF
# Employee('Warren Allworth', 'wallworth@aculocity.com','0844202146')


def Company(Name, Address, Phone):

    CompExists = graph.run("""
    MATCH (c:Company) WHERE c.Name = {Name}
    RETURN c
    """, Name=Name)

    if len(CompExists.data()) == 0:
        query = """
        MERGE (c:Company {Name: {Name}, Address: {Address}, Phone: {Phone}, LastUpdated: TIMESTAMP()})
        RETURN c
        """
    else:
        query = """
        MATCH (c:Company)
        WHERE c.Name= {Name}
        SET c.Address = {Address}
        SET c.Phone = {Phone}
        SET c.LastUpdated = TIMESTAMP()
        RETURN c
        """

    result = graph.run(query,
                       Name=Name,
                       Address=Address,
                       Phone=Phone)
    return(result.data())
# EOF
# Company('Aculocity', '625 Roger Williams Ave, Highland Park, IL 60035','+1 847-780-0205')


def Department(Name, Accronym):

    DepExists = graph.run("""
    MATCH (d:Department) WHERE d.Name = {Name}
    RETURN d
    """, Name=Name)

    if len(DepExists.data()) == 0:
        query = """
        MERGE (d:Department {Name: {Name}, Accronym: {Accronym}, LastUpdated: TIMESTAMP()})
        RETURN d
        """
    else:
        query = """
        MATCH (d:Department)
        WHERE d.Name= {Name}
        SET d.Accronym = {Accronym}
        SET d.LastUpdated = TIMESTAMP()
        RETURN d
        """

    result = graph.run(query,
                       Name=Name,
                       Accronym=Accronym)
    return(result.data())
# EOF
# Department('Sales', 'SL')


def MasterData(Name, Description=''):

    DataExists = graph.run("""
    MATCH (d:MasterData) WHERE d.Name = {Name}
    RETURN d
    """, Name=Name)

    if len(DataExists.data()) == 0:
        query = """
        MERGE (d:MasterData {Name: {Name}, Description: {Description}, LastUpdated = TIMESTAMP()})
        RETURN d
        """
    else:
        query = """
        MATCH (d:MasterData)
        WHERE d.Name= {Name}
        SET d.Description={Description}
        SET d.LastUpdated = TIMESTAMP()
        RETURN d
        """

    result = graph.run(query,
                       Name=Name,
                       Description=Description)
    return(result.data())
# EOF
# MasterData('Customer', 'A unique list of customers defined by address')
# MasterData('Truck', 'Truck attributes that uniquely identify a truck')
# MasterData('Part/BOM', 'A unique list of parts and BOMs without revision or version')
# MasterData('Contact', 'A unique list of people')
# MasterData('Supplier', 'Vendors and suppliers that provide parts to Parts and Autocar')


def System(Name, SystemName='', Description='', HostingLocation='', Active=1):

    SysExists = graph.run("""
    MATCH (s:System) WHERE s.Name = {Name}
    RETURN s
    """, Name=Name)

    if len(SysExists.data()) == 0:
        query = """
        MERGE (s:System {Name: {Name}, SystemName = {SystemName}, Description: {Description}, HostingLocation={HostingLocation}, Active={Active},LastUpdated = TIMESTAMP()})
        RETURN s
        """
    else:
        query = """
        MATCH (s:System)
        WHERE s.Name= {Name}
        SET s.SystemName={SystemName}
        SET s.Description={Description}
        SET s.HostingLocation={HostingLocation}
        SET s.Active = {Active}
        SET s.LastUpdated = TIMESTAMP()
        RETURN s
        """

    result = graph.run(query,
                       Name=Name,
                       SystemName=SystemName,
                       HostingLocation=HostingLocation,
                       Active=Active,
                       Description=Description)
    return(result.data())
# EOF
# System(Name='AXIS', SystemName='Autocar Xpeditor Information System', Description ='', HostingLocation='Hagerstown', Active=1)


def Table(Name, Description='', Type='Table', Active=1):

    TableExists = graph.run("""
    MATCH (t:Table) WHERE t.Name ={Name}
    RETURN t
    """, Name=Name)

    if len(TableExists.data()) == 0:
        query = """
        MERGE (t:Table {Name: {Name}, Description: {Description}, Active: {Active}, Type: {Type}, LastUpdated: TIMESTAMP()}) 
        RETURN t
        """
    else:
        query = """
        MATCH (t:Table)
        WHERE t.Name = {Name}
        SET t.Description= {Description}
        SET t.Active = {Active}
        SET t.Type = {Type}
        SET t.LastUpdated = TIMESTAMP()
        RETURN t
        """

    result = graph.run(query,
                       Name=Name,
                       Description=Description,
                       Type=Type,
                       Active=Active)
    return(result.data())
# EOF
# Table(Name='Test', Description='Just a test table I setup', Type = 'Table', Active=1)


def Column(Name, Datatype, Length, Description, Active):

    colExists = graph.run("""
    MATCH (c:Column) WHERE c.Name= {Name}
    RETURN c
    """, Name=Name)

    if len(colExists.data()) == 0:
        query = """
        MERGE (c:Column {Name: {Name}, Datatype: {Datatype}, Length: {Length}, Description: {Description}, Active: {Active}, LastUpdated: TIMESTAMP()}) 
        RETURN c
        """
    else:
        query = """
        MATCH (c:Column)
        WHERE c.Name = {Name}
        SET c.Description = {Description}
        SET c.Datatype = {Datatype}
        SET c.Length = {Length}
        SET c.Active = {Active}
        SET c.LastUpdated = TIMESTAMP()
        RETURN c
        """

    result = graph.run(query,
                       Name=Name,
                       Datatype=Datatype,
                       Length=Length,
                       Description=Description,
                       Active=Active)
    return(result.data())
# EOF
# Column('TestCol', 'int', 10, 'A test column required for testing', 1)


def SystemTableRel(SysName, TableName, Active=1):

    relExists = graph.run("""
    MATCH (s:System)-[r:HAS_TABLE]-(t:Table)
    WHERE s.Name={SysName} and t.Name={TableName}
    RETURN s,r,t
    """, SysName=SysName, TableName=TableName)

    if len(relExists.data()) == 0:
        query = """
        MATCH (s:System),(t:Table)
        WHERE s.Name={SysName} and t.Name={TableName}
        MERGE (s)-[r:HAS_TABLE {LastUpdated: TIMESTAMP(), Active: {Active} }]-(t)
        RETURN s,r,t
        """

    else:
        query = """
        MATCH (s:System)-[r:HAS_TABLE]-(t:Table)
        WHERE s.Name={SysName} and t.Name={TableName}
        SET r.Active = {Active}
        SET r.LastUpdated = TIMESTAMP()
        RETURN s,r,t
        """

    result = graph.run(query,
                       SysName=SysName,
                       TableName=TableName,
                       Active=Active)
    return(result.data())
# EOF
# SystemTableRel('AXIS', 'Test', 1)


def Relationship(E1Type, E2Type, RelType, E1Name, E2Name, Active=1):

    test = """
    MATCH (e1:{E1Type} )-[r:{RelType}]-(e2:{E2Type})
    WHERE e1.Name = {E1Name} and e2.Name = {E2Name}
    RETURN e1,r,e2"""

    test = re.sub('{E1Type}', E1Type, test)
    test = re.sub('{E2Type}', E2Type, test)
    test = re.sub('{RelType}', RelType, test)

    relExists = graph.run(test,
                          E1Name=E1Name,
                          E2Name=E2Name)

    _temp_ = relExists.data()
    if len(_temp_) == 0:
        query = """
        MATCH (e1:{E1Type} ),(e2:{E2Type})
        WHERE e1.Name = {E1Name} AND e2.Name = {E2Name}
        CREATE (e1) - [r:{RelType} {LastUpdated:TIMESTAMP(), Active:{Active}}] -> (e2)
        RETURN e1,r,e2
        """
    else:
        query = """
        MATCH (e1:{E1Type})-[r:{RelType}]->(e2:{E2Type})
        WHERE e1.Name = {E1Name} AND e2.Name = {E2Name}
        SET r.LastUpdated = TIMESTAMP()
        SET r.Active = {Active}
        RETURN e1,r,e2
        """

    query = re.sub('{E1Type}', E1Type, query)
    query = re.sub('{E2Type}', E2Type, query)
    query = re.sub('{RelType}', RelType, query)
    
    result = graph.run(query,
                        E1Name=E1Name,
                        E2Name=E2Name,
                        Active=Active)
    return(result.data())

# Relationship('System', 'Table', 'HAS_TABLE', 'EPC', 'Test')

def TableColumnRel(TableName, ColumnName, Active=1):

    # Test to see if column already exists
    relExists = graph.run("""
    MATCH (t:Table)-[r:HAS_COLUMN]-(c)
    WHERE t.Name = {TableName} and c.Name = {ColumnName}
    RETURN t,r,c""", TableName=TableName, ColumnName=ColumnName)

    if len(relExists.data()) == 0:
        query = """
        MATCH (t:Table)-[r:HAS_COLUMN]-(c:Column) 
        WHERE t.Name = {TableName} and c.Name = {ColumnName}
        MERGE (t) -[r:HAS_COLUMN { LastUpdated: TIMESTAMP(), Active: {Active} }] -(c)
        RETURN t,r,c
        """
    else:
        # Update the column definition
        query = """
        MATCH (t:Table)-[r:hasColumn]-(c)
        WHERE t.Name = {TableName} and c.Name = {ColumnName}
        SET r.Definition = {ColDefinition}
        SET r.LastUpdate = TIMESTAMP()
        RETURN t,r,c
        """

    out = graph.run(query,
                    TableName=TableName,
                    ColumnName=ColumnName,
                    ColDefinition=ColDefinition)
    return(out.current())
# EOF


def EmployeeCompanyMap(EmployeeName, CompanyName):

    relExists = graph.run("""
    MATCH  (e:Employee)-[r:WORKS_FOR]-(c:Company)
    WHERE e.Name = {EmployeeName} AND c.Name = {CompanyName}
    RETURN e,r,c
    """, EmployeeName=EmployeeName, CompanyName=CompanyName)

    if len(relExists.data()) == 0:
        query = """
        MATCH (e:Employee),(c:Company)
        WHERE e.Name = {EmployeeName} AND c.Name = {CompanyName}
        MERGE (e) - [r:WORKS_FOR]-(c)
        RETURN e,r,c
        """

        result = graph.run(query,
                           EmployeeName=EmployeeName,
                           CompanyName=CompanyName)
        return(result.data())
    else:
        return("Already Exists")
# EOF

# Define Info Schema SQL Query 
InfoSchema = "SELECT \
	TABLE_NAME AS TableName, \
	COLUMN_NAME AS ColumnName, \
	DATA_TYPE AS DataType, \
	CASE \
		WHEN DATA_TYPE='int' OR DATA_TYPE='Decimal' OR DATA_TYPE='money' OR DATA_TYPE='float' OR DATA_TYPE='tinyint'  OR DATA_TYPE='smallint' OR DATA_TYPE='bigint'  OR DATA_TYPE='real' THEN NUMERIC_PRECISION \
		WHEN DATA_TYPE='varchar' OR DATA_TYPE='nvarchar' OR DATA_TYPE='text' OR DATA_TYPE='image' OR DATA_TYPE='char' OR DATA_TYPE='nchar' THEN CHARACTER_MAXIMUM_LENGTH \
		WHEN DATA_TYPE='datetime' OR DATA_TYPE='date' THEN DATETIME_PRECISION \
		WHEN DATA_TYPE='bit' THEN 1 \
		WHEN DATA_TYPE='uniqueidentifier' THEN 36 \
	END AS [Length] \
FROM INFORMATION_SCHEMA.COLUMNS \
WHERE TABLE_NAME <> 'sysdiagrams'"

# Initialize connection to graph DB. This variable is available to functions
graph = Graph("http://gvwacce02:7474", username="neo4j", password="Start123")


