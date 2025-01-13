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

### View the graph
```cypher
MATCH (n:MyNode)-[r]->(m)
RETURN n, r, m;
```

### Finding paths between specific nodes
```cypher
MATCH p=(a)-[:TO*]->(c) 
WHERE a.Name='H' and c.Name='P' 
RETURN p ORDER BY length(p) ASC LIMIT 1;
```

### Finding the length between specific nodes
```cypher
MATCH p=(a)-[:TO*]->(c) 
WHERE a.Name='H' AND c.Name='P' 
RETURN length(p) ORDER BY length(p) LIMIT 1;
```

### Finding a shortest path between specific nodes
```cypher
MATCH p=shortestPath((a)-[:TO*]->(c)) 
WHERE a.Name='A' AND c.Name='P' 
RETURN p, length(p) LIMIT 1;
```

### All Shortest Paths
```cypher
MATCH (source {Name: 'A'}), (destination {Name: 'P'}),
    path = allShortestPaths((source)-[:TO*]->(destination))
RETURN [node IN NODES(path) | node.Name] AS Paths;
```

### All Shortest Paths with Path Conditions
```cypher
MATCH (source {Name: 'A'}), (destination {Name: 'P'}),
    p = allShortestPaths((source)-[:TO*]->(destination))
WHERE length(p) > 5
RETURN [n IN nodes(p) | n.Name] AS Paths, length(p);
```

### Diameter of the graph
```cypher
MATCH (n:MyNode), (m:MyNode) 
WHERE n <> m 
WITH n, m 
MATCH p=shortestPath((n)-[*]->(m)) 
RETURN n.Name, m.Name, length(p)
ORDER BY length(p) DESC LIMIT 1;
```

### Diameter of the graph (5)
```cypher
MATCH (n:MyNode), (m:MyNode) 
WHERE n <> m 
WITH n, m 
MATCH p=shortestPath((n)-[*]->(m)) 
RETURN n.Name, m.Name, length(p)
ORDER BY length(p) DESC LIMIT 5;
```

### Extracting and computing with node and properties
```cypher
MATCH p = (a)-[:TO*]->(c)
WHERE a.Name='H' AND c.Name='P' 
RETURN [n IN nodes(p) | n.Name] AS Nodes, length(p) AS PathLength,
REDUCE(s = 0, e IN relationships(p) | s + toInteger(e.dist)) AS PathDist 
ORDER BY PathDist ASC LIMIT 1;
```

### Dijkstra's algorithm for a specific target node
```cypher
MATCH (from:MyNode {Name:'A'}), (to:MyNode {Name:'P'}),
path = shortestPath((from)-[:TO*]->(to))
WITH REDUCE(dist = 0, rel IN relationships(path) | dist + toInteger(rel.dist)) AS distance, path
RETURN path, distance;
```

### Dijkstra's algorithm - Single Source Shortest Path (SSSP)
```cypher
MATCH (from: MyNode {Name:'A'}), (to: MyNode)
WHERE from <> to
MATCH path = shortestPath((from)-[:TO*]->(to))
WITH from, to, path, REDUCE(dist = 0, rel in relationships(path) | dist + toInteger(rel.dist)) AS distance
RETURN from, to, path, distance 
ORDER BY distance DESC;
```

### Graph not containing a selected node
```cypher
MATCH (n)-[r:TO]->(m) 
WHERE n.Name <> 'D' AND m.Name <> 'D' 
RETURN n, r, m;
```

### Shortest path over a Graph not containing a selected node
```cypher
MATCH p = shortestPath((a {Name: 'A'})-[:TO*]-(b {Name: 'P'}))
WHERE NOT 'D' IN [n IN nodes(p) | n.Name]
RETURN p, length(p);
```

### Graph not containing the immediate neighborhood of a specified node
```cypher
MATCH (d {Name:'D'})-[:TO]-(b)
WITH collect(distinct b.Name) AS neighbors
MATCH (n)-[r:TO]->(m)
WHERE 
NOT (n.Name IN (neighbors+'D')) 
AND 
NOT (m.Name IN (neighbors+'D')) 
RETURN n, r, m;
```

### Graph not containing the immediate neighborhood of a specified node (part 2)
```cypher
MATCH (d {Name:'D'})-[:TO]-(b)
WITH collect(distinct b.Name) AS neighbors
MATCH (n)-[r:TO]->(m)
WHERE 
NOT (n.Name IN (neighbors+'D')) 
AND 
NOT (m.Name IN (neighbors+'D')) 
MATCH (d {Name:'D'})-[:TO]-(b)-[:TO]->(leaf)
WHERE NOT((leaf)-->())
RETURN (leaf), n, r, m;
```

### Graph not containing a selected neighborhood
```cypher
MATCH (a {Name: 'F'})-[:TO*..2]-(b) 
WITH collect(distinct b.Name) AS MyList 
MATCH (n)-[r:TO]->(m) 
WHERE NOT(n.Name IN MyList) AND NOT (m.Name IN MyList) 
RETURN DISTINCT n, r, m;
```