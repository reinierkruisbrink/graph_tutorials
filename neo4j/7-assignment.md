### Load the gene gene associations file (adjust this query)
- Load the gene_gene_associations_50k.csv (instead of the text.csv),
- Define the node type to be TrialGene,
- Add a Name property to the source node and assign the OFFICIAL_SYMBOL_A column values to it,
- Add a Name property to the target node and assign the OFFICIAL_SYMBOL_B column values to it,
- Define the edge type to be AssociationType, 
- Give each edge a property named AssociatedWith and assign the content of the column in the dataset with the heading EXPERIMENTAL_SYSTEM.
```cypher
LOAD CSV WITH HEADERS FROM "file:////datasets/gene_gene_associations_50k.csv" AS line
MERGE (n:TrialGene {Name: line.OFFICIAL_SYMBOL_A})
MERGE (m:TrialGene {Name: line.OFFICIAL_SYMBOL_B})
MERGE (n) -[:AssociationType {AssociatedWith: line.EXPERIMENTAL_SYSTEM}]-> (m)
```

### View the graph partially
```cypher
match (n:TrialGene)-[r]-(m) return n, r, m limit 200
```

### Calculate number of nodes in the graph
```cypher
match (n:TrialGene) return count(n)
```

### Calculate the number of edges in the graph
```cypher
match (n)-[r:AssociationType]->() return count(r)
```

### Calculate the number of root nodes in the graph
```cypher
match (m)-[r:AssociationType]->(n)
where not (()-->(m))
return count(m)
```

### Calculate the number of loops in the graph
```cypher
match (n)-[r]->(n)
return n, r limit 10
```

### Submit the following query and report the results, what does it mean? (Hint: look at the result as text)
```cypher
match (n)-[r]->(m) 
where m <> n 
return distinct n, m, count(r)
```
It returns distinct pairs of nodes n and m (where m is not n) along with the count of relationships r between them. This helps in identifying how many times each pair of nodes are connected by a relationship. Run the following to inspect for a single gene:
```
match (n)-[r]->(m) where n.Name = 'MAP2K4' return n, m
```

### Submit the following query and report the results, what does it mean?
```cypher
match (n)-[r]->(m) 
where m <> n 
return distinct n, m, count(r) as myCount order by myCount desc limit 1
```
It returns the gene with the most non-self outgoing relations, which is BRCA1.

### Submit the following query and report the results, what does it mean?
```cypher
match p=(n {Name:'BRCA1'})-[:AssociationType*..2]->(m) 
return p
```
It returns all nodes within a distance of 2 from BRCA1.

### Count how many shortest paths there are between the node named BRCA1 and the node named NBR1
```cypher
match (source {Name: 'BRCA1'}), (destination {Name: 'NBR1'}),
    path = allShortestPaths((source)-[r*]->(destination))
return count(NODES(path))
```

###  Find the top 2 nodes with the highest outdegree
```cypher
match (n:TrialGene)-[r]->()
return n.Name as Node, count(r) as Outdegree
order by Outdegree desc limit 2
```

### Create the degree histogram for the network, then calculate how many nodes are in the graph having a degree of 3
```cypher
match (n:TrialGene)-[r]-()
with n, count(distinct r) as degree
set n.deg = degree
```
```
match (n) where n.deg=3 return count(n)
```