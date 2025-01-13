### Add a node incorrectly to an existing graph
```cypher
create (n:ToyNode {name:'Julian'})-[:ToyRelation {relationship: 'fiancee'}]->(m:ToyNode {name:'Joyce', job:'store clerk'})
```

### Inspect the result
```cypher
match (n:ToyNode)-[r]-(m) return n, r, m
```

### Correcting our mistake
```cypher
match (n:ToyNode {name:'Joyce'})-[r]-(m) delete n, r, m
```

### Add another node and edge correctly to the graph
```cypher
match (n:ToyNode {name:'Julian'}) 
merge (n)-[:ToyRelation {relationship: 'fiancee'}]->(m:ToyNode {name:'Joyce', job:'store clerk'})
match (n:ToyNode)-[r]-(m) return n, r, m
```

### Modify a Node’s Information
```cypher
match (n:ToyNode) where n.name = 'Harry' set n.job = 'drummer'
match (n:ToyNode)-[r]-(m) return n, r, m
```

### Modify a Node’s Information part 2
```cypher
match (n:ToyNode) where n.name = 'Harry' set n.job = n.job + ['lead guitarist']
match (n:ToyNode)-[r]-(m) return n, r, m
```
