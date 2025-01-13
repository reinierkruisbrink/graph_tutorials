### Import the vertices
```scala
Source.fromFile("./EOADATA/metro.csv").getLines().take(5).foreach(println)
Source.fromFile("./EOADATA/country.csv").getLines().take(5).foreach(println)
Source.fromFile("./EOADATA/metro_country.csv").getLines().take(5).foreach(println)
```

### Create classes
```scala
class PlaceNode(val name: String) extends Serializable
case class Metro(override val name: String, population: Int) extends PlaceNode(name)
case class Country(override val name: String) extends PlaceNode(name)
```

### Load the data from metros.csv
```scala
val metros: RDD[(VertexId, PlaceNode)] =
  sc.textFile("./EOADATA/metro.csv").
    filter(! _.startsWith("#")).
    map {line =>
      val row = line split ','
      (0L + row(0).toInt, Metro(row(1), row(2).toInt))
    }
```

### Load the data from country.csv
```scala
val countries: RDD[(VertexId, PlaceNode)] =
  sc.textFile("./EOADATA/country.csv").
    filter(! _.startsWith("#")).
    map {line =>
      val row = line split ','
      (100L + row(0).toInt, Country(row(1)))
    }
```

### Import the edges
```scala
val mclinks: RDD[Edge[Int]] =
  sc.textFile("./EOADATA/metro_country.csv").
    filter(! _.startsWith("#")).
    map {line =>
      val row = line split ','
      Edge(0L + row(0).toInt, 100L + row(1).toInt, 1)
    }
```

### Create a graph
```scala
val nodes = metros ++ countries
val metrosGraph = Graph(nodes, mclinks)
```

### Print the first 5 vertices and edges
```scala
metrosGraph.vertices.take(5)
metrosGraph.edges.take(5)
```

### Using Spark’s filter method to return Vertices in the graph
```scala
metrosGraph.edges.filter(_.srcId == 1).map(_.dstId).collect()
```

### Filter all of the edges in metrosGraph where the destination vertexId is 103
```scala
metrosGraph.edges.filter(_.dstId == 103).map(_.srcId).collect()
```