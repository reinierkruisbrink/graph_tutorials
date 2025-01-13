### Create our ‘Toy’ network
```cypher
create (N1:ToyNode {name: 'Tom'}) - [:ToyRelation {relationship: 'knows'}] -> (N2:ToyNode {name: 'Harry'}), 
(N2) - [:ToyRelation {relationship: 'co-worker'}] -> (N3:ToyNode {name: 'Julian', job: 'plumber'}), 
(N2) - [:ToyRelation {relationship: 'wife'}] -> (N4:ToyNode {name: 'Michele', job: 'accountant'}), 
(N1) - [:ToyRelation {relationship: 'wife'}] -> (N5:ToyNode {name: 'Josephine', job: 'manager'}), 
(N4) - [:ToyRelation {relationship: 'friend'}] -> (N5) 
```

### Explore the graph network
```cypher
match (n:ToyNode)-[r]-(m) return n, r, m
```

### Delete all nodes and edges
```cypher
match (n)-[r]-() delete n, r
```

### Delete all nodes which have no edges
```cypher
match (n) delete n
```

### Delete only ToyNode nodes which have no edges
```cypher
match (n:ToyNode) delete n
```

### Delete all edges
```cypher
match (n)-[r]-() delete r
```

### Delete only ToyRelation edges
```cypher
match (n)-[r:ToyRelation]-() delete r
```

### Selecting an existing single ToyNode node 
```cypher
match (n:ToyNode {name:'Julian'}) return n   
```