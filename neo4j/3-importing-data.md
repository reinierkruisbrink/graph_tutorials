### Clean slate by deleting all nodes
```cypher
match (n)-[r]-() delete n, r
```

### Import data from the folder (copied inside the container)
```cypher
LOAD CSV WITH HEADERS FROM "file:////datasets/test.csv" AS line
MERGE (n:MyNode {Name: line.Source})
MERGE (m:MyNode {Name: line.Target})
MERGE (n) -[:TO {dist: toInteger(line.distance)}]-> (m)  
```

### Clean again
```cypher
match (n)-[r]-() delete n, r
```

### Import the terrorist dataset
```cypher
LOAD CSV WITH HEADERS FROM "file:////datasets/terrorist_data_subset.csv" AS row
MERGE (c:Country {Name:row.Country})
MERGE (a:Actor {Name: row.ActorName, Aliases: row.Aliases, Type: row.ActorType})
MERGE (o:Organization {Name: row.AffiliationTo})
MERGE (a)-[:AFFILIATED_TO {Start: row.AffiliationStartDate, End: row.AffiliationEndDate}]->(o)
MERGE(c)<-[:IS_FROM]-(a);
```

### Inspect 25 nodes
```cypher
match (n) return n limit 25
```

### Inspect 1000 nodes (after updating the max nodes in settings)
```cypher
match (n) return n limit 1000
```