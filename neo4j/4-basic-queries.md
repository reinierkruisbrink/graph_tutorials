### Counting the number of nodes
```cypher
match (n:MyNode)
return count(n)
;
```

### Counting the number of edges
```cypher
match (n:MyNode)-[r]->()
return count(r)
;
```

### Finding leaf nodes
```cypher
match (n:MyNode)-[r:TO]->(m)
where not ((m)-->())
return m
;
```

### Finding root nodes
```cypher
match (m)-[r:TO]->(n:MyNode)
where not (()-->(m))
return m
;
```

### Finding triangles
```cypher
MATCH (a:MyNode)-[:TO]->(b:MyNode)-[:TO]->(c:MyNode)-[:TO]->(a)
RETURN a, b, c
;
```

### Finding 2nd neighbors of D
```cypher
match (a)-[:TO*..2]-(b)
where a.Name='D'
return distinct a, b
;
```

### Clean the slate
```cypher
MATCH (n) DETACH DELETE n
;
```

### Load the terrorist data
```cypher
load CSV WITH HEADERS from "file:////datasets/terrorist_data_subset.csv" as row
merge (c:Country {Name:row.Country})
merge (a:Actor {Name: row.ActorName, Aliases: row.Aliases, Type: row.ActorType})
merge (o:Organization {Name: row.AffiliationTo})
merge (a)-[:AFFILIATED_TO {Start: row.AffiliationStartDate, End: row.AffiliationEndDate}]->(o)
merge(c)<-[:IS_FROM]-(a)
;
```

### Finding the types of a node
```cypher
match (n)
where n.Name = 'Afghanistan'
return labels(n)
;
```

### Finding the label of an edge
```cypher
match (n {Name: 'Afghanistan'})<-[r]-()
return distinct type(r)
;
```

### Finding all properties of a node (select text result)
```cypher
match (n:Actor)
return * limit 20
;
```

### Clean the slate
```cypher
MATCH (n) DETACH DELETE n
;
```

### Load the new version of the dataset
```cypher
load CSV WITH HEADERS from 'file:////datasets/test2.csv' as line
merge (n:MyNode {Name: line.Source})
merge (m:MyNode {Name: line.Target})
merge (n)-[:TO {dist: line.Distance}]->(m)
;
```

### Finding loops
```cypher
match (n)-[r]->(n)
return n, r limit 10
;
```

### Finding multigraphs
```cypher
match (n)-[r1]->(m), (n)-[r2]-(m)
where r1 <> r2
return n, r1, r2, m
;
```

### Finding the induced subgraph given a set of nodes
```cypher
match (n)-[r:TO]-(m)
where n.Name in ['A', 'B', 'C', 'D', 'E'] and m.Name in ['A', 'B', 'C', 'D', 'E']
return n, r, m
;
```