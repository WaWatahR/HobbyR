# -*- coding: utf-8 -*-
"""
Created on Sun Feb 26 11:04:32 2017

@author: WAllworth
"""

from neo4j.v1 import GraphDatabase, basic_auth

driver = GraphDatabase.driver("bolt://localhost:7687", auth=basic_auth("neo4j", "neo4j"))
session = driver.session()

session.run("CREATE (a:Person {name: {name}, title: {title}})",
          {"name": "Arthur", "title": "King"})

result = session.run("MATCH (a:Person) WHERE a.name = {name} "
                   "RETURN a.name AS name, a.title AS title",
                   {"name": "Arthur"})

for record in result:
  print("%s %s" % (record["title"], record["name"]))

session.close()
  
from py2neo import Graph, Path
graph = Graph("http://localhost:7474/db/data/", user='neo4j', password='neo4j')

tx = graph.cypher.begin()

for rel in graph.match(start_node=Arthur):
    print(rel.end_node()["name"])

for name in ["Alice", "Bob", "Carol"]:
    tx.append("CREATE (person:Person {name:{name}}) RETURN person", name=name)
alice, bob, carol = [result.one for result in tx.commit()]

friends = Path(alice, "KNOWS", bob, "KNOWS", carol)
graph.create(friends)