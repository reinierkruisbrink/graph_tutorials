### Print the number of edges
```scala
metrosGraph.numEdges
```

### Print the number of vertices
```scala
metrosGraph.numVertices
```

### Define a min and max function for Spark’s reduce method.
```scala
def max(a: (VertexId, Int), b: (VertexId, Int)): (VertexId, Int) = {
  if (a._2 > b._2) a else b
}
def min(a: (VertexId, Int), b: (VertexId, Int)): (VertexId, Int) = {
  if (a._2 <= b._2) a else b
}
```

### Find the vertex with the highest outdegree
```scala
metrosGraph.outDegrees.reduce(max)
```

### Print the returned vertex
```scala
metrosGraph.vertices.filter(_._1 == <<fill this in>>).collect()
```

### Find the vertex with the highest indegree
```scala
metrosGraph.inDegrees.reduce(max)
```

### Print the returned vertex
```scala
metrosGraph.vertices.filter(_._1 == <<fill this in>>).collect()
```

### Find the number vertexes that have only one out edge
```scala
metrosGraph.outDegrees.filter(_._2 <= 1).count
```

### Find the maximum and minimum degrees of the connections in the network
```scala
metrosGraph.degrees.reduce(max)
metrosGraph.degrees.reduce(min)
```

### Print the histogram data of the degrees for countries only.
```scala
metrosGraph.degrees.
  filter { case (vid, count) => vid >= 100 }. // Apply filter so only VertexId < 100 (countries) are included
  map(t => (t._2,t._1)).
  groupByKey.map(t => (t._1,t._2.size)).
  sortBy(_._1).collect()
```
