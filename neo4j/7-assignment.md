### Load the gene gene associations file (adjust this query)
- Load the gene_gene_associations_50k.csv (instead of the text.csv),
- Define the node type to be TrialGene,
- Add a Name property to the source node and assign the OFFICIAL_SYMBOL_A column values to it,
- Add a Name property to the target node and assign the OFFICIAL_SYMBOL_B column values to it,
- Define the edge type to be AssociationType, 
- Give each edge a property named AssociatedWith and assign the content of the column in the dataset with the heading EXPERIMENTAL_SYSTEM.
```cypher
LOAD CSV WITH HEADERS FROM "file:////datasets/test.csv" AS line
MERGE (n:MyNode {Name: line.Source})
MERGE (m:MyNode {Name: line.Target})
MERGE (n) -[:TO {dist: toInteger(line.distance)}]-> (m)
```

### View the graph partially
```cypher
...
```

### Calculate number of nodes in the graph
```cypher
...
```

### Calculate the number of edges in the graph
```cypher
...
```

### Calculate the number of root nodes in the graph
```cypher
...
```

### Calculate the number of loops in the graph
```cypher
...
```

### Submit the following query and report the results, what does it mean? (Hint: look at the result as text)
```cypher
match (n)-[r]->(m) 
where m <> n 
return distinct n, m, count(r)
```

### Submit the following query and report the results, what does it mean?
```cypher
match (n)-[r]->(m) 
where m <> n 
return distinct n, m, count(r) as myCount order by myCount desc limit 1
```

### Submit the following query and report the results, what does it mean?
```cypher
match p=(n {Name:'BRCA1'})-[:AssociationType*..2]->(m) 
return p
```
It returns all nodes within a distance of 2 from BRCA1.

### Count how many shortest paths there are between the node named BRCA1 and the node named NBR1
```cypher
...
```

###  Find the top 2 nodes with the highest outdegree
```cypher
...
```

### Create the degree histogram for the network, then calculate how many nodes are in the graph having a degree of 3
```cypher
...
```