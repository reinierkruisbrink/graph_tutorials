### Clean slate
```cypher
MATCH (n) DETACH DELETE n;
```

### Load the test data
```cypher
LOAD CSV WITH HEADERS FROM "file:////datasets/test.csv" AS line
MERGE (n:MyNode {Name: line.Source})
MERGE (m:MyNode {Name: line.Target})
MERGE (n) -[:TO {dist: toInteger(line.distance)}]-> (m);
```

### Find the outdegree of all nodes
```cypher
MATCH (n:MyNode)-[r]->()
RETURN n.Name as Node, count(r) as Outdegree
ORDER BY Outdegree
UNION
MATCH (a:MyNode)-[r]->(leaf)
WHERE NOT((leaf)-->())
RETURN leaf.Name as Node, 0 as Outdegree;
```

### Find the indegree of all nodes
```cypher
MATCH (n:MyNode)<-[r]-()
RETURN n.Name as Node, count(r) as Indegree
ORDER BY Indegree
UNION
MATCH (a:MyNode)<-[r]-(root)
WHERE NOT((root)<--())
RETURN root.Name as Node, 0 as Indegree;
```

### Find the degree of all nodes
```cypher
MATCH (n:MyNode)-[r]-()
RETURN n.Name, count(distinct r) as degree
ORDER BY degree;
```

### Find degree histogram of the graph
```cypher
MATCH (n:MyNode)-[r]-()
WITH n as nodes, count(distinct r) as degree;
```

### Save the degree of the node as a new node property
```cypher
MATCH (n:MyNode)-[r]-()
WITH n, count(distinct r) as degree
SET n.deg = degree
RETURN n.Name, n.deg;
```

### Construct the Adjacency Matrix of the graph
```cypher
MATCH (n:MyNode), (m:MyNode)
RETURN n.Name, m.Name,
CASE
WHEN (n)-->(m) THEN 1
ELSE 0
END as value;
```

### Construct the normalized Adjacency Matrix of the graph
```cypher
MATCH (n:MyNode), (m:MyNode)
RETURN n.Name, m.Name,
CASE
WHEN n.Name = m.Name THEN 1
WHEN (n)-->(m) THEN -1/(sqrt(toInteger(n.deg))*sqrt(toInteger(m.deg)))
ELSE 0
END as value;
```